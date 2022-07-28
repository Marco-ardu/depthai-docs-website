Linux
======================

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


Linux平台我们建议使用git直接拉取depthai仓库。

- depthai

.. code-block:: bash

    git clone https://gitee.com/oakchina/depthai.git
    
- depthai-python

.. code-block:: bash

    git clone https://gitee.com/oakchina/depthai-python.git

- depthai-experiments

.. code-block:: bash

    git clone https://gitee.com/oakchina/depthai-experiments.git

.. warning::

    在Linux平台并且第一次使用OAK需要配置udev规则 - :ref:`详情 <启用 USB 设备（仅在 Linux 上）>`

安装依赖:

.. code-block:: python

    python3 -m pip install -r depthai/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

执行以下命令:

.. code-block:: python

    python3 depthai/depthai_demo.py

效果如下:

.. image:: /_static/images/GetStartedQuickly/linux_show.png
    :alt: show