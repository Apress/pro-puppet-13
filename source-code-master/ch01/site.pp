

node ' node1.pro-puppet.com ' {
  package { 'vim':
    ensure => present,
  }
}

node /^www\d+\.pro-puppet\.com/
{
...
} 


node 'node1.pro-puppet.com' {
    include sudo
}

node /node1/ {
  include ::sudo
}
node /node2/ {
  class { '::sudo':
    users => ['tom', 'jerry'],
  }
} 


