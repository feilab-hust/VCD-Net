# VCD-Net
High-efficiency light field microscopy reconstruction for VCD-LFM.  *todo: add reference* 

### This package contains: 
1. /datapre: Matlab scripts (GUI interface provided) for VCD-Net training dataset synthesis
2. /vcdnet: Source code for deep-learning based light field microscopy reconstruction

### Requirements
* Python 3
* (Optional but highly recommended) CUDA 10.2 and CUDNN 
* Packages: 
  * easydict==1.9
  * imageio==2.4.1
  * numpy==1.15.4
  * scikit-image==0.14.1
  * scipy==1.2.0
  * tensorflow-gpu==1.14.0
* Matlab

### Usage
For usage demo, we created a jupyter [notebook](https://github.com/feilab-hust/VCD-Net/blob/main/VCD-LFM%20pipeline.ipynb) to navigate through the pipeline. Example data can be downloaded from [here](https://drive.google.com/file/d/1h_Q7ylHeMh9dCUeo8Fz8o2j0WsM25-2g/view?usp=sharing). After unzip, put the `data/` and `checkpoint/` folder under `vcdnet/`. 

#### Updates 10.22.2020
**In current revision, we added an option to switch to a modified model for function imaging data reconstruction.**

To check the model, go to **/vcdnet/model/unet.py->UNet_B**

The general pipeline stays the same and the only thing to do for model switching is to change from
`config.model                      = 'structure'` to 
`config.model                      = 'function'` in  **/vcdnet/config.py**

Edit the **/vcdnet/config.py** to ensure:
```
config.PSF.n_slices = 31
label                             = 'neuron_8um_simu_40x_n11_[m30-0]_step1um'
config.model                      = 'function'
config.VALID.lf2d_path            = './data/to_predict2/'
```

And run 
```
cd /code/vcdnet
python3 eval.py
```
or
```
cd /code/vcdnet
python3 eval.py --cpu
```

to reconstruct the demo images. 

#### Updates 11.26.2020
More examples were added to the example dataset.


