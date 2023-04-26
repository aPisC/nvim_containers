FROM nvim-base
USER root

RUN apt update && apt install -y dotnet-sdk-6.0
COPY ./container/dotnet/init.lua /usr/share/nvim/init.lua

user vscode

