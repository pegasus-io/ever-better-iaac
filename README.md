# ever-better-iaac

My continuously improving (automation of) my IAAC cycle




# Deploy it


```bash
export GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa'

export URI_DE_CE_REPO=git@github.com:pegasus-io/ever-better-iaac.git
export URI_DE_CE_REPO=https://github.com/pegasus-io/ever-better-iaac.git
export OPS_HOME=$(mktemp -d -t iaac.provisioning-XXXXXXXXXX)

git clone "$URI_DE_CE_REPO" $OPS_HOME
cd $OPS_HOME

chmod +x ./operations.sh
./operations.sh
```

#### _**Parameters**_

This recipe has no mandatory environment variables, and two mandatory parameters :

* Mandatory parameters (see [installation recipe](#deploy-it)):
  * `SSH_URI_TO_GIT_REPO` : The first argument passed to the [`initializeIAAC`] function, also the SSH URI to the git repo versioning the code you want to work on.
  * `DEVOPS_FOLDER` : The first argument passed to the [`initializeIAAC`] function, also the path of the folder you wan to work in, on your _workstation machine_.


# Use it

* You want to work on your workstation machine, in a folder of path `PATH_OF_FOLDER_I_CHOSE`
* And you want to work on the code versioned in the git repo of SSH URI `URI_TO_GIT_REPO_I_CHOSE`

Then :

* install the iaac cycle [like explained here](#deploy-it)
* And now, open a new `/bin/bash` Shell session : tpye `initi`, then double `tab`, and you'll see you have a new command available, `initializeIAAC`.
* Usaually I use the `initializeIAAC` command, when I want to work on a git repo. Then, if URI of the git repo is `$URI_TO_GIT_REPO_I_CHOSE`, I will choose a folder where I will work on my machine, and execute :

```bash
# -- OPS ENV
export PATH_OF_FOLDER_I_CHOSE=~/ever-iaac-atom-w
# -- IAAC ENV when I work on the present repo
export URI_TO_GIT_REPO_I_CHOSE=git@github.com:pegasus-io/ever-better-iaac.git


initializeIAAC $URI_TO_GIT_REPO_I_CHOSE $PATH_OF_FOLDER_I_CHOSE

git flow init --defaults
git push -u origin --all


atom .

export GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa'
# If I want to make a release today ...
export REALEASE_VERSION=0.0.2

export COMMIT_MESSAGE=""
export COMMIT_MESSAGE="$COMMIT_MESSAGE Resuming work on [$URI_TO_GIT_REPO_I_CHOSE]"
export FEATURE_ALIAS="git-flowing-the-iaac"
git flow feature start $FEATURE_ALIAS
# git add --all && git commit -m "$COMMIT_MESSAGE" && git push -u origin HEAD

# git flow feature finish $FEATURE_ALIAS && git push -u origin HEAD

# REALEASE START - git flow release start $FEATURE_ALIAS && git push -u origin HEAD
# REALEASE FINISH - with signature # git flow release finish -s $FEATURE_ALIAS && git push -u origin HEAD
# REALEASE FINISH - without signature # git flow release finish $FEATURE_ALIAS && git push -u origin HEAD

```
* Once done, press the _UP arrow_ key `10` times on your keyboard :
  * from now on, any command you need to execute, except you work in your Atom IDE, is among the `10` commands that you just browsed.
  * To reset the commit message for your next commit : explanations todo **faire une vidéo asciinema**
  * To reset the git ssh command :
  * To debug your ssh connection to a given git service provider (https://gitlab.com, https://github.com, etc...), set the `GIT_SSH_COMMAND` to :
    * `export GIT_SSH_COMMAND='ssh -Tvai /path/to/your/private/key'` for a verbose output
    * `export GIT_SSH_COMMAND='ssh -Tvvai /path/to/your/private/key'` for a very verbose output
    * `export GIT_SSH_COMMAND='ssh -Tvvvai /path/to/your/private/key'` for a very very verbose output

# How it works

There's a file, installed by [the installation recipe](#deploy-it) installs a
script file `~/iaac.functions.sh`, and modifies your profile so that this
script is sourced in your `~/.bashrc` and looks like this :

```bash
#!/bin/bash



# -- DEVOPS DEFAULT ENV
export DEFAULT_DEVOPS_FOLDER="~/.iaac-workspace"
# -- IAAC ENV
export GIT_SSH_COMMAND=${GIT_SSH_COMMAND:-'ssh -i ~/.ssh/id_rsa'}
export COMMIT_MESSAGE=""
export COMMIT_MESSAGE="$COMMIT_MESSAGE Resuming work on git repo : "

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
    if [ "$DEVOPS_FOLDER" == "x" ]; then
      echo " You must provide a second argument, the value of should be the SSH URI to the git repo you want to work with"
      echo " You must provide a second argument, the value of which "
      echo " should be the path of the folder you want to work in $(hostname)"
      echo " and should not be your home folder"
      return 1
    else
      echo " You selected the following folder as workspace : "
      echo " --  [$DEVOPS_FOLDER]   "
    fi;

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
    else
      echo " You selected the following git repo : "
      echo " --  [$SSH_URI_TO_GIT_REPOO]   "
    fi;

    # -- -- DEVOPS_FOLDER
    export DEVOPS_FOLDERR=$2
    if [ "$DEVOPS_FOLDERR" == "x" ]; then
      echo " You did not provide a second argument, the value of"
      echo " of which is meant to specify the path of the folder you "
      echo " want to work in $(hostname)"
      echo " So this folder is set todefault : [$DEFAULT_DEVOPS_FOLDER]"
      export DEVOPS_FOLDERR=$DEFAULT_DEVOPS_FOLDER
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

```


## Shells and X-`nix`ies

* il y a une notionde _default shell_ pour unr distribution linux / unix :
  * free bsd : `/bin/sh` [is the default shell, not `bash`](https://www.freebsd.org/doc/en_US.ISO8859-1/articles/linux-users/shells.html) :
  >
  > Linux® users are often surprised to find that Bash is not the default shell in `FreeBSD`. In fact, `Bash` is not included in the default installation. Instead, `FreeBSD` uses `tcsh` as the default `root shell`, and the Bourne shell-compatible sh(1) as the default user shell. sh(1) is very similar to Bash but with a much smaller feature-set. Generally shell scripts written for sh(1) will run in Bash, but the reverse is not always true.
  >

#### Something abour linux shells functions

* Puisque :

>
> When a bash function completes, its return value is the status of the last statement executed in the function, 0 for success and non-zero decimal number in the 1 - 255 range for failure.
>

* On peut utiliser la technique suivante, pour retourner un code d'erreur :

>
> Another option is to use a function and put the return values in that and then simply either source the script (source processStatus.sh) or call the script (./processStatus.sh) . For example consider the processStatus.sh script that needs to return a value to the stopProcess.sh script but also needs to be called separately from say the command line without using source (only relevant parts included) Eg:
>

```bash
 function faireUnTruc {
   if [ $1 -eq "50" ]
   then
       return 1
   else
       return 0
   fi
 }

 faireUnTruc

 ```
 * car si l'on suppose qu' appeler une fonction, c'est EXACTEMENT LA MËME CHOSE, qu'appeler un script, "mais sans fichier", alors il serait logique de penser que :
   * si un appel de la fonction `psifun` est la dernière commande du script `exemple.sh`
   * alors, si l'exécution de `exemple` n'invoque pas la comande `exit` (aucune commande `exit` dans le script),
   * et que la fonction `psifun` retourne l'entier `56`, alors le `exit status` de l'exécution de `exemple.sh` est `56`
   * exemple :

```bash
# ---

jbl@poste-devops-typique:~/iss-atom-w$ echo "exemple"
exemple
jbl@poste-devops-typique:~/iss-atom-w$ echo "$?"
0
jbl@poste-devops-typique:~/iss-atom-w$ cat exemple.sh
#!/bin/bash

uneFonction () {
    return 84;
}

commandeinxistante

echo "mais l'exécution se poursuit"
uneFonction


jbl@poste-devops-typique:~/iss-atom-w$ chmod +x ./exemple.sh
jbl@poste-devops-typique:~/iss-atom-w$ ./exemple.sh
./exemple.sh: line 7: commandeinxistante: command not found
mais l'exécution se poursuit
jbl@poste-devops-typique:~/iss-atom-w$ echo "$?"
84
jbl@poste-devops-typique:~/iss-atom-w$

```
