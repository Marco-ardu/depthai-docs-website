镜像加速
=======================

pypi 镜像使用帮助
#######################

临时使用
**********************

.. code:: bash

    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple some-package 

注意，\ ``simple`` 不能少, 是 ``https`` 而不是 ``http``

设为默认
***********

-  使用命令行

升级 pip 到最新的版本 (>=10.0.0) 后进行配置：

.. code:: bash

    pip install pip -U   
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

如果您的pip默认源的网络连接较差，临时使用镜像站来升级pip：

.. code:: bash

    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U

-  文本编辑

Pip 的配置文件为用户根目录下的：\ ``~/.pip/pip.conf``\ （Windows
路径为：\ ``C:\Users\<UserName>\pip\pip.ini``\ ）, 您可以配置如下内容：

.. code:: text
    
    [global]   
    index-url = https://pypi.tuna.tsinghua.edu.cn/simple   
    trusted-host = pypi.tuna.tsinghua.edu.cn   
    timeout = 120


.. include::  /pages/includes/footer-short.rst