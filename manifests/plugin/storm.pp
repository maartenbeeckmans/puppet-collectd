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

  file_line { 
    'storm_acked':
      path    => '/usr/share/collectd/types.db',
      line    => 'storm_acked            value:COUNTER:0:U',
      notify  => Service['collectd'];
    'storm_latency':
      path    => '/usr/share/collectd/types.db',
      line    => 'storm_latency          value:GAUGE:0:U',
      notify  => Service['collectd'];
   'storm_emitted':
      path    => '/usr/share/collectd/types.db',
      line    => 'storm_emitted          value:GAUGE:0:U', 
      notify  => Service['collectd'];
   'storm_transferred':
      path    => '/usr/share/collectd/types.db',
      line    => 'storm_transferred      value:GAUGE:0:U', 
      notify  => Service['collectd'];
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
