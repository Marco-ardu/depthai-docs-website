ROS2 Foxy + depthai_ros教程
~~~~~~~~~~~~~~~~~~~~~~~~~

测试信息
#####################

=================== ============ ========== ============== ======
平台                 系统         ROS版本     depthai版本     设备
=================== ============ ========== ============== ======
PC端                 ubuntu20.04  Foxy        V2.16.0       OAK-D
=================== ============ ========== ============== ======

安装ROS2
#####################

设置语言环境
****************

确保您有一个支持UTF-8，如果您处于最小环境中（例如 docker 容器），则语言环境可能是最小的，例如POSIX。 我们使用以下设置进行测试。但是，如果您使用不同的 UTF-8 支持的语言环境，应该没问题。

.. code-block:: bash

    locale  # check for UTF-8

    sudo apt update && sudo apt install locales
    sudo locale-gen en_US en_US.UTF-8
    sudo update-locale LC_ALL=en_US.UTF--ro8 LANG=en_US.UTF-8
    export LANG=en_US.UTF-8

    locale  # verify settings

设置下载源
****************

您需要将 ROS 2 apt 存储库添加到您的系统。首先，通过检查此命令的输出确保启用了 `Ubuntu Universe 存储库 <https://help.ubuntu.com/community/Repositories/Ubuntu>`__。

.. code-block:: bash

    apt-cache policy | grep universe

这应该输出如下一行：

.. code-block:: bash

    500 http://us.archive.ubuntu.com/ubuntu focal/universe amd64 Packages
    release v=20.04,o=Ubuntu,a=focal,n=focal,l=Ubuntu,c=universe,b=amd64

如果您没有看到像上面那样的输出行，请使用这些说明启用 Universe 存储库。

.. code-block:: bash

    sudo apt install software-properties-common
    sudo add-apt-repository universe

现在将 ROS 2 apt 存储库添加到您的系统。

.. code-block:: bash

    sudo apt update && sudo apt install curl gnupg2 lsb-release
    sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg

然后将存储库添加到您的源列表。

.. code-block:: bash

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

设置存储库后更新您的 apt 存储库缓存。

.. code-block:: bash

    sudo apt update

ROS 2 软件包建立在经常更新的 Ubuntu 系统上。始终建议您在安装新软件包之前确保您的系统是最新的

.. code-block:: bash

    sudo apt upgrade -y 

安装ROS2 foxy
****************

桌面安装（推荐）：ROS、RViz、演示、教程。

.. code-block:: bash

    sudo apt install ros-foxy-desktop

如果您没有安装 rosdep 且未初始化，请执行以下步骤：

.. code-block:: bash

    sudo apt install python3-rosdep
    sudo rosdep init
    rosdep update

设置depthai_ros
#####################

安装depthai依赖
****************


更新 usb 规则。

.. code-block:: bash

    echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="03e7", MODE="0666"' | sudo tee /etc/udev/rules.d/80-movidius.rules
    sudo udevadm control --reload-rules && sudo udevadm trigger

depthai core安装包 `下载地址 <https://gitee.com/oakchina/depthai-core/releases/>`__

.. code-block:: bash

    sudo apt install ./depthai_2.16.0_amd64.deb

安装opencv colcon

.. code-block:: bash
    
    sudo apt install libopencv-dev python3-colcon-common-extensions -y

安装rviz-imu-plugin

.. code-block:: bash
    
    sudo apt install libopencv-dev ros-foxy-rviz-imu-plugin -y

设置程序
****************

以下设置过程假设您的 cmake 版本≥3.10.2 和 OpenCV 版本≥4.0.0。我们选择 dai_ws 作为新文件夹的名称，因为它将是我们的 depthai ros 工作区。

.. code-block:: bash

    mkdir -p dai_ws/src
    cd dai_ws/src
    git clone https://gitee.com/oakchina/depthai-ros.git
    cd ..
    source /opt/ros/foxy/setup.bash
    rosdep install --from-paths src --ignore-src -r -y
    colcon build 
    source install/setup.bash

执行示例
****************

.. code-block:: bash

    cd dai_ws
    source install/setup.bash
    ros2 launch depthai_examples stereo_inertial_node.launch.py

运行示例
*********

Mobilenet Publisher

OAK-D

.. code-block:: bash

    ros2 launch depthai_examples mobile_publisher.launch.py camera_model:=OAK-D
    
OAK-D-LITE

.. code-block:: bash

    ros2 launch depthai_examples mobile_publisher.launch.py camera_model:=OAK-D-LITE

.. include::  /pages/includes/footer-short.rst