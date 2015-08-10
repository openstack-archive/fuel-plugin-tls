class tls::params {
  if $::osfamily == 'Debian' {
    $httpd_service_name 	  = 'apache2'
    $horizon_settings_file 	= '/etc/openstack-dashboard/local_settings.py'
    $usergroup 				      = 'nogroup'
	  $nova_compute_service 	= 'nova-compute'
	  $nova_novnc_service 	  = 'nova-novncproxy'
    $apache_tls_path 		    = '/etc/apache2/TLS'
    $tls_cert_file			    = '/etc/apache2/TLS/horizon.crt'
    $tls_key_file			      = '/etc/apache2/TLS/horizon.key'
    $tls_ca_file            = '/etc/apache2/TLS/horizon.ca'
    $root_url               = '/horizon'
  } elsif($::osfamily == 'RedHat') {
    $httpd_service_name 	  = 'httpd'
    $horizon_settings_file 	= '/etc/openstack-dashboard/local_settings'
    $usergroup 				      = 'nobody'
    $nova_compute_service 	= 'openstack-nova-compute'
    $nova_novnc_service 	  = 'openstack-nova-novncproxy'	
    $apache_tls_path 		    = '/etc/httpd/TLS'
    $tls_cert_file			    = '/etc/httpd/TLS/horizon.crt'
    $tls_key_file			      = '/etc/httpd/TLS/horizon.key'
    $tls_ca_file            = '/etc/httpd/TLS/horizon.ca'
    $root_url               = '/dashboard'
  } else {
    fail("unsupported family ${::osfamily}")
  }
}
