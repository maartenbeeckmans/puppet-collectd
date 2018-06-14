# Class: collectd::plugin::interface
#
#
class collectd::plugin::interface (
  $interfaces = ['lo', '/^veth/','/^tun[0-9]+/'],
  $ignore_selected = true,
) {

  file { "${::collectd::config_dir}/interface.conf":
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/plugin/interface.conf.erb"),
    notify  => Service[$::collectd::service_name],
  }

}
