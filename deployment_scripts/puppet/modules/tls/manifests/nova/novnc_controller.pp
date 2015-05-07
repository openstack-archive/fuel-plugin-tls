class tls::nova::novnc_controller (
  $server_hostname,
  $novnc_service,
  $httpd_service
) {
  $novncproxy_base_url = "https://${server_hostname}:6080/vnc_auto.html"

  nova_config {
    'DEFAULT/novncproxy_base_url':  value => $novncproxy_base_url;
    'DEFAULT/ssl_only':       value => 'True';
    'DEFAULT/cert':         value => '/etc/nova/tls/nova.crt';
    'DEFAULT/key':          value => '/etc/nova/tls/nova.key';
  } ~> Service["$novnc_service"]

  service { "$novnc_service":
    enable  => true,
    ensure  => running,
  }

  service { $httpd_service:
    enable  => true,
    ensure  => running,
  }
}