import skimage
import skimage.transform
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
    
def construct_masked(input_img):
    resized = skimage.transform.resize(input_img, (input_size, input_size), anti_aliasing=True)
    result = np.ones((output_size, output_size))
    result[expand_size:-expand_size, expand_size:-expand_size, :] = resized
    return result


def blend_result(output_img, input_img, blend_width=8):
    '''
    Blends an input of arbitrary resolution with its output, using the highest resolution of both.
    Returns: final result + source mask.
    '''
    print('Input size:', input_img.shape)
    print('Output size:', output_img.shape)
    in_factor = input_size / output_size
    if input_img.shape[1] < in_factor * output_img.shape[1]:
        # Output dominates, adapt input
        out_width, out_height = output_img.shape[1], output_img.shape[0]
        in_width, in_height = int(out_width * in_factor), int(out_height * in_factor)
        input_img = skimage.transform.resize(input_img, (in_height, in_width), anti_aliasing=True)
    else:
        # Input dominates, adapt output
        in_width, in_height = input_img.shape[1], input_img.shape[0]
        out_width, out_height = int(in_width / in_factor), int(in_height / in_factor)
        output_img = skimage.transform.resize(output_img, (out_height, out_width), anti_aliasing=True)
    
    # Construct source mask
    src_mask = np.zeros((output_size, output_size))
    src_mask[expand_size+1:-expand_size-1, expand_size+1:-expand_size-1] = 1 # 1 extra pixel for safety
    src_mask = distance_transform_edt(src_mask) / blend_width
    src_mask = np.minimum(src_mask, 1)
    src_mask = skimage.transform.resize(src_mask, (out_height, out_width), anti_aliasing=True)
    src_mask = np.tile(src_mask[:, :, np.newaxis], (1, 1, 3))
    
    # Pad input
    input_pad = np.zeros((out_height, out_width, 3))
    #print(input_pad)
    x1 = (out_width - in_width) // 2
    y1 = (out_height - in_height) // 2
    input_pad[y1:y1+in_height, x1:x1+in_width, :] = input_img
    
    # Merge
    blended = input_pad * src_mask + output_img * (1 - src_mask)

    print('Blended size:', blended.shape)

    return blended, src_mask

def get_adv_weight(adv_weight, epoch):
    if isinstance(adv_weight, list):
        if epoch < 10:
            return adv_weight[0]
        elif epoch < 30:
            return adv_weight[1]
        elif epoch < 60:
            return adv_weight[2]
        else:
            return adv_weight[3]
    else: # just one number
        return adv_weight
    
def load_model(model_path):
    model = CEGenerator(extra_upsample=True)
    state_dict = torch.load(model_path, map_location=torch.device('cpu'))

    # Remove 'module' if present
    new_state_dict = OrderedDict()
    for k, v in state_dict.items():
        if 'module' in k:
            name = k[7:] # remove 'module'
        else:
            name = k
        new_state_dict[name] = v

    model.load_state_dict(new_state_dict)
    model.cpu()
    model.eval()
    return model