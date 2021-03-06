import argparse
from torch.utils.tensorboard import SummaryWriter

import os
from net2 import *
from data import *
import tqdm
import torch.optim as optim
import matplotlib.pyplot as plt

import os
os.environ["KMP_DUPLICATE_LIB_OK"]="TRUE"

def generateViz(x):
    f = plt.figure()
    plt.imshow(x);plt.axis('off')
    return f

if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument('--data',type=str,default='C:/Users/hp/OneDrive/Desktop/___Pytourch/Pytorch_Outpainting_SRN-main/cat2dog/trainB/*.jpg')
    p.add_argument('--epoch',type=int,default=2)
    p.add_argument('--pretrained_network',type=int,default=1,help="1: to pretrain network, 0: to finetune network")
    p.add_argument('--weightpath',type=str,help="specify if pretrained_network=0")
    p.add_argument('--mode',type=str,default='train',choices=['train','test'])
    p.add_argument('--img_shapes',nargs='+',default=[256,256,3])
    p.add_argument('--mask_shapes',nargs='+',default=[128,128])
    p.add_argument('--batch_size',type=int,default=4)
    p.add_argument('--feat_expansion_op',type=str,default='subpixel')
    p.add_argument('--use_cn',type=int,default=1)
    p.add_argument('--g_cnum',type=int,default=64)
    p.add_argument('--d_cnum',type=int,default=64)
    p.add_argument('--gan_loss_alpha',type=float,default=1e-3)
    p.add_argument('--wgan_gp_lambda',type=float,default=10)
    p.add_argument('--pretrain_l1_alpha',type=float,default=1.2)
    p.add_argument('--l1_loss_alpha',type=float,default=4.2)
    p.add_argument('--ae_loss_alpha',type=float,default=1.2)
    p.add_argument('--mrf_alpha',type=float,default=0.05)
    p.add_argument('--fa_alpha',type=float,default=0.5)
    p.add_argument('--lrG',type=float,default=1e-4)
    p.add_argument('--lrD',type=float,default=1e-4)
    p.add_argument('--lpG',type=int,default=1)
    p.add_argument('--lpD',type=int,default=5)
    p.add_argument('--beta1',type=float,default=.9)
    p.add_argument('--beta2',type=float,default=.999)
    p.add_argument('--l1_type',type=int,default=0)
    p.add_argument('--random_mask',type=int,default=1)
    p.add_argument('--max_delta_shapes',nargs='+',default=[0,0])
    p.add_argument('--margins',nargs='+',default=[0,0])
    p.add_argument('--summarydir',type=str,default='log/store')
    args = p.parse_args()

    writer = SummaryWriter(args.summarydir)
    if args.mode == "train":
        # Setup
        trans = transforms.Compose([
                    transforms.Resize(args.img_shapes[:2]),transforms.ToTensor()])
        dog = dogDataset(transform=trans)
        dataloader = DataLoader(dog,batch_size=args.batch_size,shuffle=True,num_workers=0)
        
        model = SemanticRegenerationNet(args)
        if not args.pretrained_network:
            model.build_generator.load_state_dict(torch.load(args.weightpath+'/G.pt'))
            model.build_contextual_wgan_discriminator.load_state_dict(torch.load(args.weightpath+'/D.pt'))
        optimG = optim.Adam(model.build_generator.parameters(),lr=args.lrG,betas=(args.beta1,args.beta2))
        optimD = optim.Adam(model.build_contextual_wgan_discriminator.parameters(),lr=args.lrD,betas=(args.beta1,args.beta2))
        # Training loop
        ite = 0
        for epoch in range(args.epoch):
            print('[INFO] Epoch {}'.format(epoch))
            for idx,im in enumerate(tqdm.tqdm(dataloader)):
                #im = im.to('cuda:0')
                losses,viz = model(im,optimG,optimD)
            # tensorboard
                if idx%10 == 0:
                    if idx%20 == 0:
                        f = generateViz((viz*255).astype(np.uint8))
                        writer.add_figure('train {}'.format(ite),f)
                    writer.add_scalars('loss',{'g_loss':losses['g_loss'].item(),
                        'd_loss':losses['d_loss'].item()},ite)
                    if args.mrf_alpha:
                        writer.add_scalars('loss2',{'id_mrf_loss':losses['id_mrf_loss'].item(),'l1_loss':losses['l1_loss'].item(),'ae_loss':losses['ae_loss'].item()},ite)
                    else:
                        writer.add_scalars('loss2',{'l1_loss':losses['l1_loss'].item(),'ae_loss':losses['ae_loss'].item()},ite)
                ite+=1
            # save parameters
            if epoch%5 == 0:
                print('[INFO] Saving parameters ...')
                torch.save(model.build_generator.state_dict(),args.summarydir+'/G.pt')
                torch.save(model.build_contextual_wgan_discriminator.state_dict(),args.summarydir+'/D.pt')
            #pdb.set_trace()           
    elif args.mode == "test":
        pass





