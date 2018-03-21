#
class collectd::plugin::rabbitmq (
  $collectd_rabbitmq_user     = hiera('collectd_rabbitmq_user', ''),
  $collectd_rabbitmq_password = hiera('collectd_rabbitmq_password', ''),
  $ignore_queues_regexp       = [],
  $ignore_exchanges_regexp    = [],
) {

  validate_array($ignore_queues_regexp)
  validate_array($ignore_exchanges_regexp)

  #package { 'collectd-perl':
  #  ensure => 'present',
  #}

  file { '/usr/local/collectd-plugins/collectd_rabbitmq':
    ensure  => 'directory',
    group   => '0',
    mode    => '0755',
    owner   => '0',
    require => File['/usr/local/collectd-plugins/'],
    notify  => Service['collectd'],
  }

  file { '/usr/local/collectd-plugins/Collectd/':
    ensure  => 'directory',
    group   => '0',
    mode    => '0755',
    owner   => '0',
    require => File['/usr/local/collectd-plugins/'],
    notify  => Service['collectd'],
  }
  file { '/usr/local/collectd-plugins/collectd_rabbitmq/__init__.py':
    source  => 'puppet:///modules/collectd/plugin/rabbitmq/__init__.py',
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/collectd_rabbitmq'],
    notify  => Service['collectd'],
  }
  file { '/usr/local/collectd-plugins/collectd_rabbitmq/collectd_plugin.py':
    source  => 'puppet:///modules/collectd/plugin/rabbitmq/collectd_plugin.py',
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/collectd_rabbitmq'],
    notify  => Service['collectd'],
  }
  file { '/usr/local/collectd-plugins/collectd_rabbitmq/rabbit.py':
    source  => 'puppet:///modules/collectd/plugin/rabbitmq/rabbit.py',
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/collectd_rabbitmq'],
    notify  => Service['collectd'],
  }
  file { '/usr/local/collectd-plugins/collectd_rabbitmq/utils.py':
    source  => 'puppet:///modules/collectd/plugin/rabbitmq/utils.py',
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/collectd_rabbitmq'],
    notify  => Service['collectd'],
  }
  file { '/usr/share/collectd/types.db.rabbitmq':
    source  => 'puppet:///modules/collectd/plugin/rabbitmq/types.db.rabbitmq',
    mode    => '0644',
    require => Package['collectd'],
    notify  => Service['collectd'],
  }

  #file { '/usr/local/collectd-plugins/Collectd/Plugins/':
  #  ensure  => 'directory',
  #  group   => '0',
  #  mode    => '0755',
  #   owner   => '0',
  #  require => File['/usr/local/collectd-plugins/Collectd'],
  #}
  #file { '/usr/local/collectd-plugins/Collectd/Plugins/RabbitMQ.pm':
  #  source  => 'puppet:///modules/collectd/RabbitMQ.pm',
  #  mode    => '0644',
  #  require => File['/usr/local/collectd-plugins/Collectd/Plugins'],
  #}

  file_line { 'cpusummaryline':
    path    => '/usr/share/collectd/types.db',
    line    => 'cpusummary              user:COUNTER:U:U, nice:COUNTER:U:U, system:COUNTER:U:U, idle:COUNTER:U:U, iowait:COUNTER:U:U, irq:COUNTER:U:U, softirq:COUNTER:U:U, cpucount:GAUGE:U:U',
    match   => '^cpusummary\s+',
    require => Package['collectd'],
    notify  => Service['collectd'],
  }

  file_line { 'rabbitmqline':
    path    => '/usr/share/collectd/types.db',
    line    => 'rabbitmq                messages:GAUGE:0:U, messages_rate:GAUGE:0:U, messages_unacknolwedged:GAUGE:0:U, messages_unacknowledged_rate:GAUGE:0:U, messages_ready:GAUGE:0:U, message_ready_rate:GAUGE:0:U, memory:GAUGE:0:U, consumers:GAUGE:0:U, publish:GAUGE:0:U, publish_rate:GAUGE:0:U, deliver_no_ack:GAUGE:0:U, deliver_no_ack_rate:GAUGE:0:U, deliver_get:GAUGE:0:U, deliver_get_rate:GAUGE:0:U',
    match   => '^rabbitmq\s+',
    require => Package['collectd'],
    notify  => Service['collectd'],
  }

  file { '/etc/collectd.d/RabbitMQ.conf':
    content => template('collectd/plugin/RabbitMQ.conf.erb'),
    group   => '0',
    mode    => '0644',
    owner   => '0',
    require => Package['collectd'],
    notify  => Service['collectd'],
  }
}
