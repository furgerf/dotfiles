# dotfiles
This repository contains some of my configuration files. They're somewhat
loosely grouped into three categories: `arch`, `awesome`, and `vim`. Please feel
free to use anything you might find useful :)

I'll briefly describe what's in here and how I use it. You'll also find some
installation instructions below.

## arch
This is a somewhat random collection of mostly system configuration files on my
[ArchLinux](https://www.archlinux.org/) system. I've put some of them in the
repo more as a backup, such as my X11 config. I'll list a few of the more
interesting ones here:

### bash
`arch/bashrc` is my main bashrc file that contains a lot of general-purpose
aliases, functions, etc. Since I use these dotfiles on different machines, I
want different, machine-specific configuration. That's what
`arch/bash-sourcer.sh` is for - a file that doesn't exist by default and is
ignored by git. If you want to source further files, create this file and source
other files from `arch/bash.d` - which won't interfere with git.

Also have a look `arch/inputrc` for various mappings in vi-edit mode and
specific configuration of tab completion.

### git
My `arch/gitconfig` also contains many aliases that I find useful in everyday
git usage. `arch/git-templates/hooks` contains hooks that automatically runs
ctags (with config `arch/ctags`) after checkout/commit/merge/rebase.

### tmux
I run a fairly customized tmux with main config file `arch/tmux.conf` and
plugins in `arch/tmux/plugins`. The colors used come from the
[gruvbox](https://github.com/morhetz/gruvbox) vim color palette, which I've
[adapted](https://github.com/furgerf/gruvbox) to my preferences.

### conky
I love having an unobtrusive view on machine performance and load, so I've put a
lot of effort into my `arch/conkyrc`. However, I've had to remove the weather
overview after the weather data format changed apparently, that was being parsed
by [TeoBigusGeekus' script](https://forums.bunsenlabs.org/viewtopic.php?id=189).
If you want to display weather information like that, make sure you have
`arch/fonts/ConkyWeather.ttf`.

Note that this conky config uses several of my [various small
scripts](https://github.com/furgerf/linux-scripts/).

### awesome
I use [awesomeWM](http://awesome.naquadah.org/) as my main window manager. After
configuring it thoroughly a few years ago, I hardly changed anything. Therefore,
several new, interesting modules would be available.

### vim
The main `vim/vimrc` contains almost only options anymore. Most mappings and
plugin configuration is moved into various scripts in `vim/plugin/*.vim`. There
is also some filetype-specific config in `vim/ftplugin/*.vim`.

Third-party plugins are managed with
[pathogen](https://github.com/tpope/vim-pathogen).

The colorscheme [gruvbox](https://github.com/morhetz/gruvbox) is slightly
[modified](https://github.com/furgerf/gruvbox) to my preferences, but mos of the
initial colorscheme remains intact.

# Installation
Run `install.sh` which asks for various dotfiles whether or not they should be
installed. Installing means creating a symlink to the repo for the specified
file so that it's detected by the relevant application.

Currently, if a file already exists, the installation asks whether or not to
overwrite the existing file with the symlink. It's
[planned](https://github.com/furgerf/dotfiles/issues/3) to extend the
installation script to provide a backup option as well.

# Credit
Most of my configuration is aggregated from various sources ranging from other
dotfile repos over blog posts to stackoverflow. Where possible, I provide a
link to the original information - but I'm sure I've missed many.  Likewise, I
hope my config is useful to others.

# License
See [license](https://github.com/furgerf/dotfiles/blob/master/LICENSE).

