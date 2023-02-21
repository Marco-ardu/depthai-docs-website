ubuntu 18.04 OAK-D kalibr 双目+imu联合标定
============

准备
----------

* 环境干净的ubuntu18.04系统
* OAK-D + USB3.0数据线 (或者是其他支持双目+imu的OAK相机)
* 打印标定板(这里使用的是Aprilgrid)， `下载地址 <https://www.oakchina.cn/wp-content/uploads/2022/08/april_6x6_80x80cm_A0.pdf>`__
* 标定板配置文件，根据实际打印大小填写到april_6x6.yaml

.. code-block:: yaml

    #example for aprilgrid
    target_type: 'aprilgrid' #gridtype
    tagCols: 6                  #number of apriltags
    tagRows: 6                  #number of apriltags
    tagSize: 0.022              #size of apriltag, edge to edge [m]
    tagSpacing: 0.3             #ratio of space between tags to tagSize
                                #example: tagSize=2m, spacing=0.5m --> tagSpacing=0.25[-]
    #example for checkerboard
    #  targetType: 'checkerboard' #gridtype
    #  targetCols: 6              #number of internal chessboard corners
    #  targetRows: 7              #number of internal chessboard corners
    #  rowsMetricSize: 0.06       #size of one chessboard square [m]
    #  colsMetricSize: 0.06       #size of one chessboard square [m]
    
安装相关程序
----------

ROS以及depthai_ros环境
^^^^^^^^^^^

ROS melodic + depthai_ros :ref:`教程链接 <ROS1 noetic + depthai_ros教程>` 注意替换ROS版本号

安装标定工具以及依赖
^^^^^^^^^^^

编译kalibr
""""""""""""

.. code-block:: bash

    sudo apt install libsuitesparse-dev
    sudo apt install libv4l-dev

`源码地址 <https://github.com/ethz-asl/kalibr.git>`__ ，克隆源码到src目录下，然后在kalibr_ws工作目录下使用catkin_make命令编译

.. image:: /_static/images/ros_oak_d_kalibr/kalibr.png

以下是标定时需要的依赖

.. code-block:: bash

    sudo apt-get install python-igraph
    python -m pip install scipy

安装Ceres Solver
""""""""""""

按照 `官方教程 <http://ceres-solver.org/installation.html>`__ 安装Ceres Solver

编译code_utils
""""""""""""

.. code-block:: bash

    sudo apt install libdw-dev

`源码地址 <https://github.com/gaowenliang/code_utils>`__ ,克隆源码到src目录下

在code_utils下面找到sumpixel_test.cpp，修改#include "backward.hpp"为 #include “code_utils/backward.hpp”，然后在kalibr_ws工作目录下使用catkin_make命令编译

.. image:: /_static/images/ros_oak_d_kalibr/code_utils.png

编译imu_utils
""""""""""""

`源码地址 <https://github.com/gaowenliang/imu_utils>`__ ，克隆源码到src目录下，然后在kalibr_ws工作目录下使用catkin_make命令编译

.. image:: /_static/images/ros_oak_d_kalibr/imu_utils.png

标定过程
----------

采集数据
^^^^^^^^^^^

启动depthai_examples stereo_inertial_node.launch，这里设置的图像输出帧率是4帧，这样可以让计算量小一点

.. code-block:: bash

    cd dai_ws
    source devel/setup.bash
    roslaunch depthai_examples stereo_inertial_node.launch enableRviz:=false depth_aligned:=false stereo_fps:=4

.. code-block:: bash

    rostopic list

.. image:: /_static/images/ros_oak_d_kalibr/rostopic_list.png

使用到以上图中画框的话题

双目
""""""""""""

.. note::

    录制双目数据要在白色背景下录制，之后的双目+imu也是

具体录制方法参考 `视频 <https://www.bilibili.com/video/BV1it4y147Hq>`__

.. code-block:: bash

    rosbag record /stereo_inertial_publisher/left/image_rect /stereo_inertial_publisher/right/image_rect -O stereo.bag

imu
""""""""""""

.. note::

    录制imu数据时相机静止，时间要大于2个小时

.. code-block:: bash

    rosbag record /stereo_inertial_publisher/imu -O imu.bag

双目+imu
""""""""""""

具体录制方法参考 `视频 <https://www.bilibili.com/video/BV1it4y147Hq>`__

.. code-block:: bash

    rosbag record /stereo_inertial_publisher/imu /stereo_inertial_publisher/left/image_rect /stereo_inertial_publisher/right/image_rect -O stereo_imu.bag

标定
^^^^^^^^^^^

双目
""""""""""""

.. note::

    注意配置文件路径

.. code-block:: bash

    cd kalibr_ws
    source devel/setup.bash
    rosrun kalibr kalibr_calibrate_cameras --bag ../stereo.bag --topics /stereo_inertial_publisher/left/image_rect /stereo_inertial_publisher/right/image_rect --models pinhole-radtan pinhole-radtan --target ../OAK_D/april_6x6.yaml 

标定成功，目前可以把重投影误差控制在0.5以内

.. image:: /_static/images/ros_oak_d_kalibr/kalibr_oak_d__stereo_resjpg.jpg

输出cam_chain.yaml

.. code-block:: yaml

    cam0:
    cam_overlaps: [1]
    camera_model: pinhole
    distortion_coeffs: [0.029163490534580016, -0.08332352456606604, -0.001703975799425871, 0.006992997733791862]
    distortion_model: radtan
    intrinsics: [814.3568321116179, 815.0894236334714, 683.8491150709657, 340.5856601059704]
    resolution: [1280, 720]
    rostopic: /stereo_inertial_publisher/left/image_rect
    cam1:
    T_cn_cnm1:
    - [0.999984764432588, 0.0029265301147959008, 0.004680419231117285, -0.07535219882179961]
    - [-0.002904105777816229, 0.9999843073810051, -0.004790737036519648, 0.00019253365167533625]
    - [-0.00469436601929102, 0.004777071614390909, 0.9999775710056993, -0.0005437262712103053]
    - [0.0, 0.0, 0.0, 1.0]
    cam_overlaps: [0]
    camera_model: pinhole
    distortion_coeffs: [0.013208623179345822, -0.03975319079350225, -0.000241290621102109, 0.008441954380996652]
    distortion_model: radtan
    intrinsics: [822.7870689725859, 820.5717606544596, 680.346373177241, 343.830359521292]
    resolution: [1280, 720]
    rostopic: /stereo_inertial_publisher/right/image_rect

imu
""""""""""""

oak_d.launch文件内容，放在imu_utils/launch目录下

.. code-block:: launch

    <launch>
        <node pkg="imu_utils" type="imu_an" name="imu_an" output="screen">
            <param name="imu_topic" type="string" value= "/stereo_inertial_publisher/imu"/>
            <param name="imu_name" type="string" value= "ZR300"/>
            <param name="data_save_path" type="string" value= "$(find imu_utils)/data/"/>
            <param name="max_time_min" type="int" value= "80"/>
            <param name="max_cluster" type="int" value= "100"/>
        </node>
    </launch>

播放录制的imu数据，200倍速播放

.. code-block:: bash

    roscore
    rosbag play -r 200　imu_utils/imu.bag

启动oak_d.launch

.. code-block:: bash

    cd kalibr_ws
    source devel/setup.bash
    roslaunch imu_utils oak_d.launch

输出imu_param.yaml

.. code-block:: yaml

    %YAML:1.0
    ---
    type: IMU
    name: oak-d
    Gyr:
    unit: " rad/s"
    avg-axis:
        gyr_n: 5.1659466110355748e-03
        gyr_w: 2.3398926139856830e-05
    x-axis:
        gyr_n: 5.9992047089125330e-03
        gyr_w: 3.1741702735079302e-05
    y-axis:
        gyr_n: 4.2744238338741254e-03
        gyr_w: 1.5610981890151188e-05
    z-axis:
        gyr_n: 5.2242112903200643e-03
        gyr_w: 2.2844093794339994e-05
    Acc:
    unit: " m/s^2"
    avg-axis:
        acc_n: 2.5112339801819636e-02
        acc_w: 5.4434330052722689e-04
    x-axis:
        acc_n: 2.3967193951432327e-02
        acc_w: 7.3928376091566368e-04
    y-axis:
        acc_n: 2.2637396692944962e-02
        acc_w: 2.7146510845110392e-04
    z-axis:
        acc_n: 2.8732428761081619e-02
        acc_w: 6.2228103221491327e-04

双目+imu
""""""""""""

需要三个文件：双目+imu的采集数据、根据生成的imu标定结果填写的imu.yaml、双目标定结果

imu.yaml

.. code-block:: yaml

    #Accelerometers
    accelerometer_noise_density: 2.52e-02   #Noise density (continuous-time)
    accelerometer_random_walk:   5.44e-04   #Bias random walk

    #Gyroscopes
    gyroscope_noise_density:     5.16e-03   #Noise density (continuous-time)
    gyroscope_random_walk:       2.34e-05   #Bias random walk

    rostopic:                    /stereo_inertial_publisher/imu   #the IMU ROS topic
    update_rate:                 200.0      #Hz (for discretization of the values above)

.. code-block:: bash

    rosrun kalibr kalibr_calibrate_imu_camera --target april_6x6.yaml --cam stereo_camchain.yaml --imu imu.yaml --bag stereo_imu_oak_d.bag 

生成如下结果

.. image:: /_static/images/ros_oak_d_kalibr/oak_d_stereo_imu_kalibr.png

camchain-imucam.yaml

.. code-block:: yaml

    cam0:
        T_cam_imu:
        - [0.0012741143007174438, -0.999877856617157, -0.015577178159958124, 0.05611936652731515]
        - [0.9997404060564851, 0.00162798902986383, -0.022725979620935255, 0.00285232424992767]
        - [0.0227485632680666, -0.01554417892321791, 0.9996203686254297, 0.007183919123961078]
        - [0.0, 0.0, 0.0, 1.0]
        cam_overlaps: [1]
        camera_model: pinhole
        distortion_coeffs: [0.042268429058025504, -0.08677899665541859, 0.001180600575988654, 0.0022839809291763198]
        distortion_model: radtan
        intrinsics: [833.53142215564, 833.6574846171179, 664.9153795944901, 354.05210186777356]
        resolution: [1280, 720]
        rostopic: /stereo_inertial_publisher/left/image_rect
        timeshift_cam_imu: 0.0008209265944781894
    cam1:
        T_cam_imu:
        - [0.003900423265967401, -0.9999238322965412, -0.011709667106495082, -0.017964937584165064]
        - [0.9996593071739112, 0.0042010652101436285, -0.0257608352286262, 0.002875608017511033]
        - [0.025808066160071114, -0.01160519954583952, 0.9995995513527299, 0.011372828202903269]
        - [0.0, 0.0, 0.0, 1.0]
        T_cn_cnm1:
        - [0.999989071372855, 0.002537659366062306, 0.003926502234769603, -0.07411913670569026]
        - [-0.002525590738806025, 0.9999920811766924, -0.003075544720875524, 0.00018713537154106094]
        - [-0.003934275826358857, 0.0030655943717139626, 0.9999875617250811, 0.004401043432455365]
        - [0.0, 0.0, 0.0, 1.0]
        cam_overlaps: [0]
        camera_model: pinhole
        distortion_coeffs: [0.047927948017714446, -0.08886896066637022, 0.001194906027010198, 0.004430080060758361]
        distortion_model: radtan
        intrinsics: [846.0352688270785, 845.0776741744443, 659.390274553411, 356.3040770945268]
        resolution: [1280, 720]
        rostopic: /stereo_inertial_publisher/right/image_rect
        timeshift_cam_imu: 0.0008178786423846188

.. include::  /pages/includes/footer-short.rst