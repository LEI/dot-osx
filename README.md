# dot-osx

## Manual installation

Clone and change directory

    git clone https://github.com/LEI/dot-osx.git ~/.dot/osx && cd $_

Create the directory `~/.config/karabiner`

    mkdir -p "$HOME/.config/karabiner"

Link files to home directory

    ln -isv "~/.dot/osx/.config/karabiner/*" "$HOME/.config/karabiner"
