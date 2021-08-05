# Dotfiles
This is a collection of my dotfiles.

## Used libraries
* [Exa](https://github.com/ogham/exa)

## To-Do
* Write script to automate setup of a new machine
** Handle all the symlinks creation

* Always run `brew install reattach-to-user-namespace`

### Nvim
* `ln -s /Users/aclapinpepin/code/dotfiles/vim/init.vim /Users/aclapinpepin/.config/nvim/init.vim`

### After installing packages
* Run Vim-plug in vim
* Run zplug in zsh
* Setup faster key repeat (MacOS) `defaults write -g KeyRepeat -int 1.1`

### Packages and stuff to consider in script
* [zplug](https://github.com/zplug/zplug) | Install manually and not from Homebrew so that you can manage the instalation
  directory
* Exa (see above)
* [vim-plug](https://github.com/junegunn/vim-plug)
* [ack](https://beyondgrep.com/install/)
* consider using [asdf](https://github.com/asdf-vm/asdf)
* Increse key repeat manually [For Mac](https://ksearch.wordpress.com/2017/06/20/increase-the-key-repeat-rate-in-os-x-sierra/)
* [zsh-completions](https://github.com/Homebrew/homebrew-core/blob/master/Formula/zsh-completions.rb)

## References
* [Effortless Ctags with Git](http://tbaggery.com/2011/08/08/effortless-ctags-with-git.html)
* [vim-plug](https://github.com/junegunn/vim-plug)

## Inspiration
* [Chris Toomey](https://github.com/christoomey/dotfiles)
