install:
	mkdir -p $$HOME/.ssh
	ln -s $$HOME/repos/src/github.com/dty1er/dotfiles/bash_profile $$HOME/.bash_profile
	ln -s $$HOME/repos/src/github.com/dty1er/dotfiles/gitconfig $$HOME/.gitconfig
	# ln -s $$HOME/repos/src/github.com/dty1er/dotfiles/ssh_config $$HOME/.ssh/config
	ln -s $$HOME/repos/src/github.com/dty1er/dotfiles/tmux.conf $$HOME/.tmux.conf
	ln -s $$HOME/repos/src/github.com/dty1er/dotfiles/vimrc $$HOME/.vimrc
