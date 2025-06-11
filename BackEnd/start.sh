#!/bin/bash

echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

echo "Launching FastAPI server..."
uvicorn main:app --host 0.0.0.0 --port 10000
