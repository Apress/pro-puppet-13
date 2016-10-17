class ssh::install {
  package { "openssh":
    ensure => present,
  }
}

