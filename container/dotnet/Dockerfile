FROM nvim-base
USER root

# RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo dd of=/usr/share/keyrings/microsoft.gpg
# RUN printf 'deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/22.04/prod jammy main\n' | tee /etc/apt/sources.list.d/microsoft.list >/dev/null

RUN apt remove -y --purge --autoremove *dotnet*
# RUN echo "Package: *net*" >> /etc/apt/preferences
# RUN echo "Pin: origin packages.microsoft.com" >> /etc/apt/preferences
# RUN echo "Pin-Priority: 1001" >> /etc/apt/preferences

RUN apt update
RUN apt install -y dotnet-sdk-7.0


RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc
RUN curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
RUN apt update
RUN apt install -y sqlcmd
COPY ./container/dotnet/init.lua /usr/share/nvim/runtime/init.lua

ENTRYPOINT ["tail", "-f", "/dev/null"]

user vscode

