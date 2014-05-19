
class { '::rabbitmq':
  admin_enable => true,
  delete_guest_user => false,
  config_stomp => true,
  stomp_ensure => present,
}

class { '::mcollective':
  client            => true,
  middleware_hosts => [ 'localhost' ],
  connector        => 'rabbitmq',
  middleware_user  => 'guest',
  middleware_password => 'guest',
}

