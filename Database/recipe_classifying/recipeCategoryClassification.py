import ssl
ssl._create_default_https_context = ssl._create_unverified_context
import os
import numpy as np
import pandas as pd
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator, load_img, img_to_array
from tensorflow.keras.applications import ResNet50
from tensorflow.keras.layers import GlobalAveragePooling2D, Dense
from tensorflow.keras.models import Model

img_height, img_width = 224, 224
batch_size = 32

# Training data from a set i got from Kaggle with meal, dessert, and drink images
train_datagen = ImageDataGenerator(
    rescale=1./255,
    horizontal_flip=True,
    rotation_range=20,
    zoom_range=0.2,
    validation_split=0.2 
)

train_generator = train_datagen.flow_from_directory( 
    'food-cl', 
    target_size=(img_height, img_width),
    batch_size=batch_size,
    classes=['meal', 'dessert', 'drink'],
    class_mode='categorical',
    subset='training'
)

validation_generator = train_datagen.flow_from_directory(
    'food-cl',
    target_size=(img_height, img_width),
    batch_size=batch_size,
    classes=['meal', 'dessert', 'drink'],
    class_mode='categorical',
    subset='validation'
)


base_model = ResNet50(weights='imagenet', include_top=False, input_shape=(img_height, img_width, 3))
x = base_model.output
x = GlobalAveragePooling2D()(x)
x = Dense(1024, activation='relu')(x)
predictions = Dense(3, activation='softmax')(x)  # 3 classes

model = Model(inputs=base_model.input, outputs=predictions)

for layer in base_model.layers:
    layer.trainable = False

model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

print("Starting training")
model.fit(train_generator, validation_data=validation_generator, epochs=5)

for layer in base_model.layers[-10:]:
    layer.trainable = True

model.compile(optimizer=tf.keras.optimizers.Adam(1e-5), loss='categorical_crossentropy', metrics=['accuracy'])
print("Starting fine-tuning")
model.fit(train_generator, validation_data=validation_generator, epochs=5)





# predict on images in the 'media' folder
media_folder = 'media'
results = []

for img_file in os.listdir(media_folder):
    if img_file.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp', '.gif')):
        img_path = os.path.join(media_folder, img_file)
        img = load_img(img_path, target_size=(img_height, img_width))
        img_array = img_to_array(img)
        img_array = np.expand_dims(img_array, axis=0) / 255.0  # image scale used  in training
        pred = model.predict(img_array)
        pred_class = np.argmax(pred, axis=1)[0]
        tag = pred_class + 1  # Map 0->1 (meal), 1->2 (dessert), 2->3 (drink)
        results.append({'image_name': img_file, 'tag': tag})

results_df = pd.DataFrame(results)
results_df.to_csv('recipeCategoryClassification.csv', index=False)