在OAK上部署用户神经网络模型的方法
==============================
OAK相机可以运行 **几乎所有的人** 工智能模型， **包括用户自己创建和训练的神经网络模型** 。 **一个OAK芯片内部** 可以同时 **以并联或者串联的模式** 运行多个 **AI神经网络模型**
我们可以通过在线或者离线的转换工具，将自己训练好的神经网络模型转换成可以在OAK上加速运行的BLOB格式的神经网络模型。这里提供YOLO模型的三种转换方法，其他框架的模型方法类似，示意图如下：

.. image:: /_static/images/advanced/advanced_yolo.png

直接通过官方提供的yolo系列模型在线转换工具，将YOLO模型转换成OAK上运行的BLOB格式的模型：
************************************************************************************************************************

网址如下：https://tools.luxonis.com/

.. image:: /_static/images/advanced/advanced_yolo_tool.png

先将YOLO模型转换成ONNX，再通过在线转换工具将ONNX模型转换成BLOB格式的模型。该方法不仅仅适合YOLO，也适合TensorFlow、Caffe、Pytorch、OpenVino的转换。
******************************************************************************************************************************************************

第一步，将YOLO模型转换成ONNX模型
------------------------------------------------

参考代码和方法网址如下：https://www.oakchina.cn/2023/03/21/mmyolo-blob/

第二步：通过在线转换工具将ONNX模型转换成BLOB格式
------------------------------------------------

网址: http://blobconverter.luxonis.com/

采用完全离线的方式实现从yolo到BLOB的完整转换
**************************************************************

可以参考我们的本地转换教程：
https://docs.oakchina.cn/en/latest/pages/Advanced/Neural_networks/local_convert_openvino.html

第一步：自己搭建openvino环境
------------------------------------------------

第二步：将YOLO模型转换成ONNX模型
------------------------------------------------

参考代码和方法网址如下：https://www.oakchina.cn/2023/03/21/mmyolo-blob/

第三步：通过 OpenVino Model Optimizer 将第三方通用模型转换成openvino的模型格式.bin和.xml格式
------------------------------------------------------------------------------------------------

第四步：再通过 OpenVino Compile Tool 工具将.IR格式的Openvino模型转换成可以在OAK上运行的.blob格式的模型。
------------------------------------------------------------------------------------------------

当BLOB模型转换好后，我们将模型路径放在代码里，实现模型的调用运行，具体方法可以参考以下两个地方的代码：
https://docs-old.luxonis.com/projects/api/en/latest/samples/Yolo/tiny_yolo/
https://gitcode.net/oakchina/depthai-examples/-/tree/master/depthai_yolo

.. include::  /pages/includes/footer-long.rst