SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --no-builtin-rules
.SILENT:

PWD ?= pwd_unknown
PROJECT_NAME=$(notdir $(PWD))

define backup_file
	[ -d "${HOME}/dotfiles-bak" ] || mkdir -p "${HOME}/dotfiles-bak"
	[ -f $(1) ] && { mv $(1) ${HOME}/dotfiles-bak; echo "Moved $(1) to ${HOME}/dotfiles-bak"; } \
			|| echo "No previous $(1) found"
endef

define backup_dir
	[ -d "${HOME}/dotfiles-bak" ] || mkdir -p "${HOME}/dotfiles-bak"
	[ -d $(1) ] && { mv $(1) ${HOME}/dotfiles-bak; echo "Moved $(1) to ${HOME}/dotfiles-bak"; } \
			|| echo "No previous $(1) found"
endef

link:
	$(call backup_file,~/.vimrc)
	ln -s ${PWD}/vimrc ~/.vimrc
	ls -la ~/.vimrc
	$(call backup_file,~/.zshrc)
	ln -s ${PWD}/zshrc ~/.zshrc
	ls -la ~/.zshrc
	$(call backup_dir,~/.zsh-functions)
	ln -s ${PWD}/zsh-functions ~/.zsh-functions
	ls -la ~/.zsh-functions
	$(call backup_file,~/.git/config)
	ln -s ${PWD}/gitconfig ~/.gitconfig
	ls -la ~/.gitconfig
