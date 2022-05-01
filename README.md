# Dotfiles
This is a collection of my dotfiles.

## Used libraries
* [Exa](https://github.com/ogham/exa)
* [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
* [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
* [starship](https://starship.rs/)

## To-Do
* Write script to automate setup of a new machine
** Handle all the symlinks creation

* Always run `brew install reattach-to-user-namespace`

### Nvim
* `ln -s /Users/aclapinpepin/code/dotfiles/vim/init.vim /Users/aclapinpepin/.config/nvim/init.vim`

### After installing packages
* Setup faster key repeat (MacOS) `defaults write -g KeyRepeat -int 1.1`

### Packages and stuff to consider in script
* Exa (see above)
* [ack](https://beyondgrep.com/install/)
* consider using [asdf](https://github.com/asdf-vm/asdf)
* Increse key repeat manually [For Mac](https://ksearch.wordpress.com/2017/06/20/increase-the-key-repeat-rate-in-os-x-sierra/)
* [zsh-completions](https://github.com/Homebrew/homebrew-core/blob/master/Formula/zsh-completions.rb)

## References
* [Effortless Ctags with Git](http://tbaggery.com/2011/08/08/effortless-ctags-with-git.html)

## Inspiration
* [Chris Toomey](https://github.com/christoomey/dotfiles)
