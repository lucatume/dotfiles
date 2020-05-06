# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Theme
# =====
# Install powerlevel9k: git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
# (see https://github.com/bhilburn/powerlevel9k/wiki/Install-Instructions#step-1-install-powerlevel9k)
ZSH_THEME="powerlevel10k/powerlevel10k"
# These settings apply to the powerlevel9k zsh theme.
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
# POWERLEVEL9K_DIR_FOREGROUND=''
# POWERLEVEL9K_DIR_BACKGROUND=''
# POWERLEVEL9K_VCS_FOREGROUND=''
# POWERLEVEL9K_VCS_BACKGROUND=''
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
# See https://github.com/Powerlevel9k/powerlevel9k#dir
POWERLEVEL9K_SHORTEN_STRATEGY=default
# Use with light themes.
POWERLEVEL9K_COLOR_SCHEME='dark'
POWERLEVEL9K_PROMPT_ON_NEWLINE=false

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
"/usr/local/bin" # homebrew on MacOs.
"/usr/local/sbin" # homebrew sbin path.
"$HOME/.composer/vendor/bin" # Global Composer binaries on Mac OS.
"$HOME/.config/composer/vendor/bin" # Global Composer binaries on Linux.
"/home/linuxbrew/.linuxbrew/bin" # Linuxbrew default installation.
"$HOME/.linuxbrew/bin" # Linuxbrew alt installation path.
"$HOME/go/bin" # Go language binaries.
"$HOME/Repos/tribe-product-utils" # Modern Tribe Products utils.
)
for binPath in ${binPaths}; do
    if [ -d ${binPath} ]; then
        export PATH="$binPath:$PATH"
    fi
done

# Add the relative paths.
relativeBinPaths=(
	"." # The current folder.
	"vendor/bin" # Local Composer binaries.
	"node_modules/.bin" # Local Node binaries.
)
for binPath in ${relativeBinPaths}; do
	export PATH="$binPath:$PATH"
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
# If brew is installed then load the shell completions.
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git z docker docker-compose )

# If the git-it-on plugin is installed, then activate it.
# See: https://github.com/peterhurford/git-it-on.zsh
if [ -d ${HOME}/.oh-my-zsh/custom/plugin/git-it-on ]; then
	plugins+=(git-it-on)
fi
# Load oh-my-zsh.
source $ZSH/oh-my-zsh.sh

# Reload completions after oh-my-zsh loaded.
autoload bashcompinit
bashcompinit
compinit

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
export SSH_KEY_PATH="~/.ssh/id_rsa"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Reload zsh config file.
alias zsource="source ~/.zshrc"
# Edit this file.
alias zvim="vim ~/.zshrc"
# Clear the screen.
alias kk="clear"
# Alias 'hub' to 'git'.
eval "$(hub alias -s)"

# Function files
# ==============

# Load a set of function files; each one will be loaded if the corresponding binary is present.
binFuncs=( "docker" "docker-machine" "git" "zsh" "travis" "mt" )
for bin in "${binFuncs[@]}"; do
	exists="$(type "$bin" >/dev/null 2>&1; echo $?)"
    if  [ $exists ]; then
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

if [[ "$(type nodenv >/dev/null 2>&1; echo $?)" == 0 ]]; then
	# Start nodenv and append its path before the other ones.
	# This command is not fenced into a if-then check as I want an error thrown if not installed.
	export PATH=~/.nodenv/shims:$PATH
	eval "$(nodenv init -)"
fi

if [[ -d  "$HOME/.phpenv/bin" ]]; then
	# Start phpenv and append its path before the other ones.
	# This command is not fenced into a if-then check as I want an error thrown if not installed.
	export PATH="$HOME/.phpenv/bin:$PATH"
	eval "$(phpenv init -)"
fi

# Mac built-in bison version might not be able to compile PHP.
# Load the homebrew one if available.
if [ -d /usr/local/opt/bison/bin ]; then
	export PATH="/usr/local/opt/bison/bin:$PATH"
fi

# If Homebrew gnubin director exists, then prepend it to the path.
if [ -d /usr/local/opt/make/libexec/gnubin ]; then
    PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
fi

# vi mode for the cli.
bindkey -v
# Kill the timeout for keys.
export KEYTIMEOUT=1

# if nnn is installed then open all files in $EDITOR.
# https://github.com/jarun/nnn
export NNN_USE_EDITOR=1
	
# If googler is installed, then alias it to "g".
if type googler &>/dev/null; then
  alias g="googler -l en -c com"
fi

# Added by travis gem.
# If lazygit is installed, then alias it to "lgit".
if type lazygit &>/dev/null; then
  alias lgit="lazygit"
fi

# Added by travis gem.	
[ -f /Users/lucatume/.travis/travis.sh ] && source /Users/lucatume/.travis/travis.sh

# If Modern Tribe `tric` is available, then add it to PATH.
test -f "${HOME}/Repos/products-test-automation/dev/tric" && export PATH="${HOME}/Repos/products-test-automation/dev:$PATH"

# Deduplicate the $PATH entries.
DEDUPED_PATH=$(n= IFS=':'; for e in $PATH; do [[ :$n == *:$e:* ]] || n+=$e:; done; echo "${n:0: -1}")
export PATH=$DEDUPED_PATH

# Alias to allow PHP scripts to pickup a locally originated wp-cli request.
alias lwp="LOCALHOST_WP=1 wp"

# Activate linuxbrew if installed.
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# Mono-repo tools, install with: git clone https://github.com/shopsys/monorepo-tools ~/monorepo-tools
test -d "${HOME}/Repos/monorepo-tools" && export PATH="${HOME}/Repos/monorepo-tools:$PATH"

# Activate brew bash-completions if available.
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Alias `ls -la` to `l`
alias l="ls -la"

# If rg is installed and ag is not, then alias rg to ag.
test $(type "ag" > /dev/null;) || alias ag=rg
