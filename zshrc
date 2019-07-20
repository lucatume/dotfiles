# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Source the Powerlevel9k theme 
# (see https://github.com/bhilburn/powerlevel9k/wiki/Install-Instructions#step-1-install-powerlevel9k)
source /usr/local/opt/powerlevel9k/powerlevel9k.zsh-theme

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_with_package_name
# use with light themes
POWERLEVEL9K_COLOR_SCHEME='light'
ZSH_THEME="powerlevel9k/powerlevel9k"
# ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Paths
# -----

# bins - look around for different setups
binPaths=(
"/home/linuxbrew/.linuxbrew/bin" # Linuxbrew default installation 
"$HOME/.linuxbrew/bin" # Linuxbrew alt installation path
"/usr/local/bin" # homebrew on MacOs
"$HOME/.config/composer/vendor/bin" # global Composer bins
"/usr/lib/go-1.8/bin" # Go language bins
"$HOME/Repos/tribe-product-utils" # Modern Tribe Products utils
"node_modules/.bin" # local Node binaries
)
for binPath in $binPaths; do
    if [ -d $binPath ]; then
        export PATH="$binPath:$PATH"
    fi
done

# If using Homebrew use its 'ruby' bins to avoid having to use 'sudo' to install gems
if type "brew --prefix ruby" > /dev/null; then
    export PATH=$(brew --prefix ruby)/bin:$PATH
fi

# If using Homebrew set the PYTHONPATH correctly
if type "brew" > /dev/null; then
    # export PYTHONPATH=$(brew --prefix)/lib/python2.7/site-packages:$PYTHONPATH
    export PATH="/usr/local/opt/python/libexec/bin:$PATH"
fi

# goss and dgoss (https://github.com/aelsabbahy/goss/tree/master/extras/dgoss)
export GOSS_PATH=~/src/goss-linux-amd64

# Composer global bins
export PATH=~/.composer/vendor/bin:$PATH

# project local bins (e.g. installed via Composer)
export PATH="vendor/bin:$PATH"

# current folder bins
export PATH=".:$PATH"

# ZSH completions
# ---------------
completionPaths=(
    "/usr/local/share/zsh/site-functions"
    "/usr/local/share/zsh-completions"
    "$HOME/.oh-my-zsh/custom/plugins/zsh-completions/src",
    
)
for completionPath in $completionPaths; do
    if [ -d "$completionPath" ]; then
        fpath=($completionPath $fpath)
    fi
done
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

bashCompletionScripts="/usr/local/etc/bash_completion.d"
if [ -d "$bashCompletionScripts" ]; then
    for bashCompletionScript in $bashCompletionScripts/*; do
        if [ "$bashCompletionScripts/hub.bash_completion.sh" != "$bashCompletionScript" ]; then
            if [ -f $bashCompletionScripts ]; then
                source "$bashCompletionScript"
            fi
        fi
    done
fi

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git z zsh-completions docker docker-compose)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# reload zsh config file
alias zsource="source ~/.zshrc"

#clear the screen
alias kk="clear"

# alias 'hub' to 'git'
eval "$(hub alias -s)"

# Functions
# ---------

binFuncs=( "docker" "docker-machine" "git" "zsh" "travis" "mt" "sloppy" )
for bin in "${binFuncs[@]}"; do
    if type "$bin" > /dev/null; then
        source ~/.zsh-functions/$bin
    fi
done

funcFiles=( "tad" "utils" "codeception" "nas" "local" "aliases" "project" )
for funcFile in "${funcFiles[@]}"; do
    if [ -f ~/.zsh-functions/${funcFile} ]; then
        source ~/.zsh-functions/${funcFile}
    fi
done

if [ -f ~/.zsh-functions/vvv ]; then
    source ~/.zsh-functions/vvv;
fi

# Deactivates XDebug on the local PHP binary
function xoff() {
    # sed -i '' '/^zend_extension.*xdebug.so/ s/zend_ex/;zend_ex/g' $(sed 's/,*$//g' <<< $(php --ini | grep xdebug.ini))
	file=$(php --ini | grep xdebug.ini | grep -o '[^ ]*$')
    sed -i '' '/^zend_extension.*xdebug.so/ s/zend_ex/;zend_ex/g' ${file}
}

# Activates XDebug on the local PHP binary
function xon() {
    # sed -i '' '/^;zend_extension.*xdebug.so/ s/;zend_ex/zend_ex/g' $(sed 's/,*$//g' <<< $(php --ini | grep xdebug.ini))
	file=$(php --ini | grep xdebug.ini | grep -o '[^ ]*$')
    sed -i '' '/^;zend_extension.*xdebug.so/ s/;zend_ex/zend_ex/g' ${file}
}

# SSH keys
# --------
# Add the SSH keys to the ssh-agent
# if [ -d "$HOME/.ssh" ]; then
    # eval "$(ssh-agent -s)"
    # for f in $HOME/.ssh/*; do
        # if [[ $f =~ "^.*\/known_hosts$" ]]; then
            # continue;
        # fi
        # if [[ $f =~ "^.*\.pub$" ]]; then
            # continue;
        # fi

        # ssh-add $f
    # done
# fi

# Start nodenv and append its path before the other ones.
eval "$(nodenv init -)"
export PATH=~/.nodenv/shims:$PATH

# phpenv
export PATH="$HOME/.phpenv/bin:$PATH"
eval "$(phpenv init -)"

# Add the node_module/.bin folder to the PATH.
export PATH=node_modules/.bin:$PATH

# Deduplicate the $PATH entries
export PATH=$(echo -n $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')

