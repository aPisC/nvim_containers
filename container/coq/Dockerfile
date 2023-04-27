FROM nvim-base
USER root

RUN apt update
RUN apt install -y coq
COPY ./container/coq/init.lua /usr/share/nvim/init.lua

USER vscode
