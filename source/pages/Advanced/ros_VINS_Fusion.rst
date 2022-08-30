ubuntu 18.04 OAK-D系列相机 运行VINS-Fusion 双目+IMU
==================

参考：https://github.com/HKUST-Aerial-Robotics/VINS-Fusion

准备
----------

.. note::

    依赖包括ROS、depthai_ros、Ceres Solver，在下面的标定教程中

相机标定参数，参考 :ref:`标定教程 <ubuntu 18.04 OAK-D kalibr 双目+imu联合标定>`

三个配置文件，按照标定参数填写，填写时注意注释

三个文件放到同级目录下，可以新建目录OAK-D放到dai_ws/src/VINS-Fusion/config

config.yaml

.. code-block:: yaml

    %YAML:1.0

    #common parameters
    #support: 1 imu 1 cam; 1 imu 2 cam: 2 cam; 
    imu: 1         
    num_of_cam: 2  

    imu_topic: "/stereo_inertial_publisher/imu"
    image0_topic: "/stereo_inertial_publisher/left/image_rect"
    image1_topic: "/stereo_inertial_publisher/right/image_rect"

    cam0_calib: "left.yaml"
    cam1_calib: "right.yaml"
    image_width: 640
    image_height: 400
    

    # Extrinsic parameter between IMU and Camera.
    estimate_extrinsic: 1   # 0  Have an accurate extrinsic parameters. We will trust the following imu^R_cam, imu^T_cam, don't change it.
                            # 1  Have an initial guess about extrinsic parameters. We will optimize around your initial guess.

    body_T_cam0: !!opencv-matrix # Inverse of Kalibr result, (transpose for rotation matrix, T'=-R'T)
    rows: 4
    cols: 4
    dt: d
    data: [ 0.00128876,  0.99999914, -0.00023326,  -0.00323207,
            0.99999859,  -0.00128851, 0.00107949, -0.06857642,
            0.00107919, -0.00023466, -0.99999939, -0.00014712,
            0, 0, 0, 1]

    #T_cn_cnm1: #T_c1_c0 : c0's points from c1's view 

    body_T_cam1: !!opencv-matrix
    rows: 4
    cols: 4
    dt: d
    data: [ 0.00138612,   0.99999838, 0.00115110, -0.00301687,
            0.99998778,  -0.00139157, 0.00474275,  0.00675044,
            0.00474435, 0.00114451, -0.99998809, -0.00109913,
            0, 0, 0, 1]

    #Multiple thread support
    multiple_thread: 1

    #feature traker paprameters
    max_cnt: 130            # max feature number in feature tracking
    min_dist: 30            # min distance between two features 
    freq: 0                 # frequence (Hz) of publish tracking result. At least 10Hz for good estimation. If set 0, the frequence will be same as raw image 
    F_threshold: 1.0        # ransac threshold (pixel)
    show_track: 1           # publish tracking image as topic
    flow_back: 1            # perform forward and backward optical flow to improve feature tracking accuracy

    #optimization parameters
    max_solver_time: 0.04  # max solver itration time (ms), to guarantee real time
    max_num_iterations: 8   # max solver itrations, to guarantee real time
    keyframe_parallax: 10.0 # keyframe selection threshold (pixel)

    #imu parameters       The more accurate parameters you provide, the better performance
    acc_n: 0.1          # accelerometer measurement noise standard deviation. 
    gyr_n: 0.01         # gyroscope measurement noise standard deviation.     
    acc_w: 0.001        # accelerometer bias random work noise standard deviation.  
    gyr_w: 0.0001       # gyroscope bias random work noise standard deviation.     
    g_norm: 9.81007     # gravity magnitude

    #unsynchronization parameters
    estimate_td: 1                      # online estimate time offset between camera and imu
    td: 0.0                         # initial value of time offset. unit: s. readed image clock + td = real image clock (IMU clock)

    #loop closure parameters
    load_previous_pose_graph: 0        # load and reuse previous pose graph; load from 'pose_graph_save_path'
    pose_graph_save_path: "~/output/pose_graph/" # save and load path
    save_image: 1                   # save image in pose graph for visualization prupose; you can close this function by setting 0 

left.yaml

.. code-block:: yaml

    %YAML:1.0
    ---
    model_type: PINHOLE
    camera_name: camera
    image_width: 640
    image_height: 400
    distortion_parameters:
    k1: 0.011099142353676499
    k2: -0.05769482092275897
    p1: -0.0009757653113701839
    p2: 0.0025548857914714745
    projection_parameters:
    fx: 401.8064
    fy: 400.5184
    cx: 323.9370
    cy: 193.8434

right.yaml

.. code-block:: yaml

    %YAML:1.0
    ---
    model_type: PINHOLE
    camera_name: camera
    image_width: 640
    image_height: 400
    distortion_parameters:
    k1: 0.005536021298200547
    k2: -0.048229113205249675
    p1: -0.0002985290327403832
    p2: 0.0037187807087799125
    projection_parameters:
    fx: 401.9601
    fy: 399.9079
    cx: 325.5761
    cy: 194.2576

构建VINS-Fusion
----------

.. code-block:: bash

    cd ~/dai_ws/src
    git clone https://github.com/HKUST-Aerial-Robotics/VINS-Fusion.git
    cd ..
    catkin_make
    source ~/dai_ws/devel/setup.bash

.. note::

    如果此步骤失败，请尝试寻找另一台系统干净的计算机或重新安装 Ubuntu 和 ROS

运行示例
----------

这里演示的是双目+imu，其他示例参考教程开头的github原作者教程

分别打开一个终端运行每一行命令，注意环境要激活

.. code-block:: bash

    roslaunch depthai_examples stereo_inertial_node.launch enableRviz:=false depth_aligned:=false
    roslaunch vins vins_rviz.launch
    rosrun vins vins_node ～/dai_ws/src/VINS-Fusion/config/oak_d_s2/config.yaml
    (optional) rosrun loop_fusion loop_fusion_node ～/dai_ws/src/VINS-Fusion/config/oak_d_s2/config.yaml

.. image:: /_static/images/ros_oak_d_kalibr/vins_fusion_res.png

.. include::  /pages/includes/footer-short.rst