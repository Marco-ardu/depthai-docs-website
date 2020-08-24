---
layout: default
title: 示例 - 黑白相机自拍器 - 在两个黑白相机画面里看到你的脸，并按空格键保存。
toc_title: 黑白相机自拍器
description: 本示例演示了如何根据神经网络的输出结果裁切黑白相机的画面，并把拼接的照片保存到硬盘。
order: 3
---
# {{ page.title }}

This sample requires [TK library](https://docs.oracle.com/cd/E88353_01/html/E37842/libtk-3.html) to run (for opening file dialog)

It also requires face detection model, see [this tutorial](/tutorials/converting_openvino_model) to see how to compile one

__Stereo camera pair is required__ to run this example, it can either be [RPi Compute](products/bw1097/), [OAK-D](products/bw1098obc/) or any custom setup using [these cameras](/products/stereo_camera_pair/)

## Demo

__Capturing process__

<video muted autoplay controls>
    <source src="/images/samples/face_mono.mp4" type="video/mp4">
</video>

__Captured image__

![captured](/images/samples/face_mono_selfie.png)

## Source code

```python
import cv2
import depthai
import consts.resource_paths

if not depthai.init_device(consts.resource_paths.device_cmd_fpath):
    raise RuntimeError("Error initializing device. Try to reset it.")

pipeline = depthai.create_pipeline(config={
    'streams': ['left', 'right', 'metaout'],
    'ai': {
        "blob_file": "/path/to/face-detection-retail-0004.blob",
        "blob_file_config": "/path/to/face-detection-retail-0004.json",
    },
    'camera': {'mono': {'resolution_h': 720, 'fps': 30}},
})

if pipeline is None:
    raise RuntimeError('Pipeline creation failed!')

entries_prev = []
face_frame_left = None
face_frame_right = None

while True:
    nnet_packets, data_packets = pipeline.get_available_nnet_and_data_packets()

    for nnet_packet in nnet_packets:
        entries_prev = []
        for e in nnet_packet.entries():
            if e[0]['id'] == -1.0 or e[0]['confidence'] == 0.0:
                break
            if e[0]['confidence'] > 0.5:
                entries_prev.append(e[0])

    for packet in data_packets:
        if packet.stream_name == 'left' or packet.stream_name == 'right':
            frame = packet.getData()

            img_h = frame.shape[0]
            img_w = frame.shape[1]

            for i, e in enumerate(entries_prev):
                left = int(e['left'] * img_w)
                top = int(e['top'] * img_h)
                right = int(e['right'] * img_w)
                bottom = int(e['bottom'] * img_h)

                face_frame = frame[top:bottom, left:right]
                if face_frame.size == 0:
                    continue
                cv2.imshow(f'face-{packet.stream_name}', face_frame)
                if packet.stream_name == 'left':
                    face_frame_left = face_frame
                else:
                    face_frame_right = face_frame

    key = cv2.waitKey(1)
    if key == ord('q'):
        break
    if key == ord(' ') and face_frame_left is not None and face_frame_right is not None:
        from tkinter import Tk, messagebox
        from tkinter.filedialog import asksaveasfilename
        Tk().withdraw()
        filename = asksaveasfilename(defaultextension=".png", filetypes=(("Image files", "*.png"),("All Files", "*.*")))
        joined_frame = cv2.hconcat([face_frame_left, face_frame_right])
        cv2.imwrite(filename, joined_frame)
        messagebox.showinfo("Success", "Image saved successfully!")
        Tk().destroy()

del pipeline
```

## Explanation
<div class="alert alert-primary" role="alert">
<i class="material-icons info">
contact_support
</i>
  <strong>New to the DepthAI?</strong><br/>
  <span class="small">DepthAI basics are explained in [minimal working code sample](/examples/minimal_working_example/#explanation) and [hello world tutorial](/tutorials/hello_world/).</span>
</div>

Our network returns bounding boxes of the faces it detects (we have them stored in `entries_prev` array).
So in this sample, we have to do two main things: __crop the frame__ to contain only the face and __save it__ to 
the location specified by user.

### Performing the crop

__Cropping the frame__ requires us to modify the [minimal working code sample](/examples/minimal_working_example/), so that
we don't produce two points for rectangle, but instead we need all four points:
two of them that determine start of the crop (`top` starts Y-axis crop and `left` starts X-axis crop),
and another two as the end of the crop (`bottom` ends Y-axis crop and `right` ends X-axis crop)

```python
                left = int(e['left'] * img_w)
                top = int(e['top'] * img_h)
                right = int(e['right'] * img_w)
                bottom = int(e['bottom'] * img_h)
```

Now, since our frame is in `HWC` format (Height, Width, Channels), we first crop the Y-axis (being height) and then the X-axis (being width).
So the cropping code looks like this:

```python
                face_frame = frame[top:bottom, left:right]
```

Now, there's one additional thing to do. Since sometimes the network may produce such bounding box, what when cropped
will produce an empty frame, we have to secure ourselves from this scenario, as `cv2.imshow` will throw
an error if invoked with empty frame.

```python
                if face_frame.size == 0:
                    continue
                cv2.imshow(f'face-{packet.stream_name}', face_frame)
```

Later on, as we're having two cameras operating same time, we're assigning the shown frame to either left or right face frame 
variable, which will help us later during image saving

```python
                if packet.stream_name == 'left':
                    face_frame_left = face_frame
                else:
                    face_frame_right = face_frame
```

### Storing the frame

__To save the image__ we'll need to do two things:

- Merge the face frames from both left and right cameras into one frame
- Save the prepared frame to the disk

Thankfully, OpenCV has it all sorted out, so for each point we'll use just a single line of code, 
invoking `cv2.hconcat` for frames merging and `cv2.imwrite` to store the image

Rest of the code, utilizing `tkinter` package, is optional and can be removed if you don't require
user interaction to save the frame.

In this sample, we use `tkinter` for two dialog boxes:

- To obtain destination filepath (stored as `filepath`) that allows us to invoke `cv2.imwrite` as it requires path as it's first argument
- To confirm that the file was saved successfully

```python
    key = cv2.waitKey(1)
    if key == ord('q'):
        break
    if key == ord(' ') and face_frame_left is not None and face_frame_right is not None:
        from tkinter import Tk, messagebox
        from tkinter.filedialog import asksaveasfilename
        Tk().withdraw()
        filename = asksaveasfilename(defaultextension=".png", filetypes=(("Image files", "*.png"),("All Files", "*.*")))
        joined_frame = cv2.hconcat([face_frame_left, face_frame_right])
        cv2.imwrite(filename, joined_frame)
        messagebox.showinfo("Success", "Image saved successfully!")
        Tk().destroy()
```

---

Do you have any questions/suggestions? Feel free to [get in touch and let us know!](/support)
