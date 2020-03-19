#!/bin/bash



# -- DEVOPS DEFAULT ENV
# export DEFAULT_ DEVOPS_FOLDER="~/.iaac-workspace"
# -- IAAC ENV
export GIT_SSH_COMMAND=${GIT_SSH_COMMAND:-'ssh -i ~/.ssh/id_rsa'}

# -- IDE ENV

#
# Both functions inside :
#
# => DEBIAN 9 n 10 : ~/.bashrc, ou mieux: export RC_FILENAME="~/$(echo "$SHELL" |awk -F '/' '{print $3}')rc"
# => UBUNTU 18.04 (latest lts version) : ~/.bashrc
# => CentOS 7 : ~/.bashrc
#

initializeIDEWorkSpace () {

    # -- checking params
    # -- -- SSH_URI_TO_GIT_REPO
    export SSH_URI_TO_GIT_REPO=$1
    if [ "x$SSH_URI_TO_GIT_REPO" == "x" ]; then
      echo " You must provide a first argument, the value of should be the SSH URI to the git repo you want to work with"
      echo " You must provide a first argument, the value of which "
      echo " should be the SSH URI to the git repo you want to work with"
      return 1
    else
      echo " You selected the following git repo : "
      echo " --  [$SSH_URI_TO_GIT_REPO]   "
    fi;
    # -- -- DEVOPS_FOLDER
    export DEVOPS_FOLDER=$2
    # -- -- DEVOPS_FOLDER
    export DEVOPS_FOLDER=$2
    if [ "x$DEVOPS_FOLDER" == "x" ]; then
      echo " You did not provide a second argument, the value of"
      echo " of which is meant to specify the path of the folder you "
      echo " want to work in $(hostname)"
      echo " So this folder is set to default path : [~/.iaac-workspace]"
      export DEVOPS_FOLDER=~/.iaac-workspace
    fi;
    echo " You selected the following folder as workspace : "
    echo " --  [$DEVOPS_FOLDERR]   "
if [ -d $DEVOPS_FOLDER ]; then
  echo " Workspace [$DEVOPS_FOLDER] alreadyt exists "
  echo " Scanning if it's a git repo with remote repo set to : "
  echo "  ---  [$SSH_URI_TO_GIT_REPO] "
  echo " "
  cd $DEVOPS_FOLDER
  git status
  if [ $? -eq 0 ]; then
    export REMOTE=$(git remote -v | awk '{print $2}'|head -n 1)
    if [ "$REMOTE" == "$SSH_URI_TO_GIT_REPO" ]; then
      echo " Le répertoire [$(pwd)] est bien synchronisé sur : "
      echo "  ---  [$SSH_URI_TO_GIT_REPO] "
      echo "  Il est donc inutile de faire un git clone"
      echo " par contre, on fait un git pull : "
      git pull
      echo " état après le git pull : "
      git status
    else
      echo " Le répertoire [$(pwd)] est bien un git repo, mais pas sur le repo sur lequel vous voulez travailler, à savoir : "
      echo "  ---  [$SSH_URI_TO_GIT_REPO] "
      echo " Donc : il faut détruire le répertoire $DEVOPS_FOLDER et le re-créer, et faire le git clone "
      cd $DEVOPS_FOLDER
      rm -fr $DEVOPS_FOLDER
      mkdir -p $DEVOPS_FOLDER
      cd $DEVOPS_FOLDER
      git clone "$SSH_URI_TO_GIT_REPO" .
    fi;
  else
    echo " Le répertoire [$(pwd)] n'est pas un git repo. "
    echo " Vous avez peut-être des fichiers / données important(e)s dans ce répertoire, seul vous pouvez le déterminer. "
    echo " Supprimez le répertoire [$(pwd)], ou choisissez-en un autre, puis recommencez la procédure"
    return 2
  fi;
else
  echo " Workspace [$DEVOPS_FOLDER] does not exists, creating it. "
  mkdir -p $DEVOPS_FOLDER
  cd $DEVOPS_FOLDER
  git clone "$SSH_URI_TO_GIT_REPO" .
fi;
}

initializeIAAC () {

    # -- checking params
    # -- -- SSH_URI_TO_GIT_REPOO
    export SSH_URI_TO_GIT_REPOO=$1
    if [ "x$SSH_URI_TO_GIT_REPOO" == "x" ]; then
      echo " You must provide one argument, the value of should be the SSH URI to the git repo you want to work with"
      echo " You must provide one argument, the value of which "
      echo " should be the SSH URI to the git repo you want to work with"
      return 1
    fi;
    echo " You selected the following git repo : "
    echo " --  [$SSH_URI_TO_GIT_REPOO]   "
    # -- -- DEVOPS_FOLDER
    export DEVOPS_FOLDERR=$2
    if [ "x$DEVOPS_FOLDERR" == "x" ]; then
      echo " You did not provide a second argument, the value of"
      echo " of which is meant to specify the path of the folder you "
      echo " want to work in $(hostname)"
      echo " So this folder is set to default : [~/.iaac-workspace]"
      export DEVOPS_FOLDERR=~/.iaac-workspace
    else
      echo " You selected the following folder as workspace : "
      echo " --  [$DEVOPS_FOLDERR]   "
    fi;

    # -- checking dependencies

    git --version
    if [ $? -eq 0 ]; then
      if [ "$DEVOPS_FOLDERR" == "$HOME" ]; then
        echo " Your working directory should never ever be your home directory [$HOME] "
        echo " set [\$DEVOPS_FOLDER]  to a value being a path different than [$HOME] "
      else
        # ok
        initializeIDEWorkSpace $SSH_URI_TO_GIT_REPOO $DEVOPS_FOLDERR
      fi;
    else
      echo "git is not installed, please install git, and retry"
    fi;
}

# -- THIS SCRIPT IS MEANT TO BE SOURCED, NEVER EXECUTED
[ "$BASH_SOURCE" == "$0" ] &&
    echo "This script, [$O], is meant to be sourced, not executed" &&
        exit 30

return 88
