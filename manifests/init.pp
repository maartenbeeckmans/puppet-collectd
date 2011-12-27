# Class: collectd
#
# This module manages collectd
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]

class collectd::graphitewriter ( $graphitehost, $grahpiteport) { 

  notify {"Value Host is ${graphitehost}.":}
  notify {"Value Port is ${graphiteport}.":}

  file { '/usr/local/collectd-plugins/':
    ensure => 'directory', 
    group  => '0',
    mode   => '755',
    owner  => '0',
    type   => 'directory',
}
  file { '/usr/local/collectd-plugins/carbon_writer.py': 
    ensure => 'file',
    group  => '0',
    mode   => '644',
    owner  => '0',
    source => 'puppet:///collectd/collectd-carbon/carbond_writer.py'
}



  file {
     "/etc/collect.d/graphite-writer.conf":
       group   => '0',
       mode    => '644',
       owner   => '0',
       require => Package['collectd'],
       content => template("collectd/graphite-writer.conf.erb");
   }

}



class collectd  { 


  package {"collectd":
    ensure => present;
  }

  # Required with a patch to include they Python LDLIB path as documented 
  # on  https://github.com/indygreg/collectd-carbon
  file {
    "/etc/init.d/collectd":
      group  => '0',
      mode   => '755',
      owner  => '0',
      source => "puppet:///collectd/collectd";
  }




  service {"collectd":
    ensure  => present,
    require => [File['/etc/init.d/collectd'],Package['collectd']];
  }
}
