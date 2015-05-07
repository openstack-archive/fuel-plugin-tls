class tls::controller_ha(
  $controllers,
  $public_virtual_ip,
  $internal_virtual_ip,
  $horizon_crt,
  $horizon_key,
  $external_ip
) {
  $nodes_hash = $::fuel_settings['nodes']
  $node = filter_nodes($nodes_hash,'name',$::hostname)
  $internal_address = $node[0]['internal_address']
  $bind_address = $internal_address
  class { 'tls::controller':
    horizon_crt   =>  $horizon_crt,
    horizon_key   =>  $horizon_key,
    external_ip   =>  $external_ip,
    bind_address   =>  $bind_address
  }    
  class { 'tls::horizon::horizon_ha':
    controllers           =>  $controllers,
    public_virtual_ip     =>  $public_virtual_ip,
    internal_virtual_ip   =>  $internal_virtual_ip,
  }
  exec { "ha_proxy_restart":
    command => "/usr/sbin/crm resource restart p_haproxy",
    require => Class['tls::horizon::horizon_ha'],
  }
}
  
