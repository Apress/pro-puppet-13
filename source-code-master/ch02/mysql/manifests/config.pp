class mysql::config (
  $user,
  $group,
){
  file { '/opt/csw/mysql5/my.cnf':
    ensure => present,
    source => 'puppet:///modules/mysql/my.cnf',
    owner => $user,
    group => $group,
    require => Class['mysql::install'],
    notify => Class['mysql::service'],
  }
  file { '/opt/csw/mysql5/var':
    group => $user,
    owner => $group,
    recurse => true,
    require => File['/opt/csw/mysql5/my.cnf'],
  }
} 
