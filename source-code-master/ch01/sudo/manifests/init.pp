class sudo {

  package { 'sudo':
    ensure => present,
  }

  if $::osfamily == 'Debian' {
    package { 'sudo-ldap':
      ensure => present,
      require => Package['sudo'],
    }
  }

  file { '/etc/sudoers':
    owner => 'root',
    group => 'root',
    mode => '0440',
    source => "puppet://$::server/modules/sudo/etc/sudoers",
    require => Package['sudo'],
  }
} 
