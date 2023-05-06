FROM nvim-base
USER root

RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo dd of=/usr/share/keyrings/microsoft.gpg
RUN printf 'deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/22.04/prod jammy main\n' | tee /etc/apt/sources.list.d/microsoft.list >/dev/null
RUN apt update && apt install -y dotnet-sdk-7.0
COPY ./container/dotnet/init.lua /usr/share/nvim/init.lua

user vscode

