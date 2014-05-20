$no_of_mcollective_servers = 16
$do_registration = false
$registration_interval = 1 # 1 for stress test. Normally 300
$do_heartbeats = true
$heartbeat_interval = 1 # 1 for stress test. Normally 60

include apt
apt::source { 'puppetlabs':
  location   => 'http://apt.puppetlabs.com',
  repos      => 'main dependencies',
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

# Override to ensure we have the version I'm actually running
Package<| title == 'ruby-stomp' |> {
  ensure => '1.2.10-1puppetlabs1'
}
Service['mcollective'] ->
class { 'lots_of_mcollective':
  instances => $no_of_mcollective_servers;
}

if $do_registration {
  file {
    '/usr/local/share/mcollective/mcollective/registration':
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0755';
    '/usr/local/share/mcollective/mcollective/registration/meta.rb':
      source => 'puppet:///modules/mcollective_support/meta.rb',
      owner  => root,
      group  => root,
      mode   => '0644';
    '/usr/local/share/mcollective/mcollective/agent':
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0755';
    '/usr/local/share/mcollective/mcollective/agent/registration.rb':
      source => 'puppet:///modules/mcollective_support/registration.rb',
      owner  => root,
      group  => root,
      mode   => '0644';
  } -> Service['mcollective']
  mcollective::server::setting {
    'registration':
      value => 'Meta';
    'registerinterval':
      value => $registration_interval;
  } -> Service['mcollective']
}

if $do_heartbeats {
  mcollective::server::setting {
   'plugin.rabbitmq.heartbeat_interval':
     value => $heartbeat_interval;
   'plugin.rabbitmq.stomp_1_0_fallback':
     value => 0;
   'plugin.rabbitmq.max_hbread_fails':
     value => 2;
   'plugin.rabbitmq.max_hbrlck_fails':
     value => 2;
  } -> Service['mcollective']
}

mcollective::client::setting {
  'plugin.rabbitmq.use_reply_exchange':
    value => 'true'
}

