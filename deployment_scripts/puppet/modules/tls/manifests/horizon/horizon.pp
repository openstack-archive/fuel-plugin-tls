class tls::horizon::horizon(
  $bind_address = '*',
  $controllers,
  $public_virtual_ip,
  $internal_virtual_ip,
  $servername,
  $horizon_hash,
  $cache_server_ip,
  $cache_server_port,
  $neutron,
  $keystone_host,
  $verbose,
  $debug,
  $package_ensure,
  $use_syslog,
  $nova_quota  
) {
  include tls::params
  $ssl_port                       = 443
  $root_url                       = $tls::params::root_url
  $horizon_cert                   = $tls::params::tls_cert_file
  $horizon_key                    = $tls::params::tls_key_file
  $horizon_ca                     = $tls::params::tls_ca_file
  $controller_internal_addresses  = nodes_to_hash($controllers,'name','internal_address')
  $controller_nodes               = ipsort(values($controller_internal_addresses))
  $swift                          = false
  $horizon_app_links              = undef
  $keystone_scheme                = 'http'
  $keystone_default_role          = '_member_'
  $api_result_limit               = 1000
  $use_ssl                        = true
  $log_level                      = 'WARNING'
  $local_settings_template        = 'openstack/horizon/local_settings.py.erb'
  $django_session_engine          = 'django.contrib.sessions.backends.cache'
  $cache_backend                  = 'horizon.backends.memcached.HorizonMemcached'
  $cache_options                  = ["'SOCKET_TIMEOUT': 1","'SERVER_RETRIES': 1","'DEAD_RETRY': 1"]
  
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

  if $horizon_hash['secret_key'] {
    $secret_key = $horizon_hash['secret_key']
  } else {
    $secret_key = 'dummy_secret_key'
  }

  if $debug { #syslog and nondebug case
    #We don't realy want django debug, it is too verbose.
    $django_debug   = false
    $django_verbose = false
    $log_level_real = 'DEBUG'
  } elsif $verbose {
    $django_verbose = true
    $django_debug   = false
    $log_level_real = 'INFO'
  } else {
    $django_verbose = false
    $django_debug   = false
    $log_level_real = $log_level
  }

  apache::listen{ $ssl_port:}
  apache::namevirtualhost{ "*:$ssl_port":}

  class { '::horizon':
    bind_address            => $bind_address,
    cache_server_ip         => $cache_server_ip,
    cache_server_port       => $cache_server_port,
    cache_backend           => $cache_backend,
    cache_options           => $cache_options,
    secret_key              => $secret_key,
    swift                   => $swift,
    package_ensure          => $package_ensure,
    horizon_app_links       => $horizon_app_links,
    keystone_host           => $keystone_host,
    keystone_scheme         => $keystone_scheme,
    keystone_default_role   => $keystone_default_role,
    django_debug            => $django_debug,
    api_result_limit        => $api_result_limit,
    listen_ssl              => $use_ssl,
    log_level               => $log_level_real,
    local_settings_template => $local_settings_template,
    configure_apache        => false,
    django_session_engine   => $django_session_engine,
    allowed_hosts           => '*',
    secure_cookies          => false,
    horizon_cert           => $horizon_cert ,
    horizon_key            => $horizon_key,
    horizon_ca             => $horizon_ca
  }

  # Performance optimization for wsgi
  if ($::memorysize_mb < 1200 or $::processorcount <= 3) {
    $wsgi_processes = 2
    $wsgi_threads = 9
  } else {
    $wsgi_processes = $::processorcount
    $wsgi_threads = 15
  }

  class { '::horizon::wsgi::apache':
    priority       => false,
    servername     => $public_virtual_ip,
    bind_address   => $bind_address,
    wsgi_processes => $wsgi_processes,
    wsgi_threads   => $wsgi_threads,
    horizon_cert   => $horizon_cert ,
    horizon_key    => $horizon_key,
    horizon_ca     => $horizon_ca,
    listen_ssl     => $use_ssl,
    extra_params      => {
      default_vhost   => true,
      add_listen      => false,
      ssl_protocol    => '+TLSv1',
      ssl_cipher      => 'HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
      custom_fragment => template("openstack/horizon/wsgi_vhost_custom.erb"),
    },
  } ~>
  Service[$::apache::params::service_name]

  Haproxy::Service        { use_include => true }
  Haproxy::Balancermember { use_include => true }

  $haproxy_config_options = {
   'option'      => ['ssl-hello-chk', 'tcpka'],
   'stick-table' => 'type ip size 200k expire 30m',
   'stick'       => 'on src',
   'balance'     => 'source',
   'timeout'     => ['client 3h', 'server 3h'],
   'mode'        => 'tcp',
  }

  haproxy::listen { 'horizon-ssl':
    order     => '017',
    ipaddress => $public_virtual_ip,
    ports     => '443',
    options   => $haproxy_config_options,
    mode      => 'tcp',
  }

  haproxy::balancermember { 'horizon-ssl':
    order             => '017',
    listening_service => 'horizon-tls',
    server_names      => filter_hash($controllers, 'name'),
    ipaddresses       => filter_hash($controllers, 'internal_address'),
    ports             => '443',
    options           => 'weight 1 check',
    define_cookies    => false,
    define_backups    => false,
  }

  ##################################################################################

  $haproxy_config_options_nova = {
   'option'      => ['ssl-hello-chk', 'tcpka'],
   'mode'        => 'tcp',
  }

  haproxy::listen { 'nova-novncproxy':
    order     => '170',
    ipaddress => $public_virtual_ip,
    ports     => '6080',
    options   => $haproxy_config_options_nova,
    mode      => 'tcp',
  }

  haproxy::balancermember { 'nova-novncproxy':
    order             => '170',
    listening_service => 'horizon-tls',
    server_names      => filter_hash($controllers, 'name'),
    ipaddresses       => filter_hash($controllers, 'internal_address'),
    ports             => '6080',
    options           => 'check',
    define_cookies    => false,
    define_backups    => false,
  }
  ######################################################################################

  service { 'haproxy':
    enable  => true,
    ensure  => running,
  }

}
