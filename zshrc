# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Theme
# =====
# Install powerlevel9k: git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
# (see https://github.com/bhilburn/powerlevel9k/wiki/Install-Instructions#step-1-install-powerlevel9k)
ZSH_THEME="powerlevel9k/powerlevel9k"
# These settings apply to the powerlevel9k zsh theme.
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_with_package_name
# Use with light themes.
POWERLEVEL9K_COLOR_SCHEME='light'

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
# =====
# Binaries - look around for different setups.
# Register them here to dynamically load them from the ~/.zsh-functions files.
binPaths=(
"." # The current folder.
"vendor/bin" # Local Composer binaries.
"node_modules/.bin" # Local Node binaries.
"/usr/local/bin" # homebrew on MacOs.
"$HOME/.composer/vendor/bin" # Global Composer binaries.
"/home/linuxbrew/.linuxbrew/bin" # Linuxbrew default installation.
"$HOME/.linuxbrew/bin" # Linuxbrew alt installation path.
"/usr/lib/go-1.8/bin" # Go language binaries.
"$HOME/Repos/tribe-product-utils" # Modern Tribe Products utils.
)
for binPath in ${binPaths}; do
    if [ -d ${binPath} ]; then
        export PATH="$binPath:$PATH"
    fi
done

# If using Homebrew use its binaries for the following languages.
homebrewLangs=( "ruby" "python" )
for homebrewLang in ${homebrewLangs}; do
	if type "brew --prefix ${homebrewLang}" > /dev/null; then
		export PATH=$(brew --prefix ruby)/bin:$PATH
		# Set the PYTHONPATH correctly.
		if "${homebrewLang}" == "python"; then
			export PATH="/usr/local/opt/python/libexec/bin:$PATH"
		fi
	fi
done

# ZSH and bash completions
# ========================
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

# Reload zsh and bash completions.
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Source the zsh-completions plugin directly.
if [ -d /usr/local/share/zsh-completions ]; then
	source /usr/local/share/zsh-completions
fi

# Source bash completion scripts.
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
plugins=(git z docker docker-compose)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='vim'
fi

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

# Function files
# ==============

# Load a set of function files; each one will be loaded if the corresponding binary is present.
binFuncs=( "docker" "docker-machine" "git" "zsh" "travis" "mt" )
for bin in "${binFuncs[@]}"; do
    if type "$bin" > /dev/null; then
        source ~/.zsh-functions/$bin
    fi
done

# Load a set of function files not related to specific binaries.
funcFiles=( "tad" "utils" "codeception" "nas" "local" "aliases" "project" "utils" "vvv" "php" )
for funcFile in "${funcFiles[@]}"; do
    if [ -f ~/.zsh-functions/${funcFile} ]; then
        source ~/.zsh-functions/${funcFile}
    fi
done

# Start nodenv and append its path before the other ones.
# This command is not fenced into a if-then check as I want an error thrown if not installed.
export PATH=~/.nodenv/shims:$PATH
eval "$(nodenv init -)"

# Start phpenv and append its path before the other ones.
# This command is not fenced into a if-then check as I want an error thrown if not installed.
export PATH="$HOME/.phpenv/bin:$PATH"
eval "$(phpenv init -)"

# Mac built-in bison version might not be able to compile PHP.
# Load the homebrew one if available.
if [ -d /usr/local/opt/bison/bin ]; then
	export PATH="/usr/local/opt/bison/bin:$PATH"
fi

# Deduplicate the $PATH entries.
export PATH=$(echo -n $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')

