class ssh::params {
  case $::osfamily {
    Solaris: {
      $ssh_package_name = 'openssh'
    }
    Debian: {
      $ssh_package_name = 'openssh-server'
    }
    RedHat: {
      $ssh_package_name = 'openssh-server'
    }
    default: {
      fail("Module propuppet-ssh does not support osfamily: ${::osfamily}")
    }
  }
} 
