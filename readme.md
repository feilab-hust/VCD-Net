**We move our demonstration to Jupyter notebook.**

The [notebook](./VCD-LFM pipeline.ipynb) will navigate you through the pipeline of VCD-LFM.

To enter the jupyter notebook based demo, you should launch a cloud workstation using **jupyter notebook** on code ocean (click on the jupyter notebook icon on the right top of this web page, somewhere under the button **reproducible run**). 

**Note**: you will **NOT** enter the notebook by clicking on button **reproducible run**.

By clicking on **reproducible run**, you will get the results by running the codes seamlessly through only two steps: 1. Prepare the training dataset; 2. Apply a well-trained model to reconstruct a test light field raw data. **It will take around 25 minutes in total.** Note that we skip the training which is supposed to operate between these two steps, due to its time consumption (> 5hrs). We suggest you download the codes to your workstation for the training step.

If you want cell-by-cell code running, please use Jupyter Notebook. 



===============================================================================================


**In current revision, we added an option to switch to a modified model for function imaging data reconstruction.**

To check the model, go to **/code/vcdnet/model/unet.py->UNet_B**

The general pipeline stays the same and the only thing to do for model switching is to change from
`config.model                      = 'structure'` to 
`config.model                      = 'function'` in  **/code/vcdnet/config.py**

For demo purpose, we added an extra checkpoint named **neuron_8um_simu_40x_n11_[m30-0]_step1um** in **data/checkpoint** and dataset **to_predict2** which contains 200-frame light-field movies. 

Edit the **/code/vcdnet/config.py** to ensure:
```
config.PSF.n_slices = 31
label                             = 'neuron_8um_simu_40x_n11_[m30-0]_step1um'
config.model                      = 'function'
config.VALID.lf2d_path            = '../../data/to_predict2/'
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

