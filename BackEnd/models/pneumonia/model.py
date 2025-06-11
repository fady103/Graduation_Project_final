from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
import numpy as np

__version__ = "1.0"

model = load_model("models/pneumonia/CNN_pneumonia_model.h5")

def predict_pipeline(img_path: str) -> str:
    img = image.load_img(img_path, color_mode="grayscale", target_size=(150, 150))
    
    img_array = image.img_to_array(img) / 255.0
    img_array = np.expand_dims(img_array, axis=0)

    prediction = model.predict(img_array)[0][0]

    return "PNEUMONIA" if prediction <= 0.5 else "NORMAL"
