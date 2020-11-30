from easydict import EasyDict as edict

config = edict()
config.TRAIN = edict()
config.PSF = edict()
config.VALID = edict()

config.img_size     = 176                                                           # LF 2D image size for training
config.size_factor  = [1, 1]                                                        # Real img_size = img_size * size_factor
config.PSF.n_slices = 61                                                            # Number of z slices of the 3-D reconstruction
# config.PSF.n_slices = 31
config.PSF.Nnum     = 11                                                            # N number of the light field psf
config.n_channels   = 1                                                             # Number of channels of the training and validation data

label                             = 'tubulin_40x_n11_[m30-30]_step1um_xl9_num120_sparse'        # Distingiushable label for saving the checkpoint files and validation result
# label                             = 'neuron_8um_simu_40x_n11_[m30-0]_step1um'
# label                             = 'beads_empirical_40x_n11_[m30-30]_step1um'
# label                             = 'worm_empirical_40x_n11_[m30-0]_step1um'
config.label                      = label     
config.model                      = 'structure'
# config.model                      = 'function'

## Training 
config.TRAIN.target3d_path        = './data/train/WF/'                   # 3-D targets for training
config.TRAIN.lf2d_path            = './data/train/LF/'                   # LF projections for training

config.TRAIN.test_saving_path     = "./sample/test/{}/".format(label)
config.TRAIN.ckpt_saving_interval = 10
config.TRAIN.ckpt_dir             = "./checkpoint/{}/".format(label)
config.TRAIN.log_dir              = "./log/{}/".format(label)
config.TRAIN.device               = 0                                               # gpu device used for training, 0 means the 1st device is used.
config.TRAIN.valid_on_the_fly     = False
config.TRAIN.using_edge_loss      = False                                           # use the edges loss to promote the quality of the reconstructions

config.TRAIN.batch_size  = 1
config.TRAIN.lr_init     = 1e-4
config.TRAIN.beta1       = 0.9
config.TRAIN.n_epoch     = 200
config.TRAIN.lr_decay    = 0.1
config.TRAIN.decay_every = 50

## Inference/Prediction
config.VALID.ckpt_dir             = config.TRAIN.ckpt_dir                          # use trained checkpoint 
config.VALID.lf2d_path            = './data/to_predict/'                           # location of LF measurements to be reconstructed
# config.VALID.lf2d_path            = './data/to_predict2/'
# config.VALID.lf2d_path            = './data/to_predict_beads/'
# config.VALID.lf2d_path            = './data/to_predict_worm/'
config.VALID.saving_path          = './results/VCD_{}/'.format(label)





