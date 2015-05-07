$fuel_settings 			= parseyaml(file('/etc/astute.yaml')) 
$tls_hash    			  = $::fuel_settings['tls']
$horizon_crt				= $tls_hash['horizon_crt']
$horizon_key				= $tls_hash['horizon_key']
$nodes_hash       			= $::fuel_settings['nodes']
if ($::fuel_settings['deployment_mode'] == 'multinode') {   
  $controller 				= filter_nodes($nodes_hash,'role','controller')
  $controller_node_public 	= $controller[0]['public_address'] 
	class  { 'tls::controller':
    horizon_crt 	=>	$horizon_crt,
	  horizon_key 	=>	$horizon_key,
	  external_ip 	=>  $controller_node_public,
	  bind_address  =>  $controller_node_public
  }
}
else {
	$controllers 			= concat(filter_nodes($nodes_hash,'role','primary-controller'), filter_nodes($nodes_hash,'role','controller'))
	$public_virtual_ip  	= $::fuel_settings['public_vip']
	$internal_virtual_ip 	= $::fuel_settings['management_vip']
	class { 'tls::controller_ha':
		controllers			=> $controllers,
		public_virtual_ip	=> $public_virtual_ip,
		internal_virtual_ip	=> $internal_virtual_ip,
    horizon_crt   =>  $horizon_crt,
    horizon_key   =>  $horizon_key,
    external_ip   =>  $public_virtual_ip
	}
}
  
  
