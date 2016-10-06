#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:16.04


# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  #add-apt-repository ppa:webupd8team/java -y && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  # Install Ubuntu's lightweight X11 Desktop Environment LXDE
  DEBIAN_FRONTEND=noninteractive apt-get install -y lxde-core lxterminal tightvncserver && \
  apt-get install -y libgtk2.0-0 libcanberra-gtk-module && \
  # \
  #\
  #  echo "===> add webupd8 repository..."  && \
  #  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
  #  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
  #  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886  && \
    #apt-get update  && \
  #\
  #\
  #\
  #echo "===> install Java"  && \
  #echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
  #echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
  #DEBIAN_FRONTEND=noninteractive  apt-get install -y --force-yes oracle-java7-installer oracle-java7-set-default  && \
  #\
  #\
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer && \
  echo "===> clean up..."  && \
  rm -rf /var/cache/oracle-jdk7-installer  && \
  \
  \
  # Install Chrome Internet browser
  wget -q -O - http://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install -y google-chrome-stable && \
  apt-get clean  && \
  rm -rf /var/lib/apt/lists/* 

#COPY eclipse-automotive-luna-SR2-incubation-linux-gtk-x86_64.tar.gz /tmp/eclipse.tar.gz
#COPY eclipse-jee-luna-SR2-linux-gtk-x86_64.tar.gz /tmp/eclipse.tar.gz

RUN \
    wget http://eclipse.stu.edu.tw/technology/epp/downloads/release/luna/SR2/eclipse-jee-luna-SR2-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz -q && \
    echo 'Installing eclipse' && \
    tar -xf /tmp/eclipse.tar.gz -C /opt && \
    rm /tmp/eclipse.tar.gz && \
    echo "exec /opt/eclipse/eclipse" > /usr/local/bin/eclipse

# Add developer user
RUN chmod +x /usr/local/bin/eclipse && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer && \
    chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo && \
    mkdir -p /home/developer/Desktop

# Add files.
ADD root/.bashrc /home/developer/.bashrc
ADD root/.gitconfig /home/developer/.gitconfig
ADD root/.scripts /home/developer/.scripts
ADD eclipse.desktop /usr/share/applications
ADD eclipse.desktop /home/developer/Desktop

RUN chmod +x /usr/local/bin/eclipse

USER developer

# Set environment variables.
ENV HOME /home/developer

# Define working directory.
WORKDIR /home/developer


# Expose ports for VNC
EXPOSE 5901

# Define default command.
CMD ["bash"]
