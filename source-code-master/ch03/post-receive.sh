#
# Hook to update the /etc/puppetlabs/puppet with the lastest git changes.
# Licensed Apache 2.0
#
# To enable this hook, name this file "post-receive".
syncuser="puppetsync"
gituser="gitolite"
gitserver="hostname.example.com"
gitrepo="puppet.git"
destination="/etc/puppetlabs/puppet/environments"
puppetmasters="pm1.example.com pm2.example.com"

## repo information
BRANCH_DIR=$destination
SSH_ARGS="-o ConnectTimeout=10 -o StrictHostKeyChecking=no"

## Functions
function update_puppet () {
    ## Git update for us-east puppetmaster

    server=$1
    BRANCH=`echo $2 | sed -n 's/^refs\/heads\///p'`
    REPO="${gituser}@${gitserver}:${gitrepo}"
    echo "INFO: updating puppet repo on $server"

    if [ "$newrev" -eq 0 ] 2> /dev/null ; then
      # branch is being deleted
      echo "Deleting remote branch $BRANCH_DIR/$BRANCH"
      ssh $SSH_ARGS ${syncuser}@${server} /bin/sh <<-EOF
        cd $BRANCH_DIR && rm -rf $BRANCH
EOF
    else
      # branch is being updated
      echo "Updating remote branch $BRANCH_DIR/$BRANCH"
      ssh  $SSH_ARGS ${syncuser}@${server} /bin/sh <<-EOF
        { cd $BRANCH_DIR/$BRANCH 2> /dev/null \
          && git fetch --all \
          && git reset --hard 'origin/$BRANCH' \
          && git submodule sync \
          && git submodule update --init ; } \
        || { mkdir -p $BRANCH_DIR \
             && cd $BRANCH_DIR \
             && git clone $REPO $BRANCH --branch $BRANCH \
             && cd $BRANCH \
             && git submodule update --init; }
EOF
    fi

    stat=$?
    if [[ $stat != 0 ]] ; then
        echo -e "ERROR: unable to update ${server}:${destination}"
        echo -e "INFO:check the configuration and run the update on the server again"
        exit $status
    else
        echo
        echo "INFO: update of puppet repo on $server complete"
        echo
    fi

}

## Script
while read oldrev newrev refname; do
    for host in $puppetmasters ; do
        update_puppet $host $refname
    done
done

exit $stat
