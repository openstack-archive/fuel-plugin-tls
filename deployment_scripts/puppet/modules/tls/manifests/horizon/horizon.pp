class tls::horizon::horizon(
  $horizon_crt,
  $horizon_key,
  $bind_address,
) {
  include tls::params

  $root_url       = $tls::params::root_url
  $ssl_cert_file  = $tls::params::tls_cert_file
  $ssl_key_file   = $tls::params::tls_key_file
  
  #update horizon config file
  exec { "USE_SSL":
    command => "/bin/sed -i \"s/#USE_SSL = False/USE_SSL = True/\" $tls::params::horizon_settings_file",
    unless  => "/bin/egrep \"^USE_SSL = True\" $tls::params::horizon_settings_file",
    notify  => Service[$tls::params::httpd_service_name],
  }
  exec { "CSRF_COOKIE_SECURE":
    command => "/bin/sed -i \"s/#CSRF_COOKIE_SECURE = True/CSRF_COOKIE_SECURE = True/\" $tls::params::horizon_settings_file",
    unless  => "/bin/egrep \"^CSRF_COOKIE_SECURE = True\" $tls::params::horizon_settings_file",
    notify  => Service[$tls::params::httpd_service_name],
  }
  exec { "SESSION_COOKIE_SECURE":
    command => "/bin/sed -i \"s/#SESSION_COOKIE_SECURE = True/SESSION_COOKIE_SECURE = True/\" $tls::params::horizon_settings_file",
    unless  => "/bin/egrep \"^SESSION_COOKIE_SECURE = True\" $tls::params::horizon_settings_file",
    notify  => Service[$tls::params::httpd_service_name],
  }
  exec { "SESSION_COOKIE_HTTPONLY":
    command => "/bin/sed -i /SESSION_COOKIE_SECURE/i\"SESSION_COOKIE_HTTPONLY = True\" $tls::params::horizon_settings_file",
    unless  => "/bin/egrep \"^SESSION_COOKIE_HTTPONLY = True\" $tls::params::horizon_settings_file",
    notify  => Service[$tls::params::httpd_service_name],
  }

  if $::osfamily == 'Debian' {
    exec { "ssl_mod":
    command => "/usr/sbin/a2enmod ssl",
    notify  => Service[$tls::params::httpd_service_name],
    }
    exec { "header_mod":
    command => "/usr/sbin/a2enmod headers",
    notify  => Service[$tls::params::httpd_service_name],
    }
    exec { "rewrite":
    command => "/usr/sbin/a2enmod rewrite",
    notify  => Service[$tls::params::httpd_service_name],
    }
  } elsif($::osfamily == 'RedHat') {
    package { 'mod_ssl':
    ensure => present,
    notify  => Service[$tls::params::httpd_service_name],
    }
  }

  #update apache config file 
  file { 'openstack-dashboard.conf' :
    ensure  => present,
    path    => $tls::params::apache_conf_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('tls/openstack-dashboard.conf.erb'),
    notify  => Service[$tls::params::httpd_service_name],
  }

  file { 'port.conf' :
    ensure  => present,
    path    => $tls::params::apache_port_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('tls/port.conf.erb'),
    notify  => Service[$tls::params::httpd_service_name],
  }

  file { 'vhost.conf' :
    ensure  => present,
    path    => $tls::params::apache_vhost_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('tls/vhost.erb'),
    notify  => Service[$tls::params::httpd_service_name],
  }

}
