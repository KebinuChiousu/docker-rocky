FROM rockylinux/rockylinux:8
ENV maintainer Kevin Meredith <kevin@meredithkm.info>

RUN yum -y install openssh-clients openssh-server iputils bind-utils nc wget && \
    yum -y install git sudo python3 procps net-tools && \
    yum clean all

ADD services/sshd-keygen.service /etc/systemd/system/sshd-keygen.service

RUN usermod -p "!" root
COPY config/authorized_keys /root/.ssh/authorized_keys
COPY config/sudoers /etc/sudoers
RUN chmod 440 /etc/sudoers
RUN chown root:root /etc/sudoers

RUN useradd -g wheel -s /bin/bash rocky
COPY config/authorized_keys /home/rocky/.ssh/authorized_keys
RUN mkdir /home/rocky/git
RUN chown -R rocky:wheel /home/rocky
RUN chmod -R 755 /home/rocky
RUN chmod 640 /home/rocky/.ssh/authorized_keys

RUN mkdir -p /srv/repo/rpm

RUN systemctl enable sshd.service
RUN systemctl enable sshd-keygen.service

COPY sysd/systemctl3.py /usr/bin/systemctl

VOLUME /etc/ssh
VOLUME /home/rocky
VOLUME /srv/repo
EXPOSE 22

ENTRYPOINT ["/usr/bin/systemctl"]
