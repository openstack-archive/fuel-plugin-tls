$tls_hash    			  = hiera('tls')
$horizon_crt				= $tls_hash['horizon_crt']
$horizon_key				= $tls_hash['horizon_key']
$nodes_hash       	= hiera('nodes')
$public_ip  	      = hiera('public_vip')
$internal_ip 	      = hiera('management_vip')

class { 'tls::compute':
  public_virtual_ip   => $public_ip,
  internal_virtual_ip => $internal_ip,
}