import pickle
import numpy as np

__version__ = "1.0"

with open("models/diapetes/random_forest_model_diapetes.pkl", "rb") as f:
    model = pickle.load(f)

def predict_pipeline(data: dict) -> str:

    input_array = np.array([list(data.values())])
    prediction = model.predict(input_array)[0]
    return "Diabetes" if prediction == 1 else "No Diabetes"
