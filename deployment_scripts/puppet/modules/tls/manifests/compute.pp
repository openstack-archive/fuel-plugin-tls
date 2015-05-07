class tls::compute(
  $public_virtual_ip,
  $internal_virtual_ip,
) {
  include tls::params
  class { 'tls::nova::novnc_compute':
    public_virtual_ip => $public_virtual_ip,
    internal_virtual_ip => $internal_virtual_ip,
    nova_compute_service => $tls::params::nova_compute_service
  }
}
  
