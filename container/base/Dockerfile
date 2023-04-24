# See available dev images https://hub.docker.com/_/microsoft-devcontainers?tab=description
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install node
RUN curl -sL https://deb.nodesource.com/setup_16.x | sh
RUN apt update && apt -y install nodejs

# Install program deps
RUN apt install -y silversearcher-ag

# Install NeoVim
RUN wget -O /tmp/nvim.deb https://github.com/neovim/neovim/releases/download/v0.8.3/nvim-linux64.deb
RUN dpkg -i /tmp/nvim.deb
RUN rm /tmp/nvim.deb
RUN ln -s /usr/bin/nvim /usr/bin/vim
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
COPY ./init/00_plug.lua /root/.config/nvim/init.lua
RUN vim +PlugInstall +qall

COPY ./container/base/init.lua /root/.config/nvim/init.lua
COPY . /root/.config/nvim

WORKDIR /workspace
CMD sleep infinity
