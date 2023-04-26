FROM nvim-base

USER root

# Install tectonic
RUN apt update && apt install -y --no-install-recommends fuse libfuse2
RUN wget https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic%400.12.0/tectonic-0.12.0-x86_64.AppImage -O /usr/bin/tectonic
ENV APPIMAGE_EXTRACT_AND_RUN=1
RUN chmod -R +x /usr/bin/tectonic

# Install biber
RUN wget -O /tmp/biber.tar.gz https://deac-ams.dl.sourceforge.net/project/biblatex-biber/biblatex-biber/2.17/binaries/Linux/biber-linux_x86_64.tar.gz 
RUN tar -C /usr/bin -xzvf /tmp/biber.tar.gz 
RUN chmod -R +x /usr/bin/biber


COPY ./container/latex/init.lua /usr/share/nvim/init.lua

USER vscode
