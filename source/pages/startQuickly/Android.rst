Android开发应用
===================

.. note::

    硬件连接参考： :ref:`硬件连接注意事项 <硬件系列产品入门教程>`

Android应用示例
###################

在次项目 `链接 <https://github.com/onuralpszr/DepthAiAndroidToolbox.git>`__ 可以查看相关应用

此 Android 应用程序利用 OAK-D 相机和 OpenCV 库执行 YOLOv5 对象检测和深度检测。OAK-D 相机提供具有高级深度感应功能的高质量图像和视频，而 OpenCV 是一个广泛使用的计算机视觉库，提供各种图像处理和分析工具。

通过此应用程序，用户可以利用 OAK-D 相机的高级功能实时检测和跟踪物体。YOLOv5 模型用于对象检测，这是一种最先进的深度学习模型，可以高精度地识别范围广泛的对象。深度检测功能使用户能够获得有关场景中物体之间距离的信息，这对于机器人、自动驾驶和增强现实等各种应用非常有用。

该项目需要 OpenCV 4.7.0（和其他 4.xy 版本），适用于Android Studio中的 Android ，支持原生开发工具包 (NDK)。 Android NDK使您能够在 C++ 中实现OpenCV图像处理管道，并通过 JNI（ Java 本机接口）从 Android Kotlin/Java 代码调用该 C++ 代码。



.. include::  /pages/includes/footer-short.rst