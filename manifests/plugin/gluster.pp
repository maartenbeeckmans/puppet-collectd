#
class collectd::plugin::gluster () {

  package { 'python2-psutil':
    ensure => 'present',
  }

  file { '/usr/local/collectd-plugins/collectd_gluster':
    ensure  => 'directory',
    group   => '0',
    mode    => '0755',
    owner   => '0',
    require => File['/usr/local/collectd-plugins/'],
    notify  => Service['collectd'],
  }

  file { '/usr/local/collectd-plugins/collectd_gluster/__init__.py':
    source  => 'puppet:///modules/collectd/plugin/gluster/__init__.py',
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/collectd_gluster'],
    notify  => Service['collectd'],
  }
  file { '/usr/local/collectd-plugins/collectd_gluster/gluster.py':
    source  => 'puppet:///modules/collectd/plugin/gluster/gluster.py',
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/collectd_gluster'],
    notify  => Service['collectd'],
  }
  file { '/usr/local/collectd-plugins/collectd_gluster/gluster_utils.py':
    source  => 'puppet:///modules/collectd/plugin/gluster/gluster_utils.py',
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/collectd_gluster'],
    notify  => Service['collectd'],
  }
  file { '/usr/local/collectd-plugins/collectd_gluster/ini2json.py':
    source  => 'puppet:///modules/collectd/plugin/gluster/ini2json.py',
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/collectd_gluster'],
    notify  => Service['collectd'],
  }

  file { '/usr/local/collectd-plugins/collectd_gluster/gluster_plugins':
    ensure  => 'directory',
    group   => '0',
    mode    => '0755',
    owner   => '0',
    require => File['/usr/local/collectd-plugins/collectd_gluster'],
    notify  => Service['collectd'],
  }

  file { '/usr/local/collectd-plugins/collectd_gluster/gluster_plugins/__init__.py':
    source  => 'puppet:///modules/collectd/plugin/gluster/gluster_plugins/__init__.py',
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/collectd_gluster/gluster_plugins'],
    notify  => Service['collectd'],
  }
  file { '/usr/local/collectd-plugins/collectd_gluster/gluster_plugins/brick_stats.py':
    source  => 'puppet:///modules/collectd/plugin/gluster/gluster_plugins/brick_stats.py',
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/collectd_gluster/gluster_plugins'],
    notify  => Service['collectd'],
  }
  file { '/usr/local/collectd-plugins/collectd_gluster/gluster_plugins/volume_stats.py':
    source  => 'puppet:///modules/collectd/plugin/gluster/gluster_plugins/volume_stats.py',
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/collectd_gluster/gluster_plugins'],
    notify  => Service['collectd'],
  }

  file { '/usr/share/collectd/types.db.gluster':
    source  => 'puppet:///modules/collectd/plugin/gluster/types.db.gluster',
    mode    => '0644',
    require => Package['collectd'],
    notify  => Service['collectd'],
  }

  file { '/etc/collectd.d/gluster.conf':
    content => template('collectd/plugin/gluster.conf.erb'),
    group   => '0',
    mode    => '0644',
    owner   => '0',
    require => Package['collectd'],
    notify  => Service['collectd'],
  }
}
