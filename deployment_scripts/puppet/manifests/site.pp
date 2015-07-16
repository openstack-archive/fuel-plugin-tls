$tls_hash    			= hiera('tls')
$horizon_crt			= $tls_hash['horizon_crt']
$horizon_key			= $tls_hash['horizon_key']
$horizon_ca				= $tls_hash['horizon_ca']
$nodes_hash       		= hiera('nodes')
$controllers 			= hiera('controllers')
$public_virtual_ip  	= hiera('public_vip')
$internal_virtual_ip 	= hiera('management_vip')
class { 'tls::controller':
	controllers			=> $controllers,
	public_virtual_ip	=> $public_virtual_ip,
	internal_virtual_ip	=> $internal_virtual_ip,
    horizon_crt         =>  $horizon_crt,
    horizon_key         =>  $horizon_key,
    horizon_ca          =>  $horizon_ca,
    external_ip         =>  $public_virtual_ip
}
  
  
