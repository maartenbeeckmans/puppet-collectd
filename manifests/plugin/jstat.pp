#
define collectd::plugin::jstat (
  $user,
  $process_name = $title,
  $java_version = '1.8.0',
  $sudo         = false,
) {

  if !defined(Package["java-${java_version}-openjdk-devel"]) {
    package { "java-${java_version}-openjdk-devel":
      ensure => present,
      notify => Service['collectd'],
    }
  }

  if !defined(File['/usr/local/collectd-plugins/jstat.sh']) {
    file { '/usr/local/collectd-plugins/jstat.sh':
      ensure => 'file',
      group  => 'root',
      mode   => '0755',
      owner  => 'root',
      source => 'puppet:///modules/collectd/plugin/jstat.sh',
      notify => Service['collectd'],
    }
  }

  $_process_name = regsubst($process_name, '/', '_', 'G')

  if $sudo {
    sudo::conf{"jstat_${_process_name}.conf":
      content => "#puppet\nDefaults:${user} !requiretty
      ${user} ALL=(ALL) NOPASSWD:/bin/jps,/bin/jstat\n",
    }
  }

  file { "/etc/collectd.d/jstat_${_process_name}.conf":
    ensure  => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    content => template('collectd/jstat.conf.erb'),
    require => File['/usr/local/collectd-plugins/jstat.sh'],
    notify  => Service['collectd'],
  }

}
