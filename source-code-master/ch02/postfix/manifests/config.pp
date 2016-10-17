class postfix::config {
  File {
    owner => 'postfix',
    group => 'postfix',
    mode => 0644,
  }
  file { '/etc/postfix/master.cf':
    ensure => present,
    source => 'puppet:///modules/postfix/master.cf',
    require => Class['postfix::install'],
    notify => Class['postfix::service'],
  }
  file { '/etc/postfix/main.cf':
    ensure => present,
    content => template('postfix/main.cf.erb'),
    require => Class['postfix::install'],
    notify => Class['postfix::service'],
  }
} 
