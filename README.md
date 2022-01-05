# Vim-PlatformIO
## Introduction
This is a collection of helper commands for VIM to ease the use of PlatformIO with VIM.

Its very much a WIP, its literally just parts of my vimrc outsourced into a plugin.

## Features

- Select board from a list
- Create project incl. Makefile
- Search and install libararies from a list
- Errors and warnings with jumpmarks to relevant code files
- Supports code completion (needs language server plugin, see below)

## Installation
With Plug:
```
Plug 'normen/vim-pio'
```

## Documentation

Use `:h pio` in vim to access the documentation.

### Commands
- `:PIO`
  - Mirrors the command line command and opens a term window. Note theres always only one PIO window.
- `:PIONewProject <search>`
  - Shows a list of boards, press enter on a board name to create a new project in the current folder based on that board.
- `:PIOAddLibrary <search>`
  - Shows a list of libraries, press enter on a library name to add it to the project.
- `:PIORemoveLibrary`
  - Shows a list of installed libraries, press enter on a library name to remove it from the project.

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
