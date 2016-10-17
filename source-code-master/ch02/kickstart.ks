# Add Puppetlabs apt-repo gpg key
gpg --keyserver pgp.mit.edu --recv-keys 4BD6EC30 && gpg --export --armor 4BD6EC30 | apt-key add -
# Add Puppetlabs apt repo
cat > /etc/apt/sources.list.d/puppetlabs.list <<-EOF
CHAPTER 2 ■ BUILDING HOSTS WITH PUPPET
3
# puppetlabs
deb http://apt.puppetlabs.com precise main
deb-src http://apt.puppetlabs.com precise main
EOF
# Install puppet
/usr/bin/apt-get -y install puppet
# Make puppet startable
/bin/sed -i 's/START\=no/START\=yes/' '/etc/default/puppet'
# Create a puppet.conf file
cat > /etc/puppet/puppet.conf <<-EOF
[main]
logdir=/var/log/puppet
vardir=/var/lib/puppet
ssldir=/var/lib/puppet/ssl
rundir=/var/run/puppet
factpath=$vardir/lib/facter
pluginsync=true
runinterval=1380
configtimeout=600
splay=true
report=true
server = puppet.example.com
ca_server = puppetca.example.com
EOF
