ARG BASE_IMAGE=mcr.microsoft.com/devcontainers/base:ubuntu

FROM ${BASE_IMAGE}

ENV VIM_PLUGGED=/usr/share/nvim

# Install deps
RUN curl -sL https://deb.nodesource.com/setup_16.x | sh
RUN apt update 
RUN apt install -y nodejs
RUN apt install -y python3-pip
RUN apt install -y python3-venv
RUN apt install -y sqlite3 libsqlite3-dev
RUN apt install -y xclip
RUN apt install -y silversearcher-ag

# Install NeoVim
RUN wget -O /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.9.1/nvim-linux64.tar.gz

# RUN mkdir -p /usr/share/nvim
RUN tar -C /usr --strip-components=1 -xzvf /tmp/nvim.tar.gz nvim-linux64
RUN rm /tmp/nvim.tar.gz
RUN ln -s /usr/bin/nvim /usr/bin/vim
RUN /usr/bin/python3 -m pip install pynvim

# RUN sh -c 'curl -fLo /usr/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
COPY ./container/base/sysinit.vim /usr/share/nvim/sysinit.vim

COPY ./lua /usr/share/nvim/runtime/lua
COPY ./lazy-lock.json /usr/share/nvim/runtime
COPY ./container/base/init.lua /usr/share/nvim/runtime/init.lua

RUN chmod -R a+rwx /usr/share/nvim/runtime

WORKDIR /workspace
USER vscode

ENTRYPOINT ["tail", "-f", "/dev/null"]
