rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

rpm -ivh http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm

yum install -y puppet-server
puppet master
pgrep -lf puppet
ls /etc/init.d/puppet*
/etc/init.d/puppet stop
/etc/init.d/puppetmaster stop
/etc/init.d/puppetqueue stop
chkconfig puppetmaster off

puppet resource package httpd ensure=present

puppet resource package mod_ssl ensure=present

puppet resource service httpd ensure=stopped

puppet resource package rubygems ensure=present

puppet resource package rack ensure=present provider=gem 
puppet resource package passenger ensure=present provider=gem

yum install -y curl-devel ruby-devel httpd-devel apr-devel apr-util-devel make


passenger-install-apache2-module


cat > /etc/httpd/conf.d/passenger.conf << EOF
LoadModule passenger_module /usr/lib/ruby/gems/1.8/gems/passenger-4.0.10/buildout/apache2/mod_passenger.so
PassengerRoot /usr/lib/ruby/gems/1.8/gems/passenger-4.0.10
PassengerRuby /usr/bin/ruby

# And the passenger performance tuning settings:
PassengerHighPerformance On
# Set this to about 1.5 times the number of CPU cores in your master:
PassengerMaxPoolSize 6
# Recycle master processes after they service 1000 requests
PassengerMaxRequests 1000
# Stop processes if they sit idle for 10 minutes
PassengerPoolIdleTime 600

Listen 8140
<VirtualHost *:8140>
    SSLEngine On
    
    # Only allow high security cryptography. Alter if needed for compatibility.
    SSLProtocol             All -SSLv2
    SSLCipherSuite          HIGH:!ADH:RC4+RSA:-MEDIUM:-LOW:-EXP
    SSLCertificateFile      /var/lib/puppet/ssl/certs/pro-puppet-master-centos.pem
    SSLCertificateKeyFile   /var/lib/puppet/ssl/private_keys/pro-puppet-master-centos.pem
    SSLCertificateChainFile /var/lib/puppet/ssl/ca/ca_crt.pem
    SSLCACertificateFile    /var/lib/puppet/ssl/ca/ca_crt.pem
    SSLCARevocationFile     /var/lib/puppet/ssl/ca/ca_crl.pem
    SSLVerifyClient         optional
    SSLVerifyDepth          1
    SSLOptions              +StdEnvVars +ExportCertData
    
    # These request headers are used to pass the client certificate
    # authentication information on to the puppet master process
    RequestHeader set X-SSL-Subject %{SSL_CLIENT_S_DN}e
    RequestHeader set X-Client-DN %{SSL_CLIENT_S_DN}e
    RequestHeader set X-Client-Verify %{SSL_CLIENT_VERIFY}e

    PassengerEnabled On
    DocumentRoot /usr/share/puppet/rack/puppetmasterd/public/
    <Directory /usr/share/puppet/rack/puppetmasterd/>
        Options None
        AllowOverride None
        Order Allow,Deny
        Allow from All
    </Directory>
</VirtualHost>

EOF


mkdir -p /usr/share/puppet/rack/puppetmasterd/{public,tmp}



cat > /usr/share/puppet/rack/puppetmasterd/config.ru << EOF
# a config.ru, for use with every rack-compatible webserver.
# SSL needs to be handled outside this, though.

# if puppet is not in your RUBYLIB:
# \$LOAD_PATH.unshift('/opt/puppet/lib')

\$0 = "master"

# if you want debugging:
# ARGV << "--debug"

ARGV << "--rack"

# Rack applications typically don't start as root. Set --confdir and --vardir
# to prevent reading configuration from ~puppet/.puppet/puppet.conf and writing
# to ~puppet/.puppet
ARGV << "--confdir" << "/etc/puppet"
ARGV << "--vardir" << "/var/lib/puppet"

# NOTE: it's unfortunate that we have to use the "CommandLine" class
# here to launch the app, but it contains some initialization logic
# (such as triggering the parsing of the config file) that is very
# important. We should do something less nasty here when we've
# gotten our API and settings initialization logic cleaned up.
#
# Also note that the "\$0 = master" line up near the top here is
# the magic that allows the CommandLine class to know that it's
# supposed to be running master.
#
# --cprice 2012-05-22

require 'puppet/util/command_line'
# we're usually running inside a Rack::Builder.new {} block,
# therefore we need to call run *here*.
run Puppet::Util::CommandLine.new.execute

EOF

chown puppet /usr/share/puppet/rack/puppetmasterd/config.ru  
