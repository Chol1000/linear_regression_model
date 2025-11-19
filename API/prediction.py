from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import pandas as pd
import joblib
import numpy as np
from typing import Literal
import os

app = FastAPI(
    title="International Graduates Salary Prediction API",
    description="Predict salary potential for international graduates based on education, skills, and background factors",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class PredictionInput(BaseModel):
    education_level: Literal["Diploma", "Bachelor's", "Master's", "PhD"] = Field(..., description="Education level")
    field_of_study: Literal["Engineering", "IT", "Business", "Health", "Arts", "Social Sciences"] = Field(..., description="Field of study")
    language_proficiency: Literal["Basic", "Intermediate", "Fluent", "Advanced"] = Field(..., description="Language proficiency level")
    visa_type: Literal["Student", "Post-study", "Work", "Permanent Residency"] = Field(..., description="Visa type")
    university_ranking: Literal["Low", "Medium", "High"] = Field(..., description="University ranking")
    region_of_study: Literal["UK", "Canada", "Australia", "EU"] = Field(..., description="Region of study (UK, Canada, Australia, EU)")
    age: int = Field(..., ge=18, le=65, description="Age between 18 and 65")
    years_since_graduation: int = Field(..., ge=0, le=40, description="Years since graduation (0-40)")

class PredictionOutput(BaseModel):
    predicted_salary: float
    education_level: str
    field_of_study: str
    confidence: str
    model_used: str
    model_performance: str

model_cache = {}

def load_model_and_preprocessors():
    """Load the saved model and preprocessing objects once"""
    if model_cache:
        return (
            model_cache['model'], 
            model_cache['scaler'], 
            model_cache['feature_names'], 
            model_cache['categorical_columns']
        )
    
    try:
        # Use relative path to access linear_regression/models from API directory
        base_path = "../linear_regression/models"
        
        required_files = [
            'best_linear_model.pkl',
            'scaler.pkl', 
            'feature_names.pkl',
            'categorical_columns.pkl'
        ]
        
        for file in required_files:
            if not os.path.exists(os.path.join(base_path, file)):
                raise FileNotFoundError(f"Required model file missing: {file}")
        
        model = joblib.load(os.path.join(base_path, 'best_linear_model.pkl'))
        scaler = joblib.load(os.path.join(base_path, 'scaler.pkl'))
        feature_names = joblib.load(os.path.join(base_path, 'feature_names.pkl'))
        categorical_columns = joblib.load(os.path.join(base_path, 'categorical_columns.pkl'))
        
        model_cache.update({
            'model': model,
            'scaler': scaler,
            'feature_names': feature_names,
            'categorical_columns': categorical_columns
        })
        
        print("Model and preprocessors loaded successfully")
        print(f"Model type: {type(model)}")
        print(f"Features: {len(feature_names)}")
        
        return model, scaler, feature_names, categorical_columns
        
    except Exception as e:
        print(f"Model loading error: {e}")
        return None, None, None, None

def predict_graduate_salary(education_level, field_of_study, language_proficiency,
                          visa_type, university_ranking, region_of_study,
                          age, years_since_graduation):
    """
    Predict salary using the trained Linear Regression model (BEST PERFORMING MODEL)
    """
    try:
        model, scaler, feature_names, categorical_columns = load_model_and_preprocessors()
        
        if model is None or scaler is None:
            raise HTTPException(status_code=500, detail="Model not loaded properly")
        
        input_data = pd.DataFrame({
            'Education_Level': [education_level],
            'Field_of_Study': [field_of_study],
            'Language_Proficiency': [language_proficiency],
            'Visa_Type': [visa_type],
            'University_Ranking': [university_ranking],
            'Region_of_Study': [region_of_study],  # Using REGION as per training data
            'Age': [age],
            'Years_Since_Graduation': [years_since_graduation]
        })
        
        # One-hot encoding is REQUIRED to match training data preprocessing
        input_encoded = pd.get_dummies(input_data, columns=categorical_columns, prefix=categorical_columns)
        
        # Ensure all training features are present
        for feature in feature_names:
            if feature not in input_encoded.columns:
                input_encoded[feature] = 0
        
        # Reorder columns to exactly match training data order
        input_encoded = input_encoded[feature_names]
        
        # Scale the input data (model was trained on scaled data)
        input_scaled = scaler.transform(input_encoded)
        
        # Make prediction using BEST PERFORMING MODEL (Linear Regression)
        prediction = model.predict(input_scaled)[0]
        
        # Apply realistic bounds
        prediction = max(20000, min(150000, prediction))
        
        return float(prediction)
        
    except Exception as e:
        print(f"Prediction error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")

@app.on_event("startup")
async def startup_event():
    """Load model on startup"""
    print("Starting International Graduates Salary Prediction API")
    model, scaler, feature_names, categorical_columns = load_model_and_preprocessors()
    if model is not None:
        print("API ready for predictions")
        print(f"Using BEST PERFORMING MODEL: Linear Regression (Test MSE: 36,009,030)")
    else:
        print("API failed to load model")

@app.get("/")
async def read_root():
    return {
        "message": "International Graduates Salary Prediction API",
        "status": "active",
        "best_model": "Linear Regression",
        "performance": "Test R²: 0.8877, Test MSE: 36,009,030 (Lowest Loss)",
        "endpoints": {
            "docs": "/docs",
            "health": "/health",
            "predict": "/predict",
            "model_info": "/model-info"
        }
    }

@app.post("/predict", response_model=PredictionOutput)
async def predict_salary(input_data: PredictionInput):
    """
    Predict salary for international graduate using BEST PERFORMING MODEL
    """
    try:
        predicted_salary = predict_graduate_salary(
            education_level=input_data.education_level,
            field_of_study=input_data.field_of_study,
            language_proficiency=input_data.language_proficiency,
            visa_type=input_data.visa_type,
            university_ranking=input_data.university_ranking,
            region_of_study=input_data.region_of_study,
            age=input_data.age,
            years_since_graduation=input_data.years_since_graduation
        )
        
        return PredictionOutput(
            predicted_salary=round(predicted_salary, 2),
            education_level=input_data.education_level,
            field_of_study=input_data.field_of_study,
            confidence="High",
            model_used="Linear Regression (Best Performing)",
            model_performance="R²: 0.8877, MSE: 36,009,030 (Lowest Loss)"
        )
        
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    model, _, _, _ = load_model_and_preprocessors()
    status = "healthy" if model is not None else "unhealthy"
    
    return {
        "status": status,
        "model_loaded": model is not None,
        "best_model": "Linear Regression",
        "performance": {
            "test_r2": 0.8877,
            "test_mse": 36009030,
            "test_rmse": 6000.75
        },
        "features_used": 27
    }

@app.get("/model-info")
async def model_info():
    """Get detailed model information"""
    model, scaler, feature_names, categorical_columns = load_model_and_preprocessors()
    
    return {
        "best_model_selected": "Linear Regression",
        "selection_criteria": "Lowest Test MSE (Least Loss)",
        "performance_metrics": {
            "test_r2": 0.8877,
            "test_mse": 36009030,
            "test_rmse": 6000.75,
            "variance_explained": "88.77%"
        },
        "model_comparison": {
            "linear_regression": {"test_mse": 36009030, "test_r2": 0.8877},
            "random_forest": {"test_mse": 36058265, "test_r2": 0.8875},
            "sgd_regressor": {"test_mse": 36202098, "test_r2": 0.8871},
            "decision_tree": {"test_mse": 36682082, "test_r2": 0.8856}
        },
        "training_details": {
            "training_samples": 125315,
            "test_samples": 31329,
            "features_after_encoding": 27,
            "categorical_columns": categorical_columns if categorical_columns else []
        }
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        app, 
        host="0.0.0.0", 
        port=8000,
        log_level="info"
    )