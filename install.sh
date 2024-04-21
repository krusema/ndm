#!/bin/bash
set -e

if [ -d "$HOME/.ndm" ]
then
  echo '$HOME/.ndm directory already exists - ndm is already set up'
  echo "If you want this installer to run again, delete the folder $HOME/.ndm"
  exit 1
fi

if [[ "$HOME" = "" ]]
then
  echo '$HOME variable is not set, exiting'
  exit 1
fi

mkdir $HOME/.ndm
mkdir $HOME/.ndm/bin

### GET DIRECTORY OF THIS SCRIPT FIRST
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SOURCE_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
### END FIND DIRECTORY

cp $SOURCE_DIR/ndm $HOME/.ndm/ndm
cp $SOURCE_DIR/ndm-launch $HOME/.ndm/ndm-launch
cp $SOURCE_DIR/Dockerfile $HOME/.ndm/Dockerfile

ln -s $HOME/.ndm/ndm-launch $HOME/.ndm/npm
ln -s $HOME/.ndm/ndm-launch $HOME/.ndm/node
ln -s $HOME/.ndm/ndm-launch $HOME/.ndm/npx
ln -s $HOME/.ndm/ndm-launch $HOME/.ndm/ngit
ln -s $HOME/.ndm/ndm-launch $HOME/.ndm/node-bash

echo "ndm has been installed to $HOME/.ndm"

if [[ "`grep 'export PATH=$HOME/.ndm:$PATH' $HOME/.bashrc`" == "" ]]
then
  echo 'Would you like this script to add the ndm bin folder to the $PATH variable by modifying .bashrc? (yes/NO)'

  echo -n "> "

  read DO_INSTALL

  if [[ "$DO_INSTALL" == "yes" ]]
  then
    echo 'export PATH=$HOME/.ndm:$PATH' >> $HOME/.bashrc
    echo "Executable path added to bashrc"
    echo "Available commands: ndm; npm, node, npx, node-bash, ngit"
  else
    echo "Not adding ndm to executable path - if you want to use ndm, add $HOME/.ndm to your" '$PATH' variable
  fi
else
  echo "ndm path is already set in .bashrc"
fi

echo "All set up."

echo If you want to use ndm in this terminal, run
echo 'export PATH=$HOME/.ndm:$PATH'






