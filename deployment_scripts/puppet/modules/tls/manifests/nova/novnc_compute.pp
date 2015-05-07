class tls::nova::novnc_compute (
  $public_virtual_ip,
  $internal_virtual_ip,
  $nova_compute_service
) {
  $novncproxy_base_url = "https://${public_virtual_ip}:6080/vnc_auto.html"

  nova_config {
    'DEFAULT/novncproxy_base_url': 	value => $novncproxy_base_url;
    'DEFAULT/ssl_only': 			value => 'True';
  } ~> Service["$nova_compute_service"]
    
  service { "$nova_compute_service":
    enable  => true,
    ensure  => running,
  }
}