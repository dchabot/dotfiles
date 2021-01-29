HOSTNAME=`hostname`
case $HOSTNAME in

"testfac-srv01" )

    source /afs/slac/g/acctest/tools/script/ENVS_acctest.bash
    ;;

"lcls-dev3" )

    # RHEL6-64
    source /afs/slac/g/lcls/tools/script/ENVS.bash
    source /afs/slac/g/lcls/epics/setup/epicsenv-7.0.3.1-1.0.bash
    source $TOOLS/oracle/oracleSetup-R11.2.0.4.bash
    export MATLAB_VER=2019a
    export MLM_LICENSE_FILE="27010@license1,27010@license2,27010@license3"
    source /afs/slac/g/lcls/tools/matlab/setup/matlabSetup64.bash
    source /afs/slac/g/lcls/physics/setup/physicsSetup.bash
    source /afs/slac/g/lcls/physics/setup/javaSetup64.bash

    export PATH="$HOME/.local/bin:$PATH"
    ;;

"lcls-dev2" )

    # RHEL5-32
    source /afs/slac/g/lcls/epics/setup/epicsenv-3.14.12.bash
    source $TOOLS/oracle/oracleSetup_11g.bash
    source ${TOOLS}/matlab/setup/matlabSetup_dev.bash
    export PS1="\[$(tput bold)\]\[\033[38;5;228m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;33m\]\h\[$(tput sgr0)\] \W \[$(tput sgr0)\]\[$(tput bold)\]\[\033[38;5;33m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
    # Skip the rest of the script - lcls-dev2 is ooooold
    return
    ;;
    
"aird-b50-srv01" )

    # RHEL7
    source /afs/slac/g/lcls/tools/script/ENVS.bash
    source /afs/slac/g/lcls/epics/setup/epicsenv-7.0.3.1-1.0.bash
    source $TOOLS/oracle/oracleSetup-R11.2.0.4.bash
    export MATLAB_VER=2019a
    export MLM_LICENSE_FILE="27010@license1,27010@license2,27010@license3"
    source /afs/slac/g/lcls/tools/matlab/setup/matlabSetup64.bash
    source /afs/slac/g/lcls/physics/setup/physicsSetup.bash
    source /afs/slac/g/lcls/physics/setup/javaSetup64.bash
    ;;

* )
esac

##################################################
#            Source other SLAC envs 
##################################################
# IPMC
source /afs/slac/g/lcls/package/IPMC/env.sh 

# Python 2.7.9 is default for pydm - add the libs to the path
export LD_LIBRARY_PATH=$PACKAGE_TOP/python/python2.7.9/linux-x86_64/lib:$PACKAGE_TOP/python/python2.7.9/linux-x86_64/lib/python2.7/lib-dynload:$LD_LIBRARY_PATH


if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi

# fn:       sourcepydm()
# abs:      Source the PyDM environment 
# detail:   Environment for developing *with* PyDM (as opposed to developing PyDM itself) 

sourcepydm(){
    echo "Warning: This may source EPICS 3.15!"
    echo "Currently using EPICS: $EPICS_BASE_VER"
    source /afs/slac/g/lcls/package/pydm/use_pydm.bash
    export PYTHONPATH=$HOME/local/lib/python2.7/site-packages:$PYTHONPATH
    echo "Now using EPICS: $EPICS_BASE_VER"
}

# fn:       gdbRT()
# abs:      Debug a linuxRT application.
# detail:   The linuxRT host environment for buildroot2019 + requires rhel7. This function
#           ssh's into the aird rhel7 server, cd's into the $APP passed as an argument and
#           launches gdb. It's up to you to make sure gdbserver is running on the target.
gdbRT() {
    ssh -t aird-b50-srv01 "source /afs/slac/u/cd/rreno/.bash_profile && cd $@ && /afs/slac.stanford.edu/g/controls/development/users/jvasquez/buildroot/rhel7/buildroot-2019.08/host/linux-x86_64/x86_64/bin/x86_64-linux-gdb"
}

