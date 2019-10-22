# https://docs.docker.com/engine/examples/running_ssh_service/
FROM ubuntu:14.04

RUN apt-get update && apt-get install -y openssh-server vim ufw
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Add user
RUN useradd -g users -G sudo -m -s /bin/bash ubuntu && \
    echo 'ubuntu:foobar' | chpasswd

RUN echo 'Defaults visiblepw'             >> /etc/sudoers
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

EXPOSE 22
EXPOSE 80
CMD ["/usr/sbin/sshd", "-D"]
