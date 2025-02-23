FROM osrf/ros:kinetic-desktop-full-xenial

RUN apt-get update \
    && apt-get install -y curl \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - \
    && apt-get update \
    && apt-get install -y ros-kinetic-navigation \
    && apt-get install -y ros-kinetic-robot-localization \
    && apt-get install -y ros-kinetic-robot-state-publisher \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt install -y software-properties-common \
    # && add-apt-repository -y ppa:borglab/gtsam-release-4.0 \
    # && apt-get update \
    # && apt install -y libgtsam-dev libgtsam-unstable-dev \
    && apt install -y wget \
    && rm -rf /var/lib/apt/lists/*
    
RUN apt-get update \
    && apt install -y zip \
    && rm -rf /var/lib/apt/lists/*


 RUN mkdir -p ~/download && wget -O ~/download/gtsam.zip https://github.com/borglab/gtsam/archive/4.0.0-alpha2.zip \
    && cd ~/download && unzip gtsam.zip -d ~/download/ && cd ~/download/gtsam-4.0.0-alpha2/ && mkdir build && cd build && cmake .. && make install


SHELL ["/bin/bash", "-c"]

RUN mkdir -p ~/catkin_ws/src \
    && cd ~/catkin_ws/src
    # 从圆圆姐主机上拷贝过来的lego-loam也可以直接用（到时候直接把修改后的项目传到slam-hive-algorithms的仓库里，从那里面拉去）
    # 轨迹评估没问题的话，就构造一个新的镜像 带上slamhive文件夹
    
    # lego的参数还挺多 但是没有写在配置文件中，需要修改utility代码
    # 参考orb的py文件和launch文件 
    # 先不改了 代码里写的const
    # && git clone https://github.com/Mitchell-Lee-93/kitti-lego-loam.git \
ENV CATKIN_WS=/root/catkin_ws
COPY kitti-lego-loam $CATKIN_WS/src/kitti-lego-loam
 
RUN cd ~/catkin_ws \
    && rosdep install --from-paths src --ignore-src -r -y \
    && source /opt/ros/kinetic/setup.bash \
    && catkin_make
    
# 先试一下git clone下来的
# COPY loam_velodyne /root/catkin_ws/src/loam_velodyne   

RUN echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc \
    && echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc

WORKDIR /root/catkin_ws

RUN apt-get update && apt-get install -y \
	python3-pip \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* 
RUN pip3 install pyyaml==6.0
RUN pip3 install rospkg
