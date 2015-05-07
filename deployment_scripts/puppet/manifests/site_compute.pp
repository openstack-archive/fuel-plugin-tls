$fuel_settings 			= parseyaml(file('/etc/astute.yaml'))
$tls_hash    			  = $::fuel_settings['tls']
$horizon_crt				= $tls_hash['horizon_crt']
$horizon_key				= $tls_hash['horizon_key']
$nodes_hash       	= $::fuel_settings['nodes']
 
if ($::fuel_settings['deployment_mode'] == 'multinode') { 
  $controller 	    = filter_nodes($nodes_hash,'role','controller')
  $internal_ip 	    = $controller[0]['internal_address']
  $public_ip 	      = $controller[0]['public_address'] 
}
else { 
	$public_ip  	    = $::fuel_settings['public_vip']
	$internal_ip 	    = $::fuel_settings['management_vip']
}
class { 'tls::compute':
  public_virtual_ip   => $public_ip,
  internal_virtual_ip => $internal_ip,
}