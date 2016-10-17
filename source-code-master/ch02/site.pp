node 'puppet.example.com'
{
# Puppet code wll go here
}
node 'web.example.com'
{
# Puppet code will go here
}
node 'db.example.com'
{
# Puppet code will go here
}
node 'mail.example.com'
{
# Puppet code will go here
} 


node 'web1.example.com',
     'web2.example.com',
     'web3.example.com'
{
# Puppet code goes here
} 


node /^web\d+\.example\.com$/
{
# Puppet code goes here
} 

node default {
  include defaultclass
} 




node 'db.example.com' {
  class { 'mysql':
    user => 'staging-mysql',
    service_running => false,
    service_enabled => false,
  }
} 

node 'www.something.com' {

  apache::vhost { 'www.example.com':
    port => '80',
    docroot => '/var/www/www.example.com',
    ssl => false,
    priority => '10',
    serveraliases => 'home.example.com', } 
  }

}
