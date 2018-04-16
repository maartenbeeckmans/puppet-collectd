# class collectd::plugin::storm
class collectd::plugin::storm(
  $host = 'localhost',
  $port = 8888,
){

  file { '/usr/local/collectd-plugins/storm.rb':
    ensure => 'file',
    group  => 'root',
    mode   => '0755',
    owner  => 'root',
    source => 'puppet:///modules/collectd/plugin/storm.rb',
    notify => Service['collectd'],
  }

  File_line {
    path   => '/usr/share/collectd/types.db',
    notify => Service['collectd'],
  }

  file_line {
    'storm_acked':
      line  => 'storm_acked            value:COUNTER:0:U',
      match => '^storm_acked ';
    'storm_latency':
      line  => 'storm_latency          value:GAUGE:0:U',
      match => '^storm_latency ';
    'storm_emitted':
      line  => 'storm_emitted          value:GAUGE:0:U',
      match => '^storm_emitted ';
    'storm_transferred':
      line  => 'storm_transferred      value:GAUGE:0:U',
      match => '^storm_transferred ';
  }

  file { '/etc/collectd.d/storm.conf':
    ensure  => 'file',
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
    content => template('collectd/storm.conf.erb'),
    notify  => Service['collectd'],
  }


}
