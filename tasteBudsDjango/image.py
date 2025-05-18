from PIL import Image

# Load your custom image
custom_img = Image.open('media/besitos-de-coco.jpg')  # change filename
custom_img = custom_img.convert('RGB')
custom_img = custom_img.resize((1280, 720))  # use size from previous step

# Save it, either overwrite or save as new file
custom_img.save('media/besitos-de-coco.jpg', format='JPEG')




