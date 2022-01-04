# Vim-PlatformIO
## Introduction
This is a collection of helper commands for VIM to ease the use of PlatformIO with VIM.

Its very much a WIP, its literally just parts of my vimrc outsourced into a plugin.

## Installation
With Plug:
```
Plug 'normen/vim-pio'
```

## Documentation

### Commands
- `:PIO`
  - Mirrors the command line command and opens a term window. Note theres always only one PIO window.
- `:PIONew`
  - Shows a list of boards, press enter on a board name to create a new project in the current folder based on that board.
- `:PIOLibrary <search>`
  - Shows a list of libraries, press enter on a library name to add it to the project.
- `:PIOInit <boardname>`
  - Creates a new project with the selected board name, supports auto-completion of the name.
- `:PIOInstall <library>`
  - Installs a library by name or id, supports auto-completion of the name.
- `:PIORefresh`
  - Refreshes the `.ccls` file needed for code completion (see below)

### Makefile
The plugin creates a `Makefile` for the project with the following targets:
- `all` (default)
- `upload`
- `clean`
- `program`
- `uploadfs`

This way you can use a simple `:make upload` to compile and upload your code to your microcontroller.

## Other things
### Code completion
To have code completion you'll need the `ccls` language server installed as well as a plugin for vim to use it. For example `coc-nvim` or `vim-lsp`.

I suggest also installing the awesome `vim-dispatch` plugin by tpope to be able to run compilations in the background.
