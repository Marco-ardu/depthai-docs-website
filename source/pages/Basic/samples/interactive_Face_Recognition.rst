示例-人脸识别
===================================

此示例展示了第二代模型管道构建器的基本架构，将多个神经网络模型并行或串联组合在一起，ROI从一个网络传递到一个或多个后续的网络中。

此示例使用3个模型构建了一个管道，该管道能够检测视频上的面部，及其面部特征点，并使用提供的面部数据库识别人员。

演示
####

.. raw:: html

    <div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; height: auto;">
        <iframe src="//player.bilibili.com/player.html?aid=245833635&bvid=BV1jv411t7yv&cid=272765871&page=1" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
    </div>
    <br/>


示例源代码
##########

人脸识别示例的源代码在 GitHub 的
`代码仓库 <https://github.com/OAKChina/depthai-examples/tree/master/interactive_Face_Recognition>`_ 中,
国内用户可以在 Gitee 的
`代码仓库 <https://gitee.com/OAKChina/depthai-examples/tree/master/interactive_Face_Recognition>`_ 获得

请参考README运行程序.

代码原理说明
###################################

1. 从人脸库读取图片
***********************************

   |yangjunwen_1|

2. 运行模型
***********************************

   运行face-detection-retail-0004模型检测图像中的人脸，并截取面部图像。

   |Screenshot from 2020-12-24 13-59-26|

   运行landmarks-regression-retail-0009模型检测面部特征点
   
   |Screenshot from 2020-12-24 14-00-34|

   图像几何变换，使用cv2.warpffine函数将面部转正

   |Screenshot from 2020-12-25 08-51-38|
   
   如上图所示将面部倾斜的图像转正

   运行face-reidentification-retail-0095模型获取特征向量
   
   |Screenshot from 2020-12-24 14-10-20|

   将获取到的图片特征向量添加到列表中，以备后续与从板载相机获取的图像进行比较

   从板载相机获取图像并执行以上过程

3. 余弦计算
************************************

   余弦相似度计算公式

   |Screenshot from 2020-12-24 14-24-23|

   将人脸库中图片的特征向量和从相机获取的图像的特征向量进行余弦距离计算。余弦距离越近相似度越高，设置阈值进行判断

4. 最终效果
************************************

   |Screenshot from 2020-12-24 14-19-19|

.. |yangjunwen_1| image:: /_static/images/samples/image1.jpeg
   :width: 3.125in
   :height: 3.125in
.. |Screenshot from 2020-12-24 13-59-26| image:: /_static/images/samples/image2.png
   :width: 5.76597in
   :height: 3.16181in
.. |Screenshot from 2020-12-24 14-00-34| image:: /_static/images/samples/image3.png
   :width: 1.86458in
   :height: 2.46875in
.. |Screenshot from 2020-12-25 08-51-38| image:: /_static/images/samples/image4.png
   :width: 5.76458in
   :height: 2.27014in
.. |Screenshot from 2020-12-24 14-10-20| image:: /_static/images/samples/image5.png
   :width: 5.76528in
   :height: 3.15625in
.. |Screenshot from 2020-12-24 14-24-23| image:: /_static/images/samples/image6.png
   :width: 5.7625in
   :height: 1.72986in
.. |Screenshot from 2020-12-24 14-19-19| image:: /_static/images/samples/image7.png
   :width: 5.75972in
   :height: 3.24028in

.. include::  /pages/includes/footer-short.rst