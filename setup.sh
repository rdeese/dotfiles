#!/bin/bash

# PREREQUISITES
# - this repo must be cloned into ~/dotfiles
# - all preexisting dotfiles you wish to preserve must be moved out of
#   your home directory-- they will be overwritten otherwise.

echo "Setting up dotfiles..."

# add vim configuration, prompt user if anything would be overwritten
ln -s -i ~/dotfiles/vim ~/.vim
ln -s -i ~/.vim/vimrc ~/.vimrc

# add git configuration
ln -s -i ~/dotfiles/git ~/.git
git config --global core.excludesfile ~/.git/gitignore_global
git config --global --add include.path ~/.git/gitconfig
git config --global --add user.name rdeese
git config --global --add user.email rdeese@hmc.edu

# add tmux configuration
ln -s -i ~/dotfiles/tmux.conf ~/.tmux.conf

# add mutt configuration
ln -s -i ~/dotfiles/mutt/muttrc ~/.muttrc
ln -s -i ~/dotfiles/mutt/mailcap ~/.mailcap

# add to .bash_profile
cat >> ~/.bash_profile <<EOF
  
# load configuration from dotfiles.
# for best results, place all other modifications above this line.
source ~/dotfiles/bash_profile
EOF
source ~/.bash_profile

echo "Complete. Rerunning this script is mostly harmless--"\
     "it will add a duplicate line to your .bash_profile."
