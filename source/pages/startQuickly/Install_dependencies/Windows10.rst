windows
==========================

Windows 10/11
----------

我们准备了windows平台下的python开发环境，以及depthai示例。

并且python环境中已为您安装好了运行depthai示例所需的依赖。做到开箱即用。

.. raw:: html

    <div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; height: auto;">
        <iframe src="//player.bilibili.com/player.html?aid=393549168&bvid=BV1Ud4y1H74i&cid=985040729&page=1" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"> </iframe>
    </div>
    <br/>


下载安装程序
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**sourceforge**: 

    =======  ==========================================
    平台      链接                                                  
    =======  ==========================================
    Windows  https://sourceforge.net/projects/depthai/ 
    =======  ==========================================


.. note:: 

    这个安装包的depthai版本版本号是2.22.0.0，更新时间2023-06-30。部分示例可能会在gitee上不定期更新，最新示例请在 `此处 <https://gitee.com/oakchina/depthai-experiments>`_ 查看。
    手动升级depthai使用以下命令

    .. code-block:: bash

        cd /d %DEPTHAI_HOME%
        .\python\python.exe -m pip install -U depthai

安装包内容
^^^^^^^^^^^^^^^^^^^^

=====================  ===============================================
文件夹目录               内容
=====================  ===============================================
depthai                 depthai_demo以及校准程序
depthai_API_examples    API相关示例
depthai-experiments     一些实验性模型示例
=====================  ===============================================

安装
^^^^^^^^^^^

安装程序下载好后，双击安装。

.. image:: /_static/images/GetStartedQuickly/OAKEnvironmentalSetup.png

选择安装目录

.. image:: /_static/images/GetStartedQuickly/selectDir.png

选择菜单目录

.. image:: /_static/images/GetStartedQuickly/meunDir.png

选择是否添加环境变量

.. image:: /_static/images/GetStartedQuickly/inputPath.png

开始安装

.. image:: /_static/images/GetStartedQuickly/install.png

安装成功

.. image:: /_static/images/GetStartedQuickly/success.png

运行depthai_demo
^^^^^^^^^^^

.. note:: 

    GUI界面的参数说明请 `查看 <https://www.oakchina.cn/2022/12/15/depthai_first_steps/#i-2>`__

在确认使用USB3.0连接设备后双击桌面的OAK USB3.0 Demo即可运行depthai_demo。

.. image:: /_static/images/GetStartedQuickly/oak_demo.png

.. image:: /_static/images/GetStartedQuickly/depthaiDemoShow.png

命令行运行depthai_demo:

.. code-block:: bash

    cd /d %DEPTHAI_HOME%
    .\python\python.exe .\depthai\depthai_demo.py --skipVersionCheck

.. image:: /_static/images/GetStartedQuickly/depthaiDemoCmdShow.png

.. warning::

    **如果系统用户名是中文** 并出现下图错误：

    .. image:: /_static/images/GetStartedQuickly/modeError.png

    您可以在depthai-demo.py文件中添加以下代码：

    .. code-block:: python

        import blobconverter

        blobconverter.set_defaults(output_dir="<指定模型文件下载路径>")

    如果下载太慢，您可以将用户目录下的.cache文件夹中blobconverter文件夹复制到上面代码中所指定的文件夹中。


运行API示例
^^^^^^^^^^^

.. code-block:: bash
    
    cd /d %DEPTHAI_HOME%
    .\python\python.exe .\depthai_API_examples\ColorCamera\rgb_preview.py

运行depthai-experiments示例
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash
    
    cd /d %DEPTHAI_HOME%
    .\python\python.exe depthai-experiments/gen2-age-gender/main.py

运行校准程序
^^^^^^^^^^^

在DEPTHAI_HOME中，我们还准备了为OAK-D校准的bat程序。

.. image:: /_static/images/GetStartedQuickly/calibrate_bat.png

如果您想要校准其他OAK设备，可以修改depthai_calibrate.bat文件

用于校准的json文件在depthai目录下的resources/boards/，棋盘格大小单位是cm

.. image:: /_static/images/GetStartedQuickly/modify_bat.png

也可以在命令行运行校准程序。

.. code-block:: bash

    cd /d %DEPTHAI_HOME%
    .\python\python.exe .\depthai\calibrate.py -s 2.5 -db -brd BW1098OBC --skipVersionCheck

device_manager.exe
^^^^^^^^^^^^^^^^^^^^^^

在2.19.0版本之后，我们把device_manager.py打包成了exe程序，在 **depthai_API_examples** 目录下，可以直接点击运行

.. image:: /_static/images/GetStartedQuickly/device_manager_show.png

Windows 7
----------

尽管我们不正式支持Windows 7, 但是我们的社区成员 `已经成功 <https://discuss.luxonis.com/d/105-run-on-win7-sp1-x64-manual-instal-usb-driver>`__ 使用 `Zadig
<https://zadig.akeo.ie/>`__ 手动安装WinUSB . 连接DepthAI设备后，寻找具有 :code:`USB ID:03E7 2485` 的设备并选择WinUSB（v6.1.7600.16385）安装WinUSB驱动程序，然后安装WCID驱动程序。
