#
class collectd::plugin::rabbitmq (
  $collectd_rabbitmq_user     = hiera('collectd_rabbitmq_user', ''),
  $collectd_rabbitmq_password = hiera('collectd_rabbitmq_password', ''),
) {

  file { '/usr/local/collectd-plugins/rabbitmq':
    ensure  => 'directory',
    group   => '0',
    mode    => '0755',
    owner   => '0',
    require => File['/usr/local/collectd-plugins/'],
    notify  => Service['collectd'],
  }
  file { '/usr/local/collectd-plugins/rabbitmq/__init__.py':
    source  => 'puppet:///modules/collectd/plugin/rabbitmq/__init__.py',
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/rabbitmq'],
    notify  => Service['collectd'],
  }
  file { '/usr/local/collectd-plugins/rabbitmq/collectd_plugin.py':
    source  => 'puppet:///modules/collectd/plugin/rabbitmq/collectd_plugin.py',
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/rabbitmq'],
    notify  => Service['collectd'],
  }
  file { '/usr/local/collectd-plugins/rabbitmq/rabbit.py':
    source  => 'puppet:///modules/collectd/plugin/rabbitmq/rabbit.py',
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/rabbitmq'],
    notify  => Service['collectd'],
  }
  file { '/usr/local/collectd-plugins/rabbitmq/utils.py':
    source  => 'puppet:///modules/collectd/plugin/rabbitmq/utils.py',
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/rabbitmq'],
    notify  => Service['collectd'],
  }
  file { '/usr/share/collectd/types.db.rabbitmq':
    source  => 'puppet:///modules/collectd/plugin/rabbitmq/types.db.rabbitmq',
    mode    => '0644',
    require => Package['collectd'],
    notify  => Service['collectd'],
  }

  file { '/etc/collectd.d/RabbitMQ.conf':
    content => template('collectd/RabbitMQ.conf.erb'),
    group   => '0',
    mode    => '0644',
    owner   => '0',
    require => Package['collectd'],
    notify  => Service['collectd'],
  }

}
