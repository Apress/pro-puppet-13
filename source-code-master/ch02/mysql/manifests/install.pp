class mysql::install (
  $user,
  $group
){

  $mysql_pkgs = ['mysql5',
  'mysql5client',
  'mysql5rt',
  'mysql5test',
  'mysql5devel' ]

  package { $mysql_pkgs:
    ensure => present,
    require => User[$user],
  }
  user { $user:
    ensure => present,
    comment => 'MySQL user',
    gid => $group,
    shell => '/bin/false',
    require => Group[$group],
  }
  group { $group:
    ensure => present,
  }
} 
