import os
import tensorflow as tf
from net.network import SemanticRegenerationNet, HRSemanticRegenerationNet
from data.data import DataLoader
from options.train_options import TrainOptions

config = TrainOptions().parse()

if config.model == 'srn':
    model = SemanticRegenerationNet()
else:
    model = HRSemanticRegenerationNet()

# training data
dataLoader = DataLoader(filename=config.dataset_path, batch_size=config.batch_size,
                        im_size=config.img_shapes)
images = dataLoader.next()[:, :, :, ::-1] # input BRG images
g_vars, d_vars, losses = model.build_net(images, config=config)

lr = tf.compat.v1.get_variable(
    'lr', shape=[], trainable=False,
    initializer=tf.constant_initializer(config.lr))

g_optimizer =  tf.optimizers.Adam(lr)
d_optimizer = g_optimizer

#g_train_op = g_optimizer.minimize(losses['g_loss'], var_list=g_vars)
#d_train_op = d_optimizer.minimize(losses['d_loss'], var_list=d_vars)

saver =tf.compat.v1.train.Saver(max_to_keep=10, keep_checkpoint_every_n_hours=1)

summary_op = tf.compat.v1.summary.merge_all()

with tf.compat.v1.Session() as sess:
    sess.run(tf.compat.v1.global_variables_initializer())

    if config.load_model_dir != '':
        print('[-] Loading the pretrained model from: {}'.format(config.load_model_dir))
        ckpt = tf.train.get_checkpoint_state(config.load_model_dir)
        if ckpt:
            assign_ops = list(
                map(lambda x: tf.compat.v1.assign(x, tf.train.load_variable(config.load_model_dir, x.name)),
                    g_vars))
            sess.run(assign_ops)
            print("[*] Loading SUCCESS.")
        else:
            print("[x] Loading ERROR.")

    summary_writer = tf.compat.v1.summary.FileWriter(config.model_folder, sess.graph, flush_secs=30)

    coord = tf.train.Coordinator()
    thread = tf.compat.v1.train.start_queue_runners(sess=sess, coord=coord)

    for step in range(1, config.max_iters+1):

        #if config.pretrain_network is False:
            #for _ in range(5):
                #_, d_loss = sess.run([d_train_op, losses['d_loss']])

        #_, g_loss = sess.run([g_train_op, losses['g_loss']])

        if step % config.viz_steps == 0:
            #print('[{:04d}, {:04d}] G_loss > {}'.format(step // config.train_spe, step % config.train_spe, g_loss))
            summary_writer.add_summary(sess.run(summary_op), global_step=step)

        if step % config.train_spe == 0:
            saver.save(sess, os.path.join(config.model_folder, config.model_prefix), step)

    coord.request_stop()
    coord.join(thread)
