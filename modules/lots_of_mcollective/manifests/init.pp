class lots_of_mcollective ($instances, $ping_instances) {
  file { '/usr/local/sbin/duplicate_mcollective_servers':
    source => 'puppet:///modules/lots_of_mcollective/duplicate_mcollective_servers',
    owner  => 'root',
    group  => 'root',
    mode   => '0700'
  }
  ->
  exec { "/usr/local/sbin/duplicate_mcollective_servers ${instances}":
    creates => '/etc/mcollective/server.1.cfg'
  }
  file { '/usr/local/bin/ping_forever':
    source => 'puppet:///modules/lots_of_mcollective/ping_forever',
    owner  => 'root',
    group  => 'root',
    mode   => '0755'
 }
 $things = upto_array($ping_instances)
 lots_of_mcollective::ping { $things: }
}

