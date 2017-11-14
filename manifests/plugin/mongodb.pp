# define collectd::plugin::mongodb
define collectd::plugin::mongodb(
  $mongod_bind_ip   = '127.0.0.1',
  $mongod_bind_port = '27017',
){

  include ::collectd::plugin::python

  ensure_resource('package', 'python-pymongo', {
    ensure   => present,
  })

  ensure_resource( 'file_line', 'mongoline', {
    ensure => present,
    line   => 'replication             value:GAUGE:U:U',
    match  => '^replication\s+',
    path   => '/usr/share/collectd/types.db',
    notify => Service['collectd'],
  })

  # This collectd plugin cannot be called twice and I need to monitor
  # multiple mongo instances on the same host. Hence this script exists
  # for every port and it's still the same :)
  file { "/usr/local/collectd-plugins/mongodb_${mongod_bind_port}.py":
    ensure => 'file',
    group  => 'root',
    mode   => '0644',
    owner  => 'root',
    source => 'puppet:///modules/collectd/plugin/mongodb.py',
    notify => Service['collectd'],
  }

  file { "/etc/collectd.d/mongodb_${mongod_bind_port}.conf":
    ensure  => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    content => template('collectd/mongodb.conf.erb'),
    require => [
      Package['python-pymongo'],
      File["/usr/local/collectd-plugins/mongodb_${mongod_bind_port}.py"],
      File_line['mongoline']
    ],
    notify  => Service['collectd'],
  }

}
