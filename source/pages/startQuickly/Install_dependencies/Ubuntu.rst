Ubuntu
======================

.. raw:: html

    <div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; height: auto;">
        <iframe src="//player.bilibili.com/player.html?aid=421575163&bvid=BV1sG41187or&cid=438680227&page=1" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"> </iframe>
    </div>
    <br/>

启用 USB 设备
#######################################

由于OAK是USB设备，因此为了在使用 :code:`udev` 工具的系统上与之通信， 
您需要添加udev规则以使设备可访问。

以下命令将向您的系统添加新的udev规则

.. warning::
    提示：
        第一次使用一定要配置此规则！

.. code-block:: bash

  echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="03e7", MODE="0666"' | sudo tee /etc/udev/rules.d/80-movidius.rules
  sudo udevadm control --reload-rules && sudo udevadm trigger

- 拉取项目

.. code-block:: bash

    git clone https://gitee.com/oakchina/depthai.git
    
- 安装依赖

.. code-block:: bash

    cd depthai
    python3 install_requirements.py

如果安装依赖遇到网络问题可以查看此处换成 :ref:`国内镜像源 <镜像加速>` 

- 运行Demo

.. code-block:: bash

    python3 depthai-demo.py

**注意!** 如果从 PyPi 安装后 opencv 失败并显示非法指令，请添加：

.. code-block:: bash

  echo "export OPENBLAS_CORETYPE=ARMV8" >> ~/.bashrc
  source ~/.bashrc
