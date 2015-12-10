Installation:

```bash
git clone git://github.com/rdeese/dotvim.git ~/.vim &&
ln -s ~/.vim/vimrc ~/.vimrc &&
cd ~/.vim &&
git submodule update --init
```

Which
1. Clones repo
2. Symlinks vimrc
3. Installs all our vim plugins into bundle where they are incorporated via pathogen.
