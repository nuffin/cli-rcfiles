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

LINUX_ADDITIONAL_SOFTWARE="git curl vim-nox tmux gnupg2 screen rsync wget xxd"
LINUX_ADDITIONAL_SOFTWARE="${LINUX_ADDITIONAL_SOFTWARE} tio minicom universal-ctags python3-pip"
LINUX_ADDITIONAL_SOFTWARE="${LINUX_ADDITIONAL_SOFTWARE} pinentry-curses vlock urlview"
LINUX_ADDITIONAL_SOFTWARE="${LINUX_ADDITIONAL_SOFTWARE} rust-all cargo"
LINUX_ADDITIONAL_SOFTWARE="${LINUX_ADDITIONAL_SOFTWARE} tcpdump nmap tcpflow"
LINUX_ADDITIONAL_SOFTWARE="${LINUX_ADDITIONAL_SOFTWARE} pciutils usbutils lshw"
LINUX_ADDITIONAL_SOFTWARE="${LINUX_ADDITIONAL_SOFTWARE} mutt pass abook getmail getmail6"

FREEBSD_ADDITIONAL_SOFTWARE="git curl tmux gnupg screen tio minicom ctags python3-pip rsync wget xxd"
FREEBSD_ADDITIONAL_SOFTWARE="${FREEBSD_ADDITIONAL_SOFTWARE} tcpdump nmap tcpflow"
FREEBSD_ADDITIONAL_SOFTWARE="${FREEBSD_ADDITIONAL_SOFTWARE} tio minicom"
FREEBSD_ADDITIONAL_SOFTWARE="${FREEBSD_ADDITIONAL_SOFTWARE} pinentry-curses vlock urlview"

OS_OS_ADDITIONAL_SOFTWARE="git curl vim-nox tmux tmuxp gnupg2 vlock"

EMAIL_ACCOUNTS="sample@gmail.com sample@outlook.com sample@163.com"

ADDITIONAL_DIRS="${HOME}/.tmux/plugins ${HOME}/.mutt/mail ${HOME}/.config/getmail"
for EMAIL_ACCOUNT in Drafts Sent ${EMAIL_ACCOUNTS}; do
    ADDITIONAL_DIRS="${ADDITIONAL_DIRS} ${HOME}/.mutt/mail/${EMAIL_ACCOUNT}/new"
    ADDITIONAL_DIRS="${ADDITIONAL_DIRS} ${HOME}/.mutt/mail/${EMAIL_ACCOUNT}/cur"
    ADDITIONAL_DIRS="${ADDITIONAL_DIRS} ${HOME}/.mutt/mail/${EMAIL_ACCOUNT}/tmp"
done

## Constants - end

function link_or_copy
{
    local LINK_TARGET=$1
    local LOCAL_TARGET=$2
    local BY_FORCE=$3

    local LOCAL_TARGET_ORIG=${LOCAL_TARGET}.orig

    echo -n "    linking ${LOCAL_TARGET}: "
    if test -e "${LOCAL_TARGET}"; then
        if test "x${BY_FORCE}" == "xf"; then
            echo -n "exists, rename to ${LOCAL_TARGET_ORIG} . "
            mv ${LOCAL_TARGET} ${LOCAL_TARGET_ORIG}
        else
            echo "exists, skip"
            return
        fi
    fi

    if test -e "${LINK_TARGET}.sample"; then
        echo -n "copying sample file of ${LINK_TARGET} ... "
        if test -e "${LOCAL_TARGET}"; then
            if test "x${BY_FORCE}" == "xf"; then
                echo -n "exists, rename to ${LOCAL_TARGET_ORIG} . "
                mv ${LOCAL_TARGET} ${LOCAL_TARGET_ORIG}
            else
                echo "${}exists, skip"
                return
            fi
        fi
        cp "${LINK_TARGET}" "${LOCAL_TARGET}"
    else
        echo -n "making link for ${LOCAL_TARGET} ... "
        if test -f ${LINK_TARGET}.${OSNAME}; then
            LINK_TARGET=${LINK_TARGET}.${OSNAME}
        fi
        if ! ln -s ${LINK_TARGET} ${LOCAL_TARGET}; then
            exit -1
        fi
    fi
    echo "done"
}

STEP=0

TARGETS="shrc.d shrc.d/rc.local.pre shrc.d/rc.local.post shrc.d/rc.vars"
TARGETS="${TARGETS} bashrc.d bashrc.d/bashrc.local.pre bashrc.d/bashrc.local.post bashrc.d/bashrc.vars"
TARGETS="${TARGETS} zshrc.d zshrc.d/zshrc.local.pre zshrc.d/zshrc.local.post zshrc.d/zshrc.vars"
TARGETS="${TARGETS} vimrc vimrc.d"
TARGETS="${TARGETS} tmux.conf tmux.conf.d tmux.conf.d/tmux.conf.local.pre tmux.conf.d/tmux.conf.local.post tmuxp"
TARGETS="${TARGETS} screenrc screenrc.d"
TARGETS="${TARGETS} gitconfig gitignore"
TARGETS="${TARGETS} lynxrc lynx w3m muttrc mailcap msmtprc"
cd ${HOME}
echo ">>> ${STEP}.  Making links or copy samples ..."
for TARGET in ${TARGETS}; do
    LINK_TARGET=${BASEDIR}/${TARGET}
    LOCAL_TARGET=.${TARGET}
    LOCAL_TARGET_ORIG=.${TARGET}.orig

    link_or_copy ${LINK_TARGET} ${LOCAL_TARGET} ${BY_FORCE}
done
#echo "done"
STEP=$((STEP + 1))

echo ">>> ${STEP}.  Set global ignore of git ..."
git config --global core.excludesfile ${HOME}/.gitignore
STEP=$((STEP + 1))

echo ">>> ${STEP}.  Making additional directories need"
for TARGET in ${ADDITIONAL_DIRS}; do
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

echo ">>> ${STEP}.  Additional setup for mutt"
for f in ${BASEDIR}/getmail/*.conf; do
    LINK_TARGET=${f}
    LOCAL_TARGET=${HOME}/.config/getmail/$(basename $f)
    link_or_copy ${LINK_TARGET} ${LOCAL_TARGET} ${BY_FORCE}
done
for f in ${BASEDIR}/mutt/*; do
    LINK_TARGET=${f}
    LOCAL_TARGET=${HOME}/.mutt/$(basename $f)
    link_or_copy ${LINK_TARGET} ${LOCAL_TARGET} ${BY_FORCE}
done
#echo "done"
STEP=$((STEP + 1))

echo ">>> ${STEP}.  Installing additional softwares"
if test "${OSNAME}" = "Linux"; then
    ADDITIONAL_SOFTWARE=${LINUX_ADDITIONAL_SOFTWARE}
    echo "    installing ${ADDITIONAL_SOFTWARE} ..."
    if test -f /etc/debian_version; then
        ${SUDO} env $_http_proxy $_https_proxy apt update && ${SUDO} env $_http_proxy $_https_proxy apt install -y --ignore-missing ${ADDITIONAL_SOFTWARE}
    fi

    ${SUDO} /usr/bin/env pip3 install --break-system-packages tmuxp

    /usr/bin/install -m 0700 -d ${HOME}/.gnupg
    echo "pinentry-program /usr/bin/pinentry-curses" >> ~/.gnupg/gpg-agent.conf
elif test "${OSNAME}" = "FreeBSD"; then
    ADDITIONAL_SOFTWARE="${FREEBSD_ADDITIONAL_SOFTWARE}"
    echo "    installing ${ADDITIONAL_SOFTWARE} ..."

    ${SUDO} pip3 install --break-system-packages tmuxp

    /usr/bin/install -m 0700 -d ${HOME}/.gnupg
    echo "pinentry-program /usr/bin/pinentry-curses" >> ~/.gnupg/gpg-agent.conf
elif test "${OSNAME}" = "Darwin"; then
    ADDITIONAL_SOFTWARE="${DARWIN_ADDITIONAL_SOFTWARE}"
    if ! ${WHICH} brew | grep brew >/dev/null 2>&1; then
        echo "    installing homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    echo "    installing ${ADDITIONAL_SOFTWARE} ..."
    brew install ${ADDITIONAL_SOFTWARE}
elif echo ${OSNAME} | grep -i cygwin 2>&1 >/dev/null; then
    ADDITIONAL_SOFTWARE="${OS_OS_ADDITIONAL_SOFTWARE}"
    echo "    NOTE: do not forget to install ${ADDITIONAL_SOFTWARE}"
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
        ${SUDO} apt update && ${SUDO} apt install -y bison hexdump
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
