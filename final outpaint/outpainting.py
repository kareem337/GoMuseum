from collections import defaultdict, OrderedDict
from html4vision import Col, imagetable
from PIL import Image
from scipy.ndimage.morphology import distance_transform_edt
from torch import nn, optim
from torch.autograd import Variable
from torchvision import datasets, transforms, models, utils
from torchvision.utils import save_image
from torch.utils.data import Dataset, DataLoader
import glob
import numpy as np
import torch

input_size = 128    #input_size=128
output_size = 192
expand_size = (output_size - input_size) // 2
patch_w = output_size // 8
patch_h = output_size // 8
patch = (1, patch_h, patch_w)

class CEGenerator(nn.Module):
    def __init__(self, channels=3, extra_upsample=False):
        super(CEGenerator, self).__init__()

        def downsample(in_feat, out_feat, normalize=True):
            layers = [nn.Conv2d(in_feat, out_feat, 4, stride=2, padding=1)]
            if normalize:
                layers.append(nn.BatchNorm2d(out_feat, 0.8))
            layers.append(nn.LeakyReLU(0.2))
            return layers

        def upsample(in_feat, out_feat, normalize=True):
            layers = [nn.ConvTranspose2d(in_feat, out_feat, 4, stride=2, padding=1)]
            if normalize:
                layers.append(nn.BatchNorm2d(out_feat, 0.8))
            layers.append(nn.ReLU())
            return layers

        if not(extra_upsample):
            self.model = nn.Sequential(
                *downsample(channels, 64, normalize=False),
                *downsample(64, 64),
                *downsample(64, 128),
                *downsample(128, 256),
                *downsample(256, 512),
                nn.Conv2d(512, 4000, 1),
                *upsample(4000, 512),
                *upsample(512, 256),
                *upsample(256, 128),
                *upsample(128, 64),
                nn.Conv2d(64, channels, 3, 1, 1),
                nn.Tanh()
            )
        else:
            self.model = nn.Sequential(
                *downsample(channels, 64, normalize=False),
                *downsample(64, 64),
                *downsample(64, 128),
                *downsample(128, 256),
                *downsample(256, 512),
                nn.Conv2d(512, 4000, 1),
                *upsample(4000, 512),
                *upsample(512, 256),
                *upsample(256, 128),
                *upsample(128, 64),
                *upsample(64, 64),
                nn.Conv2d(64, channels, 3, 1, 1),
                nn.Tanh()
            )

    def forward(self, x):
        return self.model(x)
    
class CEDiscriminator(nn.Module):
    def __init__(self, channels=3):
        super(CEDiscriminator, self).__init__()

        def discriminator_block(in_filters, out_filters, stride, normalize):
            """Returns layers of each discriminator block"""
            layers = [nn.Conv2d(in_filters, out_filters, 3, stride, 1)]
            if normalize:
                layers.append(nn.InstanceNorm2d(out_filters))
            layers.append(nn.LeakyReLU(0.2, inplace=True))
            return layers

        layers = []
        in_filters = channels
        for out_filters, stride, normalize in [(64, 2, False), (128, 2, True), (256, 2, True), (512, 1, True)]:
            layers.extend(discriminator_block(in_filters, out_filters, stride, normalize))
            in_filters = out_filters

        layers.append(nn.Conv2d(out_filters, 1, 3, 1, 1))
    
        self.model = nn.Sequential(*layers)
        
    


    def forward(self, img):
          return self.model(img)

class CEImageDataset(Dataset):
    
    def __init__(self, root, transform, output_size=192, input_size=128, outpaint=True):
        self.transform = transform
        self.output_size = output_size
        self.input_size = input_size
        self.outpaint = outpaint
        self.files = sorted(glob.glob("%s/*.jpg" % root))

    def apply_center_mask(self, img):
        """Mask center part of image"""
        # Get upper-left pixel coordinate
        i = (self.output_size - self.input_size) // 2
        
        if not(self.outpaint):
            masked_part = img[:, i : i + self.input_size, i : i + self.input_size]
            masked_img = img.clone()
            masked_img[:, i : i + self.input_size, i : i + self.input_size] = 1
            
        else:
            masked_part = -1 # ignore this for outpainting
            masked_img = img.clone()
            masked_img[:, :i, :] = 1
            masked_img[:, -i:, :] = 1
            masked_img[:, :, :i] = 1
            masked_img[:, :, -i:] = 1

        return masked_img, masked_part
    
    def apply_random_mask(self, img):
        """Randomly masks image"""
        y1, x1 = np.random.randint(0, self.output_size - self.input_size, 2)
        y2, x2 = y1 + self.input_size, x1 + self.input_size
        masked_part = img[:, y1:y2, x1:x2]
        masked_img = img.clone()
        masked_img[:, y1:y2, x1:x2] = 1

        return masked_img, masked_part
    
    


    def __getitem__(self, index):

        try:
            img = Image.open(self.files[index % len(self.files)]).convert('RGB')
            img = self.transform(img)
        except:
            # Likely corrupt image file, so generate black instead
            img = torch.zeros((3, self.output_size, self.output_size))
            
        masked_img, masked_part = self.apply_center_mask(img)

        return img, masked_img, masked_part

    def __len__(self):
        return len(self.files)