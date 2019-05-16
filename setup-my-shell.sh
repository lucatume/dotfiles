#!/usr/bin/env bash

# detects the current system
detectThe(){
    if [ "Darwin" == $(uname -s) ]; then
        # MacOs
        eval "$1='macos'"
        return
    elif grep -q Microsoft /proc/version; then
        # bash on ubuntu on Windows
        eval "$1='windows'"
        return
    else
        # Linux
        eval "$1='linux'"
    fi
}

macOsDetectThe(){
    if type "sw_vers" > /dev/null;then
        eval "$1=0"
    else
        version="$(sw_vers -productVersion)" 
        eval "$1=$version"
    fi
}

addAptRepositories(){
    echo "\nAdding repositories...\n"

    # Go repository
    sudo add-apt-repository -y ppa:gophers/archive

    # Docker repository
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
           "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
              $(lsb_release -cs) \
                 stable"
}

installDependencies(){
    if [ "macos" == $system ]; then
        brew tap homebrew/services
        brew install \
            homebrew/php/php70 \
            homebrew/php/php70-opcache \
            homebrew/php/php70-mcrypt \
            homebrew/php/php70-xdebug \
            hub \
            zsh zsh-completions \
            homebrew/php/composer \
            homebrew/php/wp-cli \
            dnsmasq \
            git-extras
    else
        echo "\nUpdating apt lists...\n"
        sudo apt-get update

        echo "\nInstalling dependencies...\n"
        sudo apt-get install --yes --no-install-recommends \
            libnss3-tools \
            jq \
            xsel \
            php70-cli php7.0-curl php7.0-mbstring php7.0-mcrypt php7.0-xml php7.0-zip \
            php7.0-sqlite3 php7.0-mysql php7.0-pgsql php-xdebug \
            ruby \
            ruby-dev \
            make \
            golang-1.8 \
            curl \
            wget \
            xclip \
            apt-transport-https \
            ca-certificates \
            software-properties-common \
            docker.io
    fi
}

installBundler(){
    if [ "macos" == $system ]; then
        if [ ! $(gem query -i -n bundler) ]; then
           gem install bundler
        fi
    else
        if [ ! $(sudo gem query -i -n bundler) ]; then
           sudo gem install bundler
        fi
    fi
}

installHub(){
    if ! type "hub" > /dev/null; then
        echo "\nInstalling hub...\n"
        git clone https://github.com/github/hub.git \
            && ( \
            cd hub; \
            ./script/build;
        sudo mv bin/hub /usr/local/bin/hub;
        ) \
            && rm -rf hub
    fi
}

generateSSHKey(){
    if [ ! -d "$HOME/.ssh" ]; then
        echo "\nCreating the ~/.ssh folder...\n"
        mkdir -p "$HOME/.ssh"
    fi

    if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
        echo "\nGenerating SSH key..."
        ssh-keygen -t rsa -b 4096 -C "luca@theaveragedev.com"
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_rsa
        if [ "macos" == $system ]; then
            cat ~/.ssh/id_rsa.pub | pbcopy
        else
            xclip -sel clip < ~/.ssh/id_rsa.pub
        fi
        echo "Public key copied to clipboard; add it on GitHub: https://github.com/settings/keys\n"
    fi
}

installAwesomeVim(){
    if [ ! -f "$HOME/.vimrc" ]; then
        echo "\nInstalling Awesome vim...\n"
        git clone https://github.com/amix/vimrc.git ~/.vim_runtime
        sh ~/.vim_runtime/install_awesome_vimrc.sh
        cat >> ~/.vimrc << EOL
imap jj <Esc>
EOL
    fi
}

installOhMyZsh(){
    sudo chmod go-w '/usr/local/share'

    if [ "macos" != $system ]; then
        if ! type "zsh" > /dev/null; then
            echo "\nInstalling zsh...\n"
            sudo apt-get install zsh
        fi
    fi

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "\nInstalling oh-my-zsh...\n"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
}

installOhMyZshCompletions(){
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
        echo "\nInstalling zsh completions...\n"
        # zsh completions
        git clone https://github.com/zsh-users/zsh-completions \
            $HOME/.oh-my-zsh/custom/plugins/zsh-completions
        # hub completion
        curl -o $HOME/.oh-my-zsh/custom/plugins/zsh-completions/src/_hub \
            https://raw.githubusercontent.com/github/hub/master/etc/hub.zsh_completion
    fi
}

installPowerline9k(){
    if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel9k" ]; then
        echo "\nInstalling Powerline9k zsh theme...\n"
        git clone https://github.com/bhilburn/powerlevel9k.git \
            $HOME/.oh-my-zsh/custom/themes/powerlevel9k
    fi
}

installComposer(){
    if [ "macos" != $system ]; then
        if ! type "composer" > /dev/null; then
            echo "\nInstalling Composer...\n"
            wget https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer -O - -q | php -- --quiet
            sudo mv ./composer.phar /usr/local/bin/composer
        fi
    fi

    echo "\nInstalling hirak/prestissimo for Composer...\n"
    composer global require hirak/prestissimo
}

setupXdebug(){
    if [ "macos" == $system ]; then
        xdebugConfFile="$(brew --prefix)/etc/php/7.0/conf.d/ext-xdebug.ini"
    else
        xdebugConfFile="/etc/php/7.0/mods-available/xdebug.ini"
    fi

    if [ ! $(cat $xdebugConfFile | grep remote_connect_back) > /dev/null ]; then
        echo "\nUpdating XDebug configuration file...\n"
        if [ "macos" != $system ]; then
            sudo chown $(whoami) $xdebugConfFile
            sudo cat >> $xdebugConfFile << EOL
xdebug.remote_enable=1
xdebug.remote_autostart=1
xdeug.remote_connnect_back=1
xdebug.remote_port=9001
xdebug.scream=1
xdebug.show_error_trace=1
xdebug.show_exception_trace=1
xdebug.show_local_vars=1
EOL
        else
            cat >> $xdebugConfFile << EOL
xdebug.remote_enable=1
xdebug.remote_autostart=1
xdeug.remote_connnect_back=1
xdebug.remote_port=9001
xdebug.scream=1
xdebug.show_error_trace=1
xdebug.show_exception_trace=1
xdebug.show_local_vars=1
EOL
        fi
    fi
}

regenerateZshCompletionsCache(){
    echo "\nRegenerating zsh completion cache...\n"

    if [ -d "$HOME/.zcompdump" ]; then
        rm -f ~/.zcompdump; compinit
    fi
}

installWpCli(){
    source="https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"
    destination="/usr/local/bin/wp"

    if ! type "wp" > /dev/null; then
        echo "\nInstalling WP-CLI..."
        sudo wget -O $destination $source
        sudo chmod +x $destination
        echo "Installed $(wp --version)\n"
    fi
}

setupDocker(){
    if ! type "docker" > /dev/null; then
        echo "\nSetting up Docker..."
        sudo groupadd docker
        sudo usermod -aG docker $USER
        echo "Registering Docker to start at boot...\n"
        sudo systemctl enable docker
    fi
}

installDockerCompose(){
    source="https://github.com/docker/compose/releases/download/1.14.0/docker-compose-`uname -s`-`uname -m`"

    if ! type "docker-compose\n" > /dev/null; then
        echo "\nInstalling Docker Compose..."
        sudo wget -O /usr/local/bin/docker-compose $source
        sudo chmod +x /usr/local/bin/docker-compose
    fi
}

linkSublimeTextConfiguration(){
    sublimeTextFolder="$HOME/Library/Application Support/Sublime Text 3"
    source="$HOME/dotfiles/sublime-text/osx.sublime-keymap"
    destinationFolder="$HOME/Library/Application Support/Sublime Text 3/Packages/User"
    destination="$HOME/Library/Application Support/Sublime Text 3/Packages/User/Default (OSX).sublime-keymap"

    if [ -d "$sublimeTextFolder" ]; then
        echo "\nLinking Sublime Text 3 keymap...\n"
        if [ -f "$destination" ]; then
            rm "$destination"
        fi
        mkdir -p "$destinationFolder"
        ln -s "$source" "$destination"
    else
        echo "\nSublime Text 3 folder not found... skipping\n"
    fi
}

setupDnsmasq(){
    if type "docker-machine" > /dev/null;then
        address=$(docker-machine ip default)
    else
        address=127.0.0.1
    fi

    sourceConf="$(brew list dnsmasq | grep /dnsmasq.conf.example$)"
    destinationConf="/usr/local/etc/dnsmasq.conf"

    if [ ! -f "$sourceConf" ]; then
        return 0;
    fi

    if [ ! -f  "$destinationConf" ]; then
    cp $(brew list dnsmasq | grep /dnsmasq.conf.example$) "$destinationConf"

    sudo cat >> $destinationConf << EOL
# listen on localhost
listen-address=127.0.0.1
# on a non default port
port=35353
# and forward requests for the .localost tld to the docker-machine
address=/localhost/$address
EOL
    fi

    if [ ! -d "/etc/resolver" ]; then
        sudo mkdir -p /etc/resolver
    fi

    if [ ! -f "/etc/resolver/localhost" ]; then
        sudo cat > /etc/resolver/localhost << EOL
# resolve .localhost domains calling 127.0.0.0:35353 (brew managed dnsmasq)
# see /usr/local/etc/dnsmasq.conf
nameserver 127.0.0.1
port 35353
EOL
    fi

    brew services restart dnsmasq
}

linkCompletions(){
    # git-extras completions
    if type "brew" > /dev/null; then
        source=$(brew --prefix git-extras)/etc/bash_completion.d/git-extras
        destination=$(brew --prefix)/share/zsh-completions/_git-extras

        if [ -f $source ]; then
            echo "\nLinkin git-extras completion...\n"
            ln -s $source $destination
        fi
    fi
}

system="undefined"
macOsVersion="undefined"
detectThe system
macOsDetectThe macOsVersion

echo "\nSystem is $system\n"

if [ "macos" != $system ]; then
    addAptRepositories

    installDependencies

    installBundler

    export PATH="$PATH:/usr/lib/go-1.8/bin"

    installHub

    generateSSHKey

    installAwesomeVim

    installOhMyZsh

    installOhMyZshCompletions

    installPowerline9k

    installComposer

    setupXdebug

    regenerateZshCompletionsCache

    installWpCli

    setupDocker

    installDockerCompose

    # just to make sure we have what we need
    (cd dotfiles; curate)

    git config --global core.excludesfile '~/.gitignore'
else
    installDependencies

    # just in case make sure we are using Homebrew version of ruby bins
    export PATH=$(brew --prefix ruby)/bin:$PATH

    installBundler

    generateSSHKey

    installAwesomeVim

    installOhMyZsh

    installPowerline9k

    installComposer

    setupXdebug

    linkCompletions

    regenerateZshCompletionsCache

    setupDnsmasq

    linkSublimeTextConfiguration

    # just to make sure we have what we need
    (cd dotfiles; curate)

    git config --global core.excludesfile '~/.gitignore'
fi
