# Installation

To install the VIM configuration, perform these commands:

    git clone https://github.com/jbradaric/vim_setup.git vim_setup
    cd vim_setup
    ./install

This will clone the repository, create the necessary directories and create
symlinks to ``.vim``, ``.vimrc`` in the $HOME directory and create
``$HOME/.config/nvim`` as a symlink to ``.vim``.

# Configuration

Global plugin configuration is located in ``.vim/config``.  Local configuration
should be placed into ``.vim/local-config``.  The local configuration is sourced
after the global one and any overrides should be placed into this directory.
