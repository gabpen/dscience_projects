import zipfile
from PIL import Image, UnidentifiedImageError
import pytesseract
import cv2 as cv
import numpy as np

# Load the face detection classifier
face_cascade = cv.CascadeClassifier('haarcascade_frontalface_default.xml')

# Create variable for the name we are looking for
word = 'Mark'

# List to store information about each image
image_data = []

# Open zip file to process all the images
with zipfile.ZipFile('images.zip', 'r') as myzip:
    # Loop through the files and read each image
    for file_info in myzip.infolist():
        if file_info.is_dir():
            # Skip directories
            continue
        
        with myzip.open(file_info) as file:
            try:
                img = Image.open(file)
                gray_img = img.convert('L')
                text = pytesseract.image_to_string(gray_img)
                
                # Store filename, extracted text, and image object in a dictionary
                image_info = {
                    'file_name': file_info.filename,
                    'text': text,
                    'image': img
                }
                image_data.append(image_info)
            except UnidentifiedImageError:
                # Skip files that cannot be identified as images
                print(f"Skipping non-image file: {file_info.filename}")
                continue

# Process each image to find the specified word and detect faces
for image_info in image_data:
    if word.lower() in image_info['text'].lower():
        img = image_info['image']
        np_img = np.array(img)
        gray = cv.cvtColor(np_img, cv.COLOR_RGB2GRAY)
        faces = face_cascade.detectMultiScale(gray, 1.3, 5)
        if len(faces) > 0:
            print('Results found in file {}'.format(image_info['file_name']))
            face_size = (100, 100)
            images_per_row = 5
            rows_needed = (len(faces) + images_per_row - 1) // images_per_row
            contact_sheet = Image.new('RGB', (images_per_row * face_size[0], rows_needed * face_size[1]))
            
            # Paste each detected face into the contact sheet
            x, y = 0, 0
            for (x1, y1, w, h) in faces:
                face_image = img.crop((x1, y1, x1 + w, y1 + h))
                face_image.thumbnail(face_size)
                contact_sheet.paste(face_image, (x, y))
                x += face_size[0]
                if x >= contact_sheet.width:
                    x = 0
                    y += face_size[1]
            contact_sheet.show()
        
        else:
            print('Results found in file {}\nBut there were no faces in the file!'.format(image_info['file_name']))
