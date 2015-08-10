$tls_hash           = hiera('tls')
$horizon_crt        = $tls_hash['horizon_crt']
$horizon_key        = $tls_hash['horizon_key']
$nodes_hash         = hiera('nodes')
$public_ip          = hiera('public_vip')
$internal_ip        = hiera('management_vip')

#do not use hiera for node parameters (see bug 1476957)
$fuel_settings          = parseyaml(file('/etc/astute.yaml')) 
$public_virtual_ip      = $::fuel_settings['public_vip']
$internal_virtual_ip    = $::fuel_settings['management_vip']

class { 'tls::compute':
  public_virtual_ip   => $public_ip,
  internal_virtual_ip => $internal_ip,
}