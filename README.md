Installation:

```bash
git clone https://github.com/rdeese/dotvim.git ~/.vim &&
ln -s ~/.vim/vimrc ~/.vimrc &&
cd ~/.vim &&
git submodule update --init
```

Which

1. Clones repo
2. Symlinks vimrc
3. Installs all our vim plugins into bundle where they are incorporated via pathogen.

Then, to create symlinks and add to your `bash_profile`, run:

```bash
./setup.sh
```

Finally, if you want to get `gitconfig` settings, prepend the following to your global `.gitconfig`:

```
[include]
  path = ~/dotfiles/git/gitconfig
```
