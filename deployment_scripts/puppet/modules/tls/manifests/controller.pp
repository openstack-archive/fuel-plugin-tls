class tls::controller(
  $horizon_crt,
  $horizon_key,
  $external_ip,
  $bind_address
) {
  $server_hostname = $external_ip
  include tls::params
  $apache_tls_path = $tls::params::apache_tls_path
  
  #format crt and key files
  file { "$apache_tls_path" :
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
  }
  
  file { '/etc/nova/tls' :
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    before  => Exec['format.sh']
  }

  file {'format.sh':
       path   =>'/usr/bin/format.sh',
       mode   => '0744',
       owner  => root,
       group  => root,
       source => "puppet:///modules/tls/format.sh",
       require => File["$apache_tls_path"]
   }
   exec {'format.sh':
       command => "bash -c \"format.sh \'${horizon_crt}\' \'${horizon_key}\' \'${apache_tls_path}\'\"",
       path => '/usr/sbin:/usr/bin:/sbin:/bin',
       require => File['format.sh'],
       before  => File['openstack-dashboard.conf'],
   }
  class { 'tls::horizon::horizon':
    horizon_crt   =>  $horizon_crt,
    horizon_key   =>  $horizon_key,
    bind_address   =>  $bind_address
  }  
  class { 'tls::nova::novnc_controller':
    server_hostname   =>  $server_hostname,
    novnc_service   =>  $tls::params::nova_novnc_service,
    httpd_service   =>  $tls::params::httpd_service_name      
  }  
}
  
