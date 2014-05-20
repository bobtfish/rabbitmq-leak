define lots_of_mcollective::ping {
  file { "/etc/init/mco_ping_${name}.conf":
    source => 'puppet:///modules/lots_of_mcollective/ping.conf',
    owner  => root,
    group  => root,
    mode   => '0644';
  }
  -> service { "mco_ping_${name}":
    ensure => running;
  }
}

