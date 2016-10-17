class mysql::service (
  enabled,
  ensure,
){
  service { 'cswmysql5':
    ensure => $ensure,
    hasstatus => true,
    hasrestart => true,
    enabled => $enabled,
    require => Class['mysql::config'],
  }
} 
