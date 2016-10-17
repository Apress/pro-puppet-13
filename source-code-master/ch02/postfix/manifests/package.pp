class postfix::package {
  package { [ "postfix", "mailx" ]:
    ensure => present,
  }
} 
