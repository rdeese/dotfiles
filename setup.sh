#!/bin/zsh

# PREREQUISITES
# - this repo must be cloned into ~/dotfiles
# - all preexisting dotfiles you wish to preserve must be moved out of
#   your home directory-- they will be overwritten otherwise.

echo "Setting up dotfiles..."

## VIM ###
# add vim configuration, prompt user if anything would be overwritten
ln -s -i ~/dotfiles/vim ~/.vim
ln -s -i ~/.vim/vimrc ~/.vimrc

## NVIM
ln -s -i ~/dotfiles/nvim ~/.config/nvim

## GIT ##
# add git configuration
ln -s -i ~/dotfiles/git ~/.git
git config --global core.excludesfile ~/.git/gitignore_global
git config --global --add include.path ~/.git/gitconfig
git config --global --add user.name rdeese
git config --global --add user.email github@rh.deese.org

## TMUX ##
# add tmux configuration
ln -s -i ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
# install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

## MUTT ## (defunct)
# add mutt configuration
# ln -s -i ~/dotfiles/mutt/muttrc ~/.muttrc
# ln -s -i ~/dotfiles/mutt/mailcap ~/.mailcap

## PYTHON ##
# add default python linter configurations
ln -s -i ~/dotfiles/python/flake8 ~/.flake8
ln -s -i ~/dotfiles/python/pylintrc ~/.pylintrc

## ZSH ##
# add to .zsh
cat >> ~/.zshenv <<EOF

# load configuration from dotfiles.
# for best results, place all other modifications above this line.
source ~/dotfiles/zsh/zshenv
EOF

# add to .zshrc
cat >> ~/.zshrc <<EOF

# load configuration from dotfiles.
# for best results, place all other modifications above this line.
source ~/dotfiles/zsh/zshrc
EOF

# add to .zshrc
cat >> ~/.zprofile <<EOF

# load configuration from dotfiles.
# for best results, place all other modifications above this line.
source ~/dotfiles/zsh/zprofile
EOF

source ~/.zshenv
source ~/.zprofile
source ~/.zshrc

echo "Complete. Rerunning this script is mostly harmless--"\
     "it will add a duplicate line to your .bash_profile."
