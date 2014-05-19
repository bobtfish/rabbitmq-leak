
class { '::rabbitmq':
  admin_enable => true,
  delete_guest_user => false,
  config_stomp => true,
  stomp_ensure => true
}

