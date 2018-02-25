FROM ubuntu:xenial

RUN apt update && apt install -y xserver-xorg-core libxv1 x11-xserver-utils curl

WORKDIR /tmp
RUN curl -L -o virtualgl_2.5.2_amd64.deb 'https://downloads.sourceforge.net/project/virtualgl/2.5.2/virtualgl_2.5.2_amd64.deb?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fvirtualgl%2Ffiles%2F2.5.2&ts=1509495317&use_mirror=auto'
RUN dpkg -i virtualgl_2.5.2_amd64.deb
RUN printf "1\nn\nn\nn\nx\n" | /opt/VirtualGL/bin/vglserver_config

# nvidia-xconfig --use-display-device=None --allow-empty-initial-configuration \
#   --virtual=1920x1080 --mode=1920x1080 --no-use-edid-dpi -o xorg.conf.nvidia-headless
COPY xorg.conf.nvidia-headless /etc/X11/xorg.conf

# create startx script for starting X server manually
RUN echo 'echo "Starting X server ..."\n\
Xorg vt10 :0 &\n\
echo "X server log: /var/log/Xorg.0.log"\n\
echo\n' > /usr/local/bin/startx
RUN chmod +x /usr/local/bin/startx

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
