#!/usr/bin/env bash

BASEDIR=$(cd $(dirname $0); pwd)

BY_FORCE=$(test "x${1}" == "x-f" && echo f || echo "")

_http_proxy="http_proxy=$http_proxy"
_https_proxy="https_proxy=$https_proxy"

OSNAME=$(uname -s)
if test "$(uname -o 2>/dev/null)" == "Cygwin"; then
    OSNAME=Cygwin
fi

## Constants - begin

# when using in docker, you may need replace "sudo" with ""
SUDO="sudo"

WHICH="command -v"
NVM_INSTALL_URL=https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh
PYENV_INSTALL_URL=https://pyenv.run  ## equal to curl -L -o- https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

LINUX_ADDITIONAL_SOFTWARES="git curl vim-nox tmux gnupg2 screen rsync wget xxd"
LINUX_ADDITIONAL_SOFTWARES="${LINUX_ADDITIONAL_SOFTWARES} tio minicom universal-ctags python3-pip"
LINUX_ADDITIONAL_SOFTWARES="${LINUX_ADDITIONAL_SOFTWARES} pinentry-curses vlock urlview"
LINUX_ADDITIONAL_SOFTWARES="${LINUX_ADDITIONAL_SOFTWARES} rust-all cargo"
LINUX_ADDITIONAL_SOFTWARES="${LINUX_ADDITIONAL_SOFTWARES} tcpdump nmap tcpflow"
LINUX_ADDITIONAL_SOFTWARES="${LINUX_ADDITIONAL_SOFTWARES} pciutils usbutils lshw"

FREEBSD_ADDITIONAL_SOFTWARES="git curl tmux gnupg screen tio minicom ctags python3-pip rsync wget xxd"
FREEBSD_ADDITIONAL_SOFTWARES="${FREEBSD_ADDITIONAL_SOFTWARES} tio minicom"
FREEBSD_ADDITIONAL_SOFTWARES="${FREEBSD_ADDITIONAL_SOFTWARES} tcpdump nmap tcpflow"
FREEBSD_ADDITIONAL_SOFTWARES="${FREEBSD_ADDITIONAL_SOFTWARES} pinentry-curses vlock urlview"

OS_OS_ADDITIONAL_SOFTWARES="git curl vim-nox tmux tmuxp gnupg2 vlock"

ADDITIONAL_DIRS="${HOME}/.tmux/plugins ${HOME}/.mutt"

## Constants - end

STEP=0

TARGETS="shrc.d shrc.d/rc.local.pre shrc.d/rc.local.post shrc.d/rc.vars"
TARGETS="${TARGETS} bashrc.d bashrc.d/bashrc.local.pre bashrc.d/bashrc.local.post bashrc.d/bashrc.vars"
TARGETS="${TARGETS} zshrc.d zshrc.d/zshrc.local.pre zshrc.d/zshrc.local.post zshrc.d/zshrc.vars"
TARGETS="${TARGETS} vimrc vimrc.d"
TARGETS="${TARGETS} tmux.conf tmux.conf.d tmux.conf.d/tmux.conf.local.pre tmux.conf.d/tmux.conf.local.post tmuxp"
TARGETS="${TARGETS} screenrc screenrc.d"
TARGETS="${TARGETS} gitconfig gitignore"
TARGETS="${TARGETS} lynxrc lynx w3m muttrc"
cd ${HOME}
echo ">>> ${STEP}.  Making links or copy samples ..."
for TARGET in ${TARGETS}; do
    LOCAL_TARGET=.${TARGET}
    LOCAL_TARGET_ORIG=.${TARGET}.orig

    echo -n "    ${LOCAL_TARGET}: "
    if test -e "${LOCAL_TARGET}"; then
        if test "x${BY_FORCE}" == "xf"; then
            echo -n "exists, rename to ${LOCAL_TARGET_ORIG} . "
            mv ${LOCAL_TARGET} ${LOCAL_TARGET_ORIG}
        else
            echo "exists, skip"
            continue
        fi
    fi

    if test -e "${BASEDIR}/${TARGET}.sample"; then
        echo -n "copying sample file of ${TARGET} ... "
        if test -e "${LOCAL_TARGET}"; then
            if test "x${BY_FORCE}" == "xf"; then
                echo -n "exists, rename to ${LOCAL_TARGET_ORIG} . "
                mv ${LOCAL_TARGET} ${LOCAL_TARGET_ORIG}
            else
                echo "exists, skip"
                continue
            fi
        fi
        cp "${LOCAL_TARGET}.sample" "${LOCAL_TARGET}"
    else
        echo -n "making link for ${LOCAL_TARGET} ... "
        if test -f ${BASEDIR}/${TARGET}.${OSNAME}; then
            LINK_TARGET=${BASEDIR}/${TARGET}.${OSNAME}
        else
            LINK_TARGET=${BASEDIR}/${TARGET}
        fi
        if ! ln -s ${LINK_TARGET} ${LOCAL_TARGET}; then
            exit -1
        fi
    fi
    echo "done"
done
#echo "done"
STEP=$((STEP + 1))

echo ">>> ${STEP}.  Set global ignore of git ..."
git config --global core.excludesfile ${HOME}/.gitignore
STEP=$((STEP + 1))

echo ">>> ${STEP}.  Making additional directories need"
for TARGET in ${ADDITIONAL_DIRS}; do
    if test ! -e "${BASEDIR}/${TARGET}"; then
        continue
    fi
    echo -n "    ${TARGET}: "
    if test ! -d ${TARGET}; then
        echo "not exists, make it"
        mkdir -p ${TARGET}
    else
        echo "exists, skip"
    fi
done
STEP=$((STEP + 1))

echo ">>> ${STEP}.  Adding personal settings to bash & ssh configurations"
for TARGET in bashrc zshrc ssh/config; do
    if test ! -e "${BASEDIR}/${TARGET}"; then
        continue
    fi
    LOCAL_TARGET=.${TARGET}
    LOCAL_TARGET_ORIG=.${TARGET}.orig
    if test "x${BY_FORCE}" == "xf"; then
        echo -n "    add/update personal settings to ${LOCAL_TARGET} BY FORCE ..."
        if test -f ${LOCAL_TARGET}; then
            cp ${LOCAL_TARGET} ${LOCAL_TARGET_ORIG}
        else
            touch ${LOCAL_TARGET_ORIG}
        fi
        (awk 'BEGIN { \
                  n = 0; found = 0; \
              } \
              /## Personal settings - begin ##/ { \
                  skip = 1; \
              } \
              { \
                  if (skip == 0) { \
                      lines[n] = $0; ++ n; \
                  } \
              } \
              /## Personal settings - end ##/ { \
                  found = 1; \
                  skip = 0; \
                  lines[n] = "## INSERT HERE ##"; \
                  ++ n; \
              } \
              END { \
                  for (i = 0; i < n; ++ i) { \
                      if (lines[i] == "## INSERT HERE ##") { \
                          while ((getline line <"'${BASEDIR}/${TARGET}'") > 0) { \
                              print line; \
                          }; \
                      } else { \
                          print lines[i]; \
                      } \
                  } \
                  if (found == 0) { \
                      while ((getline line <"'${BASEDIR}/${TARGET}'") > 0) { \
                          print line; \
                      }; \
                  } \
              }' ${LOCAL_TARGET_ORIG}) > ${LOCAL_TARGET}
        echo "done"
    elif ! grep "## Personal settings - begin ##" ${LOCAL_TARGET} >/dev/null 2>&1; then
        echo -n "    appending personal settings to ${LOCAL_TARGET} ..."
        cat ${BASEDIR}/${TARGET} >> ${LOCAL_TARGET}
        echo "done"
    else
        echo "    ${LOCAL_TARGET} has been updated before, skip"
    fi
done
#echo "done"
STEP=$((STEP + 1))

echo ">>> ${STEP}.  Installing additional softwares"
if test "${OSNAME}" = "Linux"; then
    ADDITIONAL_SOFTWARES=${LINUX_ADDITIONAL_SOFTWARES}
    echo "    installing ${ADDITIONAL_SOFTWARES} ..."
    if test -f /etc/debian_version; then
        ${SUDO} env $_http_proxy $_https_proxy apt update && ${SUDO} env $_http_proxy $_https_proxy apt install -y ${ADDITIONAL_SOFTWARES}
    fi

    ${SUDO} /usr/bin/env pip3 install --break-system-packages tmuxp

    /usr/bin/install -m 0700 -d ${HOME}/.gnupg
    echo "pinentry-program /usr/bin/pinentry-curses" >> ~/.gnupg/gpg-agent.conf
elif test "${OSNAME}" = "FreeBSD"; then
    ADDITIONAL_SOFTWARES="${FREEBSD_ADDITIONAL_SOFTWARES}"
    echo "    installing ${ADDITIONAL_SOFTWARES} ..."

    ${SUDO} pip3 install --break-system-packages tmuxp

    /usr/bin/install -m 0700 -d ${HOME}/.gnupg
    echo "pinentry-program /usr/bin/pinentry-curses" >> ~/.gnupg/gpg-agent.conf
elif test "${OSNAME}" = "Darwin"; then
    ADDITIONAL_SOFTWARES="${DARWIN}"
    if ! ${WHICH} brew | grep brew >/dev/null 2>&1; then
        echo "    installing homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    echo "    installing ${ADDITIONAL_SOFTWARES} ..."
    brew install ${ADDITIONAL_SOFTWARES}
elif echo ${OSNAME} | grep -i cygwin 2>&1 >/dev/null; then
    ADDITIONAL_SOFTWARES="${OS_OS_ADDITIONAL_SOFTWARES}"
    echo "    NOTE: do not forget to install ${ADDITIONAL_SOFTWARES}"
fi

echo ">>> ${STEP}.  Fetching additional files from internet"
TMUX_PLUGINS_DIR=${HOME}/.tmux/plugins
if test ! -d ${TMUX_PLUGINS_DIR}/tpm; then
    echo -n "    fetching tmux plugins manager ... "
    git clone https://github.com/tmux-plugins/tpm.git ${TMUX_PLUGINS_DIR}/tpm
    echo "    done"
else
    echo "    tmux plugins manager exists, skip"
fi
#echo "done"
STEP=$((STEP + 1))

if test "${OSNAME}" = "Linux" -o "${OSNAME}" = "FreeBSD" -o "${OSNAME}" = "Darwin"; then
    echo ">>> ${STEP}.  Installing nvm"
    ## Install nvm
    if test ! -d ${HOME}/.nvm -a -z "$(${WHICH} nvm)"; then
        echo "    installing nvm ..."
        curl -o- ${NVM_INSTALL_URL} | bash
    else
        echo "    already installed"
    fi
elif echo ${OSNAME} | grep -i cygwin 2>&1 >/dev/null; then
    echo "NOTE: do not forget to install nvm"
fi
STEP=$((STEP + 1))

if test "${OSNAME}" = "Linux" -o "${OSNAME}" = "FreeBSD" -o "${OSNAME}" = "Darwin"; then
    echo ">>> ${STEP}.  Installing gvm"
    ## Install gvm
    if test ! -d ${HOME}/.gvm -a -z "$(${WHICH} gvm)"; then
        echo "    installing gvm ..."
        ${SUDO} apt update && ${SUDO} apt install bison
        curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash -
    else
        echo "    already installed"
    fi
elif echo ${OSNAME} | grep -i cygwin 2>&1 >/dev/null; then
    echo "NOTE: do not forget to install gvm"
fi
STEP=$((STEP + 1))

if test "${OSNAME}" = "Linux" -o "${OSNAME}" = "FreeBSD" -o "${OSNAME}" = "Darwin"; then
    echo ">>> ${STEP}.  Installing pyenv"
    if test ! -d ${HOME}/.pyenv -a -z "$(${WHICH} pyenv)"; then
        echo "    installing pyenv ..."
        curl -o- ${PYENV_INSTALL_URL} | bash
    else
        echo "    already installed"
    fi
elif echo ${OSNAME} | grep -i cygwin 2>&1 >/dev/null; then
    echo "NOTE: do not forget to install pyenv"
fi
STEP=$((STEP + 1))

echo ">>> ${STEP}.  Installing oh-my-zsh"
if test ! -z "$(${WHICH} zsh)"; then
    if test ! -d ${HOME}/.oh-my-zsh; then
        curl -Lv https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
    fi

    if test $? -eq 0 -a ! -f ${HOME}/.warprc; then
        ${BASEDIR}/utils/install-zsh-plugin-wd.sh
        touch ${HOME}/.warprc
    fi
else
    echo "    zsh not found, skip."
fi
STEP=$((STEP + 1))

echo
echo ">>> All done"
echo
