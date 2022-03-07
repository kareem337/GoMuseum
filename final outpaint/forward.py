from outpainting import *
import keras
import tensorflow as tf
from tensorflow.keras.preprocessing import image
import numpy as np
import os
os.environ["KMP_DUPLICATE_LIB_OK"]="TRUE"

if __name__ == '__main__':
    new_model = tf.keras.models.load_model('C:/Users/hp/OneDrive/Desktop/Graduation project/GoMuseum/outpaint/ResNet_Classification_egy.h5')
    #img_path = 'D:/MIU/University/Year 4/Gradution Project/SRS GAN CODE/test/13.jpeg'
    img = image.load_img('test.jpg', target_size=(224, 224))
    x = image.img_to_array(img)
    x = np.expand_dims(x, axis=0)
    categories = os.listdir('C:/Users/hp/OneDrive/Desktop/Graduation/augmented/augmented')
    preds = new_model.predict(x)
    print("Model predicts a \"{}\" with {:.2f}% probability".format(categories[np.argmax(preds[0])], preds[0][np.argmax(preds)] * 100))
    #src_file = sys.argv[1]
    #dst_file = sys.argv[2]
    gen_model = load_model('modeld.pt')
    #('Source file: ' + src_file + '...')
    #input_img = plt.imread(src_file)[:, :, :3]
    input_img = plt.imread('test.jpg')[:, :, :3]
    output_img, blended_img = perform_outpaint(gen_model, input_img)
    plt.imsave('output test.jpeg', blended_img)

