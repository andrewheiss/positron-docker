FROM rocker/tidyverse

# Install system dependencies
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    openssh-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \ 
    && mkdir -p /run/sshd

# Password-less sudo in case things need to be installed from the terminal
# I have no idea what the sudo password is for this Docker container ¯\_(ツ)_/¯
RUN echo "rstudio ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Make sure there's a .ssh folder with the right permissions. The 
# local id_rsa.pub gets mounted to here through Docker Compose
RUN mkdir -p /home/rstudio/.ssh \
    && chown rstudio:rstudio /home/rstudio/.ssh \
    && chmod 700 /home/rstudio/.ssh

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
