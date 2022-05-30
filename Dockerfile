FROM ros:galactic as runtime

RUN echo "source /opt/ros/galactic/setup.bash" >> /root/.bashrc

RUN groupadd --gid 1000 ros \
  && useradd -s /bin/bash --uid 1000 --gid 1000 -m ros \
  && usermod -a -G video ros \
  && echo "source /opt/ros/galactic/setup.bash" >> /home/ros/.bashrc

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends wget

RUN curl -s https://packagecloud.io/install/repositories/dirk-thomas/vcstool/script.deb.sh | sudo bash \
    &&apt-get update \
    &&apt-get install -y python3-vcstool

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y apt-transport-https \
    && apt-get install -y dotnet-sdk-3.1

RUN apt install python3-colcon-common-extensions

WORKDIR '/workspace/sunny'

# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends git

RUN git clone https://github.com/RobotecAI/ros2cs.git

RUN cd ros2cs

RUN ./get_repos.sh
RUN /bin/bash -c 'source /opt/ros/galactic/setup.bash' && ./build.sh