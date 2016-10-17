#!/bin/bash
# short script to install puppet on a few different system

#Debian Squeeze:

tempdir=/tmp/pro-puppet

pushd $tempdir

wget http://apt.puppetlabs.com/puppetlabs-release-squeeze.deb
dpkg -i puppetlabs-release-squeeze.deb
apt-get update

#Ubuntu Precise:

wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
apt-get update


rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm

#Enterprise Linux 6:

rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
vh http://yum.puppetlabs.com/el/5/products/i386/puppetlabs-release-5-7.noarch.rpm

Enterprise Linux 6:

rpm -ivh http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm

popd

rm -fr $tempdir

