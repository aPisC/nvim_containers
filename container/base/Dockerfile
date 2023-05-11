# See available dev images https://hub.docker.com/_/microsoft-devcontainers?tab=description
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install deps
RUN curl -sL https://deb.nodesource.com/setup_16.x | sh
RUN apt update 
RUN apt install -y nodejs
RUN apt install -y python3-pip
RUN apt install -y python3-venv

# Install program deps
RUN apt install -y silversearcher-ag

# Install NeoVim
ENV VIM_PLUGGED=/usr/share/nvim
# RUN wget -O /tmp/nvim.deb https://github.com/neovim/neovim/releases/download/v0.8.3/nvim-linux64.deb
RUN wget -O /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
# RUN mkdir -p /usr/share/nvim
RUN tar -C /usr --strip-components=1 -xzvf /tmp/nvim.tar.gz nvim-linux64
RUN rm /tmp/nvim.tar.gz
# RUN ls -la /usr/bin | grep vim && false
RUN ln -s /usr/bin/nvim /usr/bin/vim
RUN /usr/bin/python3 -m pip install pynvim

RUN sh -c 'curl -fLo /usr/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
COPY ./container/base/sysinit.vim /usr/share/nvim/sysinit.vim
COPY ./init/00_plug.lua /usr/share/nvim/init.lua
RUN vim +PlugInstall +qall

COPY ./container/base/init.lua /usr/share/nvim/init.lua
COPY . /usr/share/nvim

RUN chmod -R a+rwx /usr/share/nvim 

WORKDIR /workspace
USER vscode
CMD sleep infinity
