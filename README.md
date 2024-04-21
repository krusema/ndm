# ndm - sandboxes npm, npx, node

ndm drastically reduces the risk of malware infection via malicious npm packages. Such supply chain attacks have become
rather common and usually sneak in via `npm install`.

ndm is a node version manager script like `nvm` that installs the node versions via a docker image.  
ndm wraps npm, npx and node in `docker run` commands and mounts the current working directory into the container working
directory. This way, commands like `npm install` can be executed without the constant risk of malware infection, since
the docker container can only access the working directory and is deleted once the command finishes.

**To be clear** this is a handy script, not an actively maintained project.

I recommend not having npm/node installed on any computer and to work exclusively in docker containers, such as dev containers.
This script is convenient for running commands like `npm install` from the command line without risking malware infection.

## Setup

`docker` is required

### Install
To install the project, run the `install.sh` script.

### Install and use node versions

To install any node version, run:

`ndm install <version>` 

...where `<version>` is a valid docker tag on the `node` docker repository on docker hub, such as the version number.  
Example: `ndm install 20`

To use an installed node version, run  
`ndm use <version>`
Example: `ndm use 20`

### Check if the installation was successful:  
`node -e 'console.log("\n"+process.cwd())'`  
should output `/home/node/wdir`


## Usage

Once the steps in **Setup** have been followed, the following commands are available:

* `npm`, `npx`, `node`
  * Do what you'd expect. `node` repl history is kept in between launches. Host networking is used, so ports are available
    normally. File watchers work normally. Global installs are **not** kept; this is intentional.
* `node-bash`
  * Runs bash inside a docker container with the usual node commands available, the current directory mounted into the
    container and host networking.
* `ngit`
  * Runs `git` inside a wrapper container with node available. This is useful for precommit hooks. Also mounts your `$HOME/.ssh`
    and your `$HOME/.gitconfig`. The former is sensitive information that then resides in the container, but other credentials
    on your system are still protected.


## Limitations
* Commands cannot traverse up the directory tree. This is relevant for `ngit`, which needs to be executed in the directory
  that has the `.git` folder in it.
* Files outside the working directory are not kept inbetween commands, so external dependencies like Ruby or `apt` packages
  are not kept. In that case, you could add them to the Dockerfile in `$HOME/.ndm/Dockerfile` or create your own
  docker image and tag it with `custom_node:<Your version name>`
* `ndm` has not been tested on macOS as I do not have a Mac
