ROS1 noetic + depthai_ros教程
===================================

演示
*******

.. raw:: html

    <div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; height: auto;">
        <iframe src="//player.bilibili.com/player.html?aid=724415127&bvid=BV1hS4y167TK&cid=540722781&page=1" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
    </div>
    <br/>

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

安装vcstool 

.. code-block:: bash

    sudo apt install python3-vcstool

设置程序
********

.. code-block:: bash

    mkdir -p dai_ws/src
    cd dai_ws
    wget  https://raw.githubusercontent.com/luxonis/depthai-ros/main/underlay.repos
    vcs import src < underlay.repos
    rosdep install --from-paths src --ignore-src -r -y
    source /opt/ros/noetic/setup.bash
    catkin_make
    source devel/setup.bash

执行示例
*********

.. code-block:: bash

    cd dai_ws
    source devel/setup.bash
    roslaunch depthai_examples stereo_node.launch

常见问题及解决方案
******************

1. 执行catkin_make出现的错误1

.. image:: /_static/images/catkin_make_error1.png

请参考 `此处 <https://github.com/ros-perception/vision_opencv/issues/389#issuecomment-841312500>`__ 的解决方案。

2. 执行catkin_make出现的错误2

.. code-block:: bash

    /usr/bin/ld: /usr/lib/x86_64-linux-gnu/libopencv_imgcodecs.so.4.2.0: undefined reference to `TIFFSetErrorHandler@LIBTIFF_4.0'
    /usr/bin/ld: /lib/libgdal.so.26: undefined reference to `TIFFSetDirectory@LIBTIFF_4.0'
    /usr/bin/ld: /lib/libgdal.so.26: undefined reference to `TIFFReadScanline@LIBTIFF_4.0'
    /usr/bin/ld: /lib/libgdal.so.26: undefined reference to `TIFFNumberOfTiles@LIBTIFF_4.0'
    /usr/bin/ld: /usr/lib/x86_64-linux-gnu/libopencv_imgcodecs.so.4.2.0: undefined reference to `TIFFReadRGBAStrip@LIBTIFF_4.0'
    collect2: error: ld returned 1 exit status
    make[2]: *** [luxonis/depthai-ros-examples/depthai_examples/CMakeFiles/rgb_node.dir/build.make:181：/home/xiaotang/depthai_build/devel/lib/depthai_examples/rgb_node] 错误 1
    make[1]: *** [CMakeFiles/Makefile2:2382：luxonis/depthai-ros-examples/depthai_examples/CMakeFiles/rgb_node.dir/all] 错误 2

遇到上面问题，检查是否把conda环境取消。

3. 执行catkin_make出现的错误3

ModuleNotFoundError: No module named 'pkg_resources'

.. code-block:: bash

    	sudo apt install --reinstall python3-pkg-resources python3-setuptools



.. include::  /pages/includes/footer-short.rst