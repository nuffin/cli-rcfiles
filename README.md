# RC Files

These are RC (Runtime Config) files for command line environment.

## Features

- synced profiles - one repository, multiple hosts.
  - use `zprofiles update` command to update repository, no matter which directory your are working in.
- bash / zsh
  - structured rc files
  - `clonegit` command, to clone git repositories into sturct local directory.
- tmux config file
- vim config file

## How to use

### macOS/Linux

Just clone and execute `./deploy.sh'.

You may need to update some variable deffinitions, by editing `shrc.d/rc.vars` file

### Windows

Just download deploy-windows.ps1 directly, and run it with powershell, since there are only few features for windows currently.

### Notice

It will backup your original files if same name, and make symblic link to files/directories in your cloned directory.
