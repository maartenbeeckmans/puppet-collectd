# Class: collectd::plugin::interface
#
#
class collectd::plugin::interface (
  $interfaces = [
    'lo',
    '/^veth/',
    '/^tun[0-9]+/',
    '/^virbr[0-9]+/',
    '/^vnet[0-9]+/',
    'ip_vti0',
    'gretap0',
    'gre0',
  ],
  $ignore_selected = true,
) {

  file { "${::collectd::config_dir}/interface.conf":
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/plugin/interface.conf.erb"),
    notify  => Service[$::collectd::service_name],
  }

}
