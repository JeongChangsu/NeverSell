#!/bin/bash

echo "Setting up Python 3.10 virtual environment..."
python3.10 -m venv .venv

echo "Activating .venv virtual environment..."
source .venv/bin/activate

echo "Installing required packages from requirements.txt..."
pip install -r requirements.txt

echo "Development environment setup complete." 