class tls::horizon::horizon_ha (
  $controllers,
  $public_virtual_ip,
  $internal_virtual_ip,
) {

  require tls::horizon::horizon
  include tls::params

  Haproxy::Service        { use_include => true }
  Haproxy::Balancermember { use_include => true }

  $haproxy_config_options = {
   'option'      => ['ssl-hello-chk', 'tcpka'],
   'stick-table' => 'type ip size 200k expire 30m',
   'stick'       => 'on src',
   'balance'     => 'source',
   'timeout'     => ['client 3h', 'server 3h'],
   'mode'        => 'tcp',
  }

  haproxy::listen { 'horizon-ssl':
    order     => '017',
    ipaddress => $public_virtual_ip,
    ports     => '443',
    options   => $haproxy_config_options,
    mode      => 'tcp',
  }

  haproxy::balancermember { 'horizon-ssl':
    order             => '017',
    listening_service => 'horizon-tls',
    server_names      => filter_hash($controllers, 'name'),
    ipaddresses       => filter_hash($controllers, 'internal_address'),
    ports             => '443',
    options           => 'weight 1 check',
    define_cookies    => false,
    define_backups    => false,
  }
  
  ##################################################################################
  
  $haproxy_config_options_nova = {
   'option'      => ['ssl-hello-chk', 'tcpka'],
   'mode'        => 'tcp',
  }
 
  haproxy::listen { 'nova-novncproxy':
    order     => '170',
    ipaddress => $public_virtual_ip,
    ports     => '6080',
    options   => $haproxy_config_options_nova,
    mode      => 'tcp',
  }

  haproxy::balancermember { 'nova-novncproxy':
    order             => '170',
    listening_service => 'horizon-tls',
    server_names      => filter_hash($controllers, 'name'),
    ipaddresses       => filter_hash($controllers, 'internal_address'),
    ports             => '6080',
    options           => 'check',
    define_cookies    => false,
    define_backups    => false,
  }
  ######################################################################################

  
  service { 'haproxy':
    enable  => true,
    ensure  => running,
  }

}