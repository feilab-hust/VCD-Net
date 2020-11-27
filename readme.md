
The [notebook](./VCD-LFM pipeline.ipynb) will navigate you through the pipeline of VCD-LFM.


===============================================================================================


**In current revision, we added an option to switch to a modified model for function imaging data reconstruction.**

To check the model, go to **/vcdnet/model/unet.py->UNet_B**

The general pipeline stays the same and the only thing to do for model switching is to change from
`config.model                      = 'structure'` to 
`config.model                      = 'function'` in  **/vcdnet/config.py**

we provide pretraned models and example dataset for trainig and inference, which can be downloaded from [here](https://drive.google.com/file/d/1h_Q7ylHeMh9dCUeo8Fz8o2j0WsM25-2g/view?usp=sharing). After unzip, put the `data/` and `checkpoint/` folder under `vcdnet/`.

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

to reconstruct the images. 

**p.s.** the jupyter notebook only demonstrates on the tubulin images (structure imaging).

