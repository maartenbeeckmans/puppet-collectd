#class collectd::plugin::elasticsearch
class collectd::plugin::elasticsearch (
  $es_clustername     = 'elasticsearch',
  $enable_index_stats = false,
)
{

  include collectd::plugin::python
  file { '/usr/local/collectd-plugins/elasticsearch.py':
    ensure => 'file',
    group  => 'root',
    mode   => '0644',
    owner  => 'root',
    source => 'puppet:///modules/collectd/plugin/elasticsearch.py',
  }

  file { '/etc/collectd.d/elasticsearch.conf':
    ensure  => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    content => template('collectd/elasticsearch.conf.erb'),
    require => File['/usr/local/collectd-plugins/elasticsearch.py'],
    notify  => Service['collectd'],
  }

}
