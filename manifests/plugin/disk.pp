#
class collectd::plugin::disk{

  if $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '8' {
    package {'collectd-disk':
      ensure => present,
    } 
  }


  file { '/etc/collectd.d/disk.conf':
    source => 'puppet:///modules/collectd/plugin/disk.conf',
    group  => '0',
    mode   => '0644',
    owner  => '0',
    notify => Service['collectd'],

  }
}

