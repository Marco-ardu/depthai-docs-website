ROS1 noetic + depthai_ros教程
===================================

已测试平台
*************

====== =================== ============ ========== ============== ======
编号    平台                 系统         ROS版本    depthai版本     设备
====== =================== ============ ========== ============== ======
测试一  PC端                 ubuntu18.04  Melodic      V2.15.0      OAK-D
测试二  PC端                 ubuntu20.04  Noetic       V2.15.0      OAK-D
测试三  arch64 Jetson nano   ubuntu18.04  Melodic      V2.15.0      OAK-D
====== =================== ============ ========== ============== ======

目前X86和arch64平台测试安装包没有问题。

树莓派上安装ROS需要自己编译安装，时间比较长，需要测试的可以到 `官网 <https://wiki.ros.org/ROSberryPi/Installing%20ROS%20Melodic%20on%20the%20Raspberry%20Pi>`__ 查看，替换下面安装ROS步骤就可以了。

ubuntu20.04推荐安装noetic版本的ROS，ubuntu18.04推荐安装melodic版本。

安装依赖
**********

更新 usb 规则。

.. code-block:: bash

    echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="03e7", MODE="0666"' | sudo tee /etc/udev/rules.d/80-movidius.rules
    sudo udevadm control --reload-rules && sudo udevadm trigger

depthai core安装包 `下载地址 <https://gitee.com/oakchina/depthai-core/releases/>`__

.. code-block:: bash

    sudo apt install ./depthai_2.15.0_x86_64_Shared.deb

如果您没有安装 opencv，请尝试:

.. note:: 

    Jetson平台不需要安装opencv,系统自带

.. code-block:: bash

    sudo apt install libopencv-dev

如果您未安装rosdep且未初始化，请执行以下步骤:(这里安装的是melotic版本，如果想要安装ROS的其他版本，前往官网下载)。

.. code-block:: bash

    sudo apt update
    sudo apt upgrade
    # 设置sources.list
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    # 如果下载速度较慢，使用以下命令替换上面的命令
    sudo sh -c '. /etc/lsb-release && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list'
    # 如果依然遇到连接失败问题，请尝试换源https://developer.aliyun.com/mirror/ubuntu
    # 设置密钥
    sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
    # 若无法连接到密钥服务器，可以尝试替换上面命令中的 hkp://keyserver.ubuntu.com:80 为 hkp://pgp.mit.edu:80 。
    sudo apt update
    sudo apt install ros-noetic-desktop
    sudo apt install python3-rosdep
    sudo rosdep init
    rosdep update
    # 设置环境
    echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
    source ~/.bashrc

安装rviz-imu-plugin

.. code-block:: bash
    
    sudo apt install libopencv-dev ros-foxy-rviz-imu-plugin -y

设置程序

********

.. code-block:: bash

    mkdir -p dai_ws/src
    cd dai_ws/src
    git clone https://gitee.com/oakchina/depthai-ros.git
    cd ..
    source /opt/ros/noetic/setup.bash
    rosdep install --from-paths src --ignore-src -r -y
    catkin_make
    source devel/setup.bash

执行示例
*********

.. code-block:: bash

    cd dai_ws
    source devel/setup.bash
    roslaunch depthai_examples stereo_inertial_node.launch

运行示例
*********

Mobilenet Publisher

OAK-D

.. code-block:: bash

    roslaunch depthai_examples mobile_publisher.launch camera_model:=OAK-D

OAK-D-LITE

.. code-block:: bash

    roslaunch depthai_examples mobile_publisher.launch camera_model:=OAK-D-LITE
带可视化器

.. code-block:: bash

    roslaunch depthai_examples mobile_publisher.launch | rqt_image_view -t /mobilenet_publisher/color/image

测试结果
*********

* ImageConverter - 使用 ``roslaunch depthai_examples stereo_inertial_node.launch`` && ``roslaunch depthai_examples rgb_publisher.launch`` 测试
* ImgDetectionCnverter - 测试使用 ``roslaunch depthai_examples mobile_publisher.launch``
* SpatialImgDetectionConverter - 测试使用 ``roslaunch depthai_examples stereo_inertial_node.launch``

.. include::  /pages/includes/footer-short.rst