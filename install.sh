#!/bin/sh
set -e
# If something is failing and not giving clear output, add set -x or add -x before execution

DIRECTORY=/home/jbalcas/osg-env/
if [ -d "$DIRECTORY" ]; then
      echo 'Directory is already available. Skipping'
fi
mkdir -p $DIRECTORY
cd $DIRECTORY
echo 'Installing CMS TaskWorker and Condor'
export SCRAM_ARCH=slc6_amd64_gcc493  
REPO=comp.jbalcas
mkdir cms-comp; cd cms-comp
wget http://cmsrep.cern.ch/cmssw/$REPO/bootstrap.sh
sh ./bootstrap.sh -architecture $SCRAM_ARCH -path $PWD -repository $REPO setup
source ./$SCRAM_ARCH/external/apt/*/etc/profile.d/init.sh
apt-get update
apt-get -y install external+condor+8.3.1-comp4
apt-get -y install cms+crabtaskworker+3.3.1606.rc3-comp2

echo 'Downloading osg wn client tarball'
wget http://repo.grid.iu.edu/tarball-install/3.3/osg-wn-client-latest.el6.x86_64.tar.gz
echo 'Untarring tarball'
tar -xvf osg-wn-client-latest.el6.x86_64.tar.gz
echo 'Installing tarball'
cd osg-wn-client/
osg/osg-post-install
source $DIRECTORY/osg-wn-client/setup.sh
echo 'Setup CA directory and fetch CRLs'
osg-ca-manage setupCA --url osg
fetch-crl
echo '========== DONE =========='

echo 'Few steps are required before starting a WN and can be done with sourcing update.sh file:'
echo '    a) It will update all CRLs and also will ask to generate proxy in grid certificates directory'
echo '    b) It will tar all CONDOR specific configurations and store on $HOME. On WN it will change required parameters. See cobalt/job-script.sh'
echo -------------------------------
echo '    To start WN you need to submit cobalt job and execute a StartD. Cobalt job specification is inside cobalt dir.'
echo '========== Finishing.'
set +x
