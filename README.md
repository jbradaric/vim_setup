# Installation

To install the VIM configuration, perform these commands:

    git clone https://github.com/jbradaric/vim_setup.git vim_setup
    cd vim_setup
    ./prepare
    ./install

This will clone the repository, initialize plugin submodules, create the
necessary directories and create symlinks to ``.vim`` and ``.vimrc`` in the
$HOME directory.

# Configuration

Global plugin configuration is located in ``.vim/config``.  Local configuration
should be placed into ``.vim/local-config``.  The local configuration is sourced
after the global one and any overrides should be placed into this directory.

# Plugin requirements

* ``Khuno`` requires ``flake8`` to be in ``$PATH``.  To get ``flake8``, simply
  do ``pip install flake8``. If ``flake8`` executable is named differently,
  configure that in the local configuration with:

  ``let g:khuno_flake_cmd="/path/to/flake8/executable"``

* ``Ack.vim`` requires ``silver_searcher`` (``ag``) to be installed.  It can be found at
  ``https://github.com/ggreer/the_silver_searcher``.
