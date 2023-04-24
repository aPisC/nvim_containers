FROM nvim-base

RUN mkdir -p /root/.local/share/nvim/mason/bin/

# Install tectonic
RUN apt update && apt install -y --no-install-recommends fuse libfuse2
RUN wget https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic%400.12.0/tectonic-0.12.0-x86_64.AppImage -O /root/.local/share/nvim/mason/bin/tectonic
ENV APPIMAGE_EXTRACT_AND_RUN=1

# Install biber
RUN wget -O /tmp/biber.tar.gz https://deac-ams.dl.sourceforge.net/project/biblatex-biber/biblatex-biber/2.17/binaries/Linux/biber-linux_x86_64.tar.gz 
RUN tar -C /root/.local/share/nvim/mason/bin -xzvf /tmp/biber.tar.gz 


RUN chmod -R +x /root/.local/share/nvim/mason/bin
COPY ./container/latex/init.lua /root/.config/latex/init.lua
