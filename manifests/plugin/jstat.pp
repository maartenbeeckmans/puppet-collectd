#
define collectd::plugin::jstat (
  $user,
  $process_name = $title,
  $java_version = '1.8.0',
) {

  if !defined(Package["java-${java_version}-openjdk-devel"]) {
    package { "java-${java_version}-openjdk-devel":
      ensure => present,
    }
  }

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
