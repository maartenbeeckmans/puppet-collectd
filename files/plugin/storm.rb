#!/usr/bin/env ruby

# Author: Jan Tlusty
# Email:  honza@inuits.eu
# Date:   Thu Mar 02 2017


require 'net/http'
require 'uri'
require 'json'
require 'optparse'

host = 'http://localhost'
port = 8888

interval    = ENV['COLLECTD_INTERVAL'] || 10
hostname = `hostname`.chomp

def usage(optparse)
  puts optparse
  puts 'Usage: ./storm.rb -h <host> -p <port>'
end

optparse = OptionParser.new do |opts|
  opts.on('-h', '--host HOSTNAME', "Hostname") do |f|
    host = f
  end
  opts.on('-p', '--port PORT', "Port") do |f|
    port = f
  end
  opts.on('-H', '--help', "Displays this message") do
    usage(optparse)
    exit 0
  end
end

optparse.parse!


if host !~ /^https?:\/\/.*/
   host = 'http://' + host
end

trap("TERM") {cleanup_children_on_exit}
def cleanup_children_on_exit
        puts "Killing child process: " + @output.pid.to_s
        Process.kill("KILL", @output.pid)
        abort("Caught TERM exiting")
end

STDOUT.sync = true

while true do
        start_run = Time.now.to_i
        next_run = start_run + interval.to_i

        topologies = []
        uri_summary = URI::parse("#{host}:#{port}/api/v1/topology/summary")
        req_summary = Net::HTTP::Get.new(uri_summary)
        res_summary = Net::HTTP.start(uri_summary.hostname, uri_summary.port) {|http|
        http.request(req_summary)}
        json_summary = JSON.parse(res_summary.body)

        json_summary['topologies'].each do |topology|
                topologies.push(
                        {'name' => topology['name'],
                         'id'   => topology['id']
                        }
                )
        end

        topologies.each do |topology|
                uri = URI::parse("#{host}:#{port}/api/v1/topology/#{topology['id']}")
                req = Net::HTTP::Get.new(uri)
                res = Net::HTTP.start(uri.hostname, uri.port) {|http|
                http.request(req)}
                json = JSON.parse(res.body)

                puts "PUTVAL #{hostname}/storm-topologies/storm_latency-#{topology['name']} #{start_run}:#{json['topologyStats'][0]['completeLatency']}"
                puts "PUTVAL #{hostname}/storm-topologies/storm_transferred-#{topology['name']} #{start_run}:#{json['topologyStats'][0]['transferred']}"
                puts "PUTVAL #{hostname}/storm-topologies/storm_emitted-#{topology['name']} #{start_run}:#{json['topologyStats'][0]['emitted']}"


        end

        while((time_left = (next_run - Time.now.to_i)) > 0) do
                sleep(time_left)
        end
end

