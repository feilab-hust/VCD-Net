# VCDNet

Tensorflow implementation of VCD-Net for high-efficiency light field reconstruction. Check [this repo](https://github.com/xinDW/LFRNet) (@Hao Zhang) for original code.

## Requirements

* Python 3
* (Optional but highly recommended) CUDA 10.2 and CUDNN 

## Install

Clone the code. The directory should be like this:
```    
.
├── config.py
├── dataset.py
├── eval.py
├── train.py
├── utils.py
├── model
    └── util
    └── unet.py
├── tensorlayer
        
```

To set up the environment, use:
```
pip install -r requirement.txt
```
It takes ~10 minutes to go through the whole setups. VCDNet requires an old-version Tensorlayer(1.8.1, already contained in this repository) to run.

## Usage

#### Inference

To reconstruct a 3-D image, change the settings and the input path in `config.py`:

```
# To infer the bead sample:
config.PSF.n_slices          = 61
config.PSF.Nnum              = 11
label                        = 'bead_40x_[m30-30]_step1um' 
config.VALID.lf2d_path       = 'example_data/valid/bead/'  

```

Then run :
```
python eval.py [options]
```

options: 

* `-b <batch_size>`  Batch size when infering, default is 1

*  `--cpu`           Use cpu instead of gpu for inference, if a CUDA-enabled GPU is not available. 

The results will be saved at a new folder under the directory of the input images. 

To run the reconstructing process on your own LF measurements using the VCDNet trained on your own dataset, change the label and the settings to appropriate ones (See  section "Training" for details), and change `config.VALID.lf2d_path` to the path of your LF measurements. Then run the command as above.

#### Training 

Run

```
python train.py [options]
```
options:

* `-c <begin_epoch>`   Load the existing checkpoint file and continue training from epoch designated by begin_epoch   

To train the VCD-Net on your own dataset, the following should be done:
1. Change the settings of the training dataset in `config.py`, including:
```
    config.img_size=<lateral size (px) of the LFPs and 3-D targets>
    config.PSF.n_slices=<number of slices of the 3-D targets>                                                            
    config.PSF.Nnum     = <N number of the LF data>
    config.TRAIN.lf2d_path  = <Path-to-the-LFPs>     
    config.TRAIN.target3d_path = <Path-to-the-3D-targets>   
```
2. Name the label of this training in `config.py`, as a symbol of the trained model.
    label =  <'a-distinguishable-label'>   
We recommand that the label includes the following information:
* The sample type  
* The magnification of the objective of the LFM system.
* The N number of the LF data.
* The physical z-range (um) of the 3-D reconstructions.
* The z-step size (um) of the 3-D reconstructions.

For example,
 ```
 label=zebrafish_20x_N11_[m50-50]_step2um
 ``` 
 indicates that a VCDNet will be trained on a dataset of the 20x zebrafish images, of which the LFs have the N number 11, and the 3-D targets with 2-um step size are located at -50um ~ 50um.  

The parameters of the trained model will be saved in the corresponding directory under the `repository_root/checkpoint/`. At the inference stage, the program will load the trained model parameters according to the designated label.

