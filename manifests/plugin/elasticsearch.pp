#class collectd::plugin::elasticsearch
class collectd::plugin::elasticsearch (
  $detailed_metrics   = false,
  $es_clustername     = 'elasticsearch',
  $enable_index_stats = false,
  $enable_ssl         = false,
  $username           = 'collectd',
  $password           = 'collectd',
) {

  include collectd::plugin::python
  file { '/usr/local/collectd-plugins/elasticsearch_collectd.py':
    ensure => 'file',
    group  => 'root',
    mode   => '0644',
    owner  => 'root',
    source => 'puppet:///modules/collectd/plugin/elasticsearch_collectd.py',
    notify => Service['collectd'],
  }

  file { '/etc/collectd.d/elasticsearch.conf':
    ensure  => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    content => template('collectd/elasticsearch.conf.erb'),
    require => File['/usr/local/collectd-plugins/elasticsearch_collectd.py'],
    notify  => Service['collectd'],
  }

}
