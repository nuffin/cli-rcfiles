# RC Files

[中文版](README_zh.md

These are RC (Runtime Config) files for command line environment.

## Features

- synced profiles - one repository, multiple hosts.
  - use `zprofiles update` command to update repository, no matter which directory your are working in.
- bash / zsh
  - structured rc files
  - `clonegit` command, to clone git repositories into sturct local directory. both bash and zsh supported.
- tmux config file
- vim config file
- PowerShell
  - `Clone-Git` command, to clone git repositories into sturct local directory.

## How to use

### macOS/Linux

Just clone and execute `./deploy.sh'.

You may need to update some variable deffinitions, by editing `shrc.d/rc.vars` file

NOTICE

- automated installing of software neede support only Debian/Ubuntu series distributions currently, it use apt.
- if you have IMAP ID extension requirements, please use the modified version of getmail6, I put it in [feature/rfc2971-imap-id-extension](https://github.com/nuffin/getmail6/tree/feature/rfc2971-imap-id-extension) branch of [this](https://github.com/nuffin/getmail6/) repo.

### Windows

Just download deploy-windows.ps1 directly, and run it with powershell, since there are only few features for windows currently.

## Notice

It will backup your original files if same name, and make symblic link to files/directories in your cloned directory.
