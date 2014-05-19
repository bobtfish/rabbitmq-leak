include apt
apt::source { 'puppetlabs':
  location   => 'http://apt.puppetlabs.com',
  repos      => 'main',
  key        => '4BD6EC30',
  key_server => 'pgp.mit.edu',
}
class { '::rabbitmq':
  admin_enable => true,
  delete_guest_user => false,
  config_stomp => true,
}

rabbitmq_plugin { ['rabbitmq_stomp', 'rabbitmq_federation', 'rabbitmq_federation_management']:
  ensure => present
}
rabbitmq_user { 'admin':
  password => 'admin',
  admin    => true,
}
rabbitmq_user_permissions { 'admin@/': # Default vhost
  configure_permission => '.*',
  read_permission      => '.*',
  write_permission     => '.*',
}
rabbitmq_vhost { "mcollective": }
rabbitmq_user_permissions { 'admin@mcollective':
  configure_permission => '.*',
  read_permission      => '.*',
  write_permission     => '.*',
}
rabbitmq_user_permissions { 'guest@mcollective':
  configure_permission => '.*',
  read_permission      => '.*',
  write_permission     => '.*',
}
rabbitmq_exchange { ['mcollective_broadcast@mcollective', 'mcollective_directed@mcollective', 'mcollective_reply@mcollective']:
  ensure   => present,
  user     => 'admin',
  password => 'admin',
  type     => 'topic',
}

Class['apt::update'] ->
class { '::mcollective':
  version             => '2.5.1-1puppetlabs1',
  client              => true,
  middleware_hosts    => [ 'localhost' ],
  connector           => 'rabbitmq',
  middleware_user     => 'guest',
  middleware_password => 'guest',
  middleware_port     => '6163',
  rabbitmq_vhost      => 'mcollective',
}
->
Class['lots_of_mcollective']

include lots_of_mcollective

