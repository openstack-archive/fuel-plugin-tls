$tls_hash               = hiera('tls')
$horizon_crt            = $tls_hash['horizon_crt']
$horizon_key            = $tls_hash['horizon_key']
$horizon_ca             = $tls_hash['horizon_ca']

#do not use hiera for node parameters (see bug 1476957)
$fuel_settings          = parseyaml(file('/etc/astute.yaml')) 
$nodes_hash             = $::fuel_settings['nodes']
$controllers            = concat(filter_nodes($nodes_hash,'role','primary-controller'), filter_nodes($nodes_hash,'role','controller'))
$public_virtual_ip      = $::fuel_settings['public_vip']
$internal_virtual_ip    = $::fuel_settings['management_vip']

$servername             = hiera('public_vip')
$horizon_hash           = hiera_hash('horizon',{})
$cache_server_ip        = hiera('memcache_servers', $controller_nodes)
$cache_server_port      = hiera('memcache_server_port', '11211')
$neutron                = hiera('use_neutron')
$keystone_host          = hiera('management_vip')
$verbose                = hiera('verbose', true)
$debug                  = hiera('debug')
$package_ensure         = hiera('horizon_package_ensure', 'installed')
$use_syslog             = hiera('use_syslog', true)
$nova_quota             = hiera('nova_quota')

class { 'tls::controller':
	controllers			=> $controllers,
	public_virtual_ip	=> $public_virtual_ip,
	internal_virtual_ip	=> $internal_virtual_ip,
    horizon_crt         => $horizon_crt,
    horizon_key         => $horizon_key,
    horizon_ca          => $horizon_ca,
    external_ip         => $public_virtual_ip,
    nodes_hash          => $nodes_hash,
    servername          => $servername,
    horizon_hash        => $horizon_hash,
    cache_server_ip     => $cache_server_ip,
    cache_server_port   => $cache_server_port,
    neutron             => $neutron,
    keystone_host       => $keystone_host,
    verbose             => $verbose,
    debug               => $debug,
    package_ensure      => $package_ensure,
    use_syslog          => $use_syslog,
    nova_quota          => $nova_quota
}
  
  
