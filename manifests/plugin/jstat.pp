#
define collectd::plugin::jstat (
  $user,
  $process_name = $title,
) {

  if !defined(File['/usr/local/collectd-plugins/jstat.sh']) {
    file { '/usr/local/collectd-plugins/jstat.sh':
      ensure => 'file',
      group  => 'root',
      mode   => '0755',
      owner  => 'root',
      source => 'puppet:///modules/collectd/plugin/jstat.sh',
    }
  }

  file { "/etc/collectd.d/jstat_${process_name}.conf":
    ensure  => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    content => template('collectd/jstat.conf.erb'),
    require => File['/usr/local/collectd-plugins/jstat.sh'],
    notify  => Service['collectd'],
  }

}
