from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
import numpy as np

__version__ = "1.0"
model = load_model("models/covid/covid_model.h5")

def predict_pipeline(img_path: str) -> str:
    img = image.load_img(img_path, target_size=(224, 224))
    img_array = image.img_to_array(img) / 255.0
    img_array = np.expand_dims(img_array, axis=0)
    prediction = model.predict(img_array)[0][0]
    return "COVID" if prediction <= 0.5 else "Normal"
