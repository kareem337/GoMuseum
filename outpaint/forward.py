# Basile Van Hoorick, Jan 2020
'''
Hallucinates beyond all four edges of an image, increasing both dimensions by 50%.
The outpainting process interally converts 128x128 to 192x192, after which the generated output is upscaled.
Then, the original input is blended onto the result for optimal fidelity.
Example usage:
python forward.py input.jpg output.jpg
'''
import os
os.environ["KMP_DUPLICATE_LIB_OK"]="TRUE"
if __name__ == '__main__':

    import matplotlib.pyplot as plt
    import sys
    from outpainting import *

    print("PyTorch version: ", torch.__version__)
    print("Torchvision version: ", torchvision.__version__)

    #src_file = sys.argv[1]
    #dst_file = sys.argv[2]
    gen_model = load_model('G_art.pt')
    #('Source file: ' + src_file + '...')
    #input_img = plt.imread(src_file)[:, :, :3]
    input_img = plt.imread('input.jpeg')[:, :, :3]
    output_img, blended_img = perform_outpaint(gen_model, input_img)
    plt.imsave('output.jpeg', blended_img)
    #print('Destination file: ' + dst_file + ' written')
