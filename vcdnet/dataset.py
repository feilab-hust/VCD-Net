import tensorlayer as tl
import numpy as np
import os

from utils import *
import PIL.Image as pilImg

class Dataset:
    def __init__(self, train_hr3d_path, train_lf2d_path, n_slices, n_num, lf2d_base_size, normalize_mode='max', shuffle=True, multi_scale=False):
        '''
        Params:
            n_slices      : int, depth of the 3d target images (the reconstructions)
            n_num         : int, Nnum of light filed imaging
            lf2d_base_size: 2-element list, [height, width], equals to (lf2d_size / n_num)
            normalize_mode: str, normalization mode of dataset in ['max', 'percentile']
            shuffle       : boolean, whether to shuffle the training dataset
            multi_scale   : boolean, whether to generate multi-scale HRs
        '''
        self.train_lf2d_path = train_lf2d_path
        self.train_hr3d_path = train_hr3d_path

        self.lf2d_base_size  = lf2d_base_size
        self.n_slices        = n_slices
        self.n_num           = n_num
        self.shuffle         = shuffle
        self.multi_scale     = multi_scale
        
        self.normalize_fn = normalize_constant if normalize_mode is 'constant' else normalize

    def _load_dataset(self, shuffle=True):
        def _shuffle_in_unison(arr1, arr2):
            """shuffle elements in arr1 and arr2 in unison along the leading dimension 
            Params:
                -arr1, arr2: np.ndarray
                    must be in the same size in the leading dimension
            """
            assert (len(arr1) == len(arr2))
            new_idx = np.random.permutation(len(arr1)) 
            return arr1[new_idx], arr2[new_idx]

        def _load_imgs(path, fn, regx='.*.tif', printable=False, **kwargs):
            img_list = sorted(tl.files.load_file_list(path=path, regx=regx, printable=printable))
            imgs = []
        
            for img_file in img_list:
                img = fn(img_file, path, **kwargs) 
                if (img.dtype != np.float32):
                    img = img.astype(np.float32, casting='unsafe')
                print('\r%s : %s' % (img_file, str(img.shape)), end='')  
                imgs.append(img)
            print()
            imgs = np.asarray(imgs)
            return imgs

        training_data_hr3d = _load_imgs(self.train_hr3d_path, fn=get_and_rearrange3d, normalize_fn=self.normalize_fn)
        training_data_lf2d = _load_imgs(self.train_lf2d_path, fn=get_lf_extra, n_num=self.n_num, normalize_fn=self.normalize_fn)
        # training_data_lf2d = _load_imgs(self.train_lf2d_path, fn=get_img2d_fn, normalize_fn=self.normalize_fn)
       
        if (len(training_data_hr3d) == 0) or (len(training_data_lf2d) == 0) :
            raise Exception("none of the images have been loaded, please check the file directory in config")
            
        assert training_data_hr3d.shape[0] == training_data_lf2d.shape[0]

        [self.training_data_hr3d, self.training_data_lf2d] = _shuffle_in_unison(training_data_hr3d, training_data_lf2d) if shuffle else [training_data_hr3d, training_data_lf2d]

        self.training_pair_num = self.training_data_hr3d.shape[0]
        

    def _generate_hr_pyramid(self):
        def _resize_xy(img3d, size):
            '''
            img3d : [height, width, depth]
            size  : [new_height, new_width]
            '''
            h, w, depth = img3d.shape
            new_size = size + [depth]
            img_re = np.zeros(new_size)
            
            for d in range(0, depth):
                img_re[:,:,d] = np.array(pilImg.fromarray(img3d[:,:,d]).resize((size[1], size[0]), resample=pilImg.BICUBIC))
            return img_re

        '''
        hr_pyramid = []

        for idx in range(0, self.training_pair_num):
            hr = self.training_data_hr3d[idx]
            tmp = []
            for scale in range(1, 4):
                tmp.append(_resize_xy(hr, self.lf2d_base_size * (2**scale))
            hr_pyramid.append(tmp)

        self.trainig_data_hr_pyramid = np.asarray(hr_pyramid)
        '''
        hr_s1, hr_s2, hr_s3 = [], [], []
        base_height, base_width = self.lf2d_base_size

        for idx in range(0, self.training_pair_num):
            hr = self.training_data_hr3d[idx]
            hr_s1.append(_resize_xy(hr, [base_height * 2, base_width * 2]))
            hr_s2.append(_resize_xy(hr, [base_height * 4, base_width * 4]))
            hr_s3.append(_resize_xy(hr, [base_height * 8, base_width * 8]))

        self.hr_s1 = np.asarray(hr_s1)
        self.hr_s2 = np.asarray(hr_s2)
        self.hr_s3 = np.asarray(hr_s3)

    def prepare(self, batch_size, n_epochs):
        '''
        this function must be called after the Dataset instance is created
        '''
        if os.path.exists(self.train_lf2d_path) and os.path.exists(self.train_hr3d_path):
            self._load_dataset(shuffle=self.shuffle)
        else:
            raise Exception('image data path doesn\'t exist')
        

        self.test_img_num = int(self.training_pair_num * 0.1)
        '''
        generate HR pyramid
        '''
        if self.multi_scale:
            self._generate_hr_pyramid()

        self.batch_size = batch_size
        self.n_epochs = n_epochs

        self.cursor = self.test_img_num
        self.epoch = 0

        print('HR dataset : %s\nLF dataset: %s\n' % (str(self.training_data_hr3d.shape), str(self.training_data_lf2d.shape)))
        #print('batch size : %d \n%d batches available\n' % (self.batch_size, (self.training_pair_num - batch_size) // batch_size))
        return self.training_pair_num - self.test_img_num

    def for_test(self):
        n = self.test_img_num
        return self.training_data_hr3d[0 : n], self.training_data_lf2d[0 : n]

    def hasNext(self):
        return True if self.epoch < self.n_epochs else False
             
    def iter(self):
        '''
        return the next batch of the training data
        '''
        nt = self.test_img_num
        if self.epoch < self.n_epochs:
            if self.cursor + self.batch_size > self.training_pair_num :
                self.epoch += 1
                self.cursor = nt

            idx = self.cursor
            end = idx + self.batch_size
            self.cursor += self.batch_size

            if self.multi_scale: 
                hr_pyramid = []          
                hr_pyramid.append(self.hr_s1[idx : end])
                hr_pyramid.append(self.hr_s2[idx : end])
                hr_pyramid.append(self.hr_s3[idx : end])
            else:
                hr_pyramid = self.training_data_hr3d[idx:end]

            return hr_pyramid, self.training_data_lf2d[idx : end], idx - nt, self.epoch
                
        raise Exception('epoch index out of bounds:%d/%d' %(self.epoch, self.n_epochs))