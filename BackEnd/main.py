from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import importlib.util
import shutil
import os

app = FastAPI()

def load_module(disease_name: str):
    module_path = f"models/{disease_name}/model.py"
    if not os.path.exists(module_path):
        raise HTTPException(status_code=404, detail=f"No model found for {disease_name}")
    spec = importlib.util.spec_from_file_location("model_module", module_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

@app.get("/")
def home():
    return {"status": "ok", "message": "Use /predict/image/{disease} or /predict/data/{disease}"}

@app.post("/predict/image/{disease}")
async def predict_image(disease: str, file: UploadFile = File(...)):
    try:
        model = load_module(disease)
        temp_path = f"temp_{file.filename}"
        with open(temp_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        result = model.predict_pipeline(temp_path)
        os.remove(temp_path)

        return {"diagnosis": result, "version": model.__version__}
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})

class TabularInput(BaseModel):
    data: dict

@app.post("/predict/data/{disease}")
async def predict_data(disease: str, input: TabularInput):
    try:
        model = load_module(disease)
        result = model.predict_pipeline(input.data)
        return {"diagnosis": result, "version": model.__version__}
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})
