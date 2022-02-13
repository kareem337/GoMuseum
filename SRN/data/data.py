import tensorflow as tf


class DataLoader:
    def __init__(self, filename, im_size, batch_size):
        self.filelist = open(filename, 'rt').read().splitlines()

        if not self.filelist:
            exit('\nError: file list is empty\n')

        self.im_size = im_size
        self.batch_size = batch_size
        self.data_queue = None

    def next(self):
        tf.compat.v1.disable_eager_execution()
        with tf.compat.v1.variable_scope('feed'):
            filelist_tensor = tf.convert_to_tensor(self.filelist, dtype=tf.string)
            self.data_queue =tf.compat.v1.train.slice_input_producer([filelist_tensor])
            print('slice done')
            im_gt = tf.io.decode_image(tf.io.read_file(self.data_queue[0]), channels=3)
            print('decode done')
            im_gt = tf.cast(im_gt, tf.float32)
            im_gt = tf.image.resize_with_crop_or_pad(im_gt, self.im_size[0], self.im_size[1])
            im_gt.set_shape([self.im_size[0], self.im_size[1], 3])
            batch_gt = tf.compat.v1.train.batch([im_gt], batch_size=self.batch_size, num_threads=4)
        return batch_gt
