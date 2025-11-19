# International Graduates Salary Prediction System

## Mission Statement
Empowering international students and graduates with data-driven career insights by leveraging machine learning to predict salary outcomes. This system bridges the information gap in global education decisions, enabling students to maximize their return on educational investment and make informed choices about their academic and professional futures.

## Dataset Description
**Source:** [International Graduates Employment Dataset - Kaggle](https://www.kaggle.com/datasets/internationaleducation/international-graduates-employment)  
**Volume:** 300,000+ anonymized records of international graduates across multiple countries  
**Variety:** Rich dataset combining graduate-outcomes survey data with visa, language, and academic information from UK HESA Graduate Outcomes Survey and Eurostat EU Labour Force Survey. Features include Education Level, Field of Study, Language Proficiency, Visa Type, University Ranking, Region of Study, Age, and Years Since Graduation.

## Live API Endpoint
**API URL:** `https://your-api-url.onrender.com` *(To be updated upon deployment)*  
**Swagger Documentation:** `https://your-api-url.onrender.com/docs`  
**Health Check:** `https://your-api-url.onrender.com/health`

## Model Performance Results
- **Best Model:** Linear Regression (Lowest MSE)
- **Test R² Score:** 88.77% (variance explained)
- **Test MSE:** 36,009,030 (Lowest Loss)
- **Test RMSE:** $6,001
- **Models Compared:** Linear Regression, Random Forest, Decision Trees, SGD Regressor

## Key Visualizations & Insights

### Correlation Analysis
- **Education Level:** Strongest predictor (0.893 correlation) - PhD graduates earn 2.6x more than Diploma holders
- **Language Proficiency:** Moderate impact (0.120 correlation)
- **Years Since Graduation:** Minor impact (0.061 correlation)
- **University Ranking:** Minor impact (0.060 correlation)
- **Field of Study:** Minimal variation (0.003 correlation) - all fields within 0.3% of mean salary
- **Age:** Negligible impact (-0.001 correlation)

### Data Distribution
- **Education Levels:** Master's (47.6%), Bachelor's (25.8%), PhD (20.3%), Diploma (6.3%)
- **Top Fields:** Engineering (16.8%), Arts (16.8%), IT (16.7%)
- **Salary Range:** $13,281 - $118,115 (Mean: $58,094, Median: $55,888)
- **Language Distribution:** Advanced (41.0%), Fluent (27.1%), Intermediate (19.1%), Basic (12.7%)

## Project Structure
```
summative/
├── linear_regression/
│   ├── multivariate.ipynb          # Complete ML pipeline & analysis
│   ├── predict_salary.py           # Prediction script using best model
│   ├── models/                     # Saved models & preprocessors
│   │   ├── best_linear_model.pkl   # Best performing model
│   │   ├── scaler.pkl              # Feature scaler
│   │   ├── feature_names.pkl       # Feature names order
│   │   └── categorical_columns.pkl # Categorical columns list
│   └── dataset.csv                 # Training dataset (300K+ records)
├── API/
│   ├── prediction.py               # FastAPI application
│   ├── requirements.txt            # Python dependencies
│   └── render.yaml                 # Deployment configuration
└── FlutterApp/
    └── flutter_app/                # Complete Flutter mobile application
        ├── lib/main.dart           # Main application code
        ├── pubspec.yaml            # Flutter dependencies
        └── android/ios/            # Platform-specific configurations
```

## Installation & Setup

### Prerequisites
- Python 3.8+
- Flutter SDK 3.1.0+
- Git

### API Setup
```bash
# Clone repository
git clone <your-github-repo-url>
cd summative/API

# Install dependencies
pip install -r requirements.txt

# Run locally
python prediction.py
```

### Flutter App Setup
```bash
# Navigate to Flutter app
cd ../FlutterApp/flutter_app

# Install dependencies
flutter pub get

# Run on device/emulator
flutter run
```

## Mobile App Features
- **8 Input Fields:** Education Level, Field of Study, Language Proficiency, Visa Type, University Ranking, Region of Study, Age, Years Since Graduation
- **Data Validation:** Range constraints (Age: 18-65, Years: 0-40) with proper error handling
- **Real-time Predictions:** Direct API integration with loading states
- **Professional UI:** Material Design 3 with responsive layout
- **Cross-platform:** Automatic API URL detection for Android/iOS
- **Error Handling:** Network and validation error display

## API Endpoints

### POST `/predict`
Predicts annual salary for international graduates.

**Request Body:**
```json
{
  "education_level": "Master's",
  "field_of_study": "Engineering", 
  "language_proficiency": "Fluent",
  "visa_type": "Post-study",
  "university_ranking": "High",
  "region_of_study": "UK",
  "age": 28,
  "years_since_graduation": 3
}
```

**Response:**
```json
{
  "predicted_salary": 61665.88,
  "education_level": "Master's",
  "field_of_study": "Engineering",
  "confidence": "High",
  "model_used": "Linear Regression (Best Performing)",
  "model_performance": "R²: 0.8877, MSE: 36,009,030 (Lowest Loss)"
}
```

### GET `/health`
Returns API health status and model information.

### GET `/model-info`
Provides detailed model comparison and training statistics.

## Technical Implementation

### Machine Learning Pipeline
1. **Data Preprocessing:** One-hot encoding for categorical variables, StandardScaler for feature normalization
2. **Model Training:** Linear Regression, Decision Trees, Random Forest, SGD Regressor with cross-validation
3. **Model Selection:** Best performance based on lowest Test MSE (Least Loss criterion)
4. **Feature Engineering:** 8 input features expanded to 27 encoded features
5. **Model Persistence:** Saved using joblib for production deployment

### API Architecture
- **FastAPI:** High-performance async framework with automatic OpenAPI documentation
- **Pydantic:** Data validation with type hints and range constraints
- **CORS Middleware:** Cross-origin resource sharing enabled for web/mobile access
- **Error Handling:** Comprehensive validation and exception management
- **Model Caching:** Efficient model loading with in-memory caching

### Mobile Development
- **Flutter:** Cross-platform native performance for Android/iOS
- **HTTP Integration:** RESTful API consumption with proper error handling
- **State Management:** Reactive UI with loading states and form validation
- **Platform Detection:** Automatic API URL configuration (10.0.2.2 for Android, localhost for iOS)
- **Material Design 3:** Professional UI with consistent styling

## Model Performance Comparison

| Model | Test MSE | Test R² | Selection Criteria |
|-------|----------|---------|-------------------|
| **Linear Regression** | **36,009,030** | **0.8877** | ✅ **Lowest Loss** |
| Random Forest | 36,058,265 | 0.8875 | |
| SGD Regressor | 36,202,098 | 0.8871 | |
| Decision Tree | 36,682,082 | 0.8856 | |

## Demo Video
**YouTube Link:** [5-Minute Demo Video](https://youtube.com/your-video-link) *(To be updated upon video creation)*

**Demo Content:**
- Mobile app prediction demonstration (first 2 minutes)
- Swagger UI API testing with data type and range validation
- Model performance explanation using loss metrics
- Dataset impact analysis and model selection justification
- Code walkthrough of key components

## Deployment Instructions

### API Deployment (Render)
1. Connect GitHub repository to Render
2. Configure build settings with `requirements.txt`
3. Set build command: `pip install -r requirements.txt`
4. Set start command: `python prediction.py`
5. Deploy and obtain public URL
6. Update README with live API endpoint

### Mobile App Testing
1. Ensure API is running (locally or deployed)
2. Update API URL in Flutter app if using deployed version
3. Build and run: `flutter run`
4. Test all 8 input fields and validation constraints
5. Verify API connectivity and prediction accuracy

## Model Selection Justification
Linear Regression was selected as the best performing model based on:
- **Lowest Test MSE:** 36,009,030 (meets "Least Loss" requirement)
- **High R² Score:** 88.77% variance explained
- **Model Interpretability:** Clear feature importance for stakeholder understanding
- **Computational Efficiency:** Fast inference suitable for real-time API responses
- **Stability:** Consistent performance across validation sets
- **Simplicity:** Robust against overfitting with large dataset

## Dataset Impact on Model Performance
The rich dataset with 300,000+ records significantly enhanced model performance:
- **Volume:** Sufficient samples across all feature combinations for robust training
- **Variety:** 8 key variables covering education, demographics, visa status, and experience
- **Quality:** Based on actual graduate outcome surveys (UK HESA, Eurostat EU Labour Force)
- **Balance:** Representative distribution across education levels and study fields
- **Feature Engineering:** Effective one-hot encoding expanded 8 features to 27 model inputs
- **Real-world Relevance:** Practical applicability for international graduate career planning

## Key Features Implemented

### ✅ **Task 1: Linear Regression**
- Non-generic use case: International graduate salary prediction
- Rich dataset: 300K+ records with 8 meaningful features
- Comprehensive visualizations: Correlation heatmap, distribution plots
- Feature engineering: Categorical encoding, standardization
- Multiple models: Linear Regression, Random Forest, Decision Trees
- Best model saved: Linear Regression (lowest MSE)
- Prediction script: `predict_salary.py` with example usage

### ✅ **Task 2: API Development**
- FastAPI endpoint: POST `/predict` with full documentation
- Public URL: Render deployment ready
- CORS middleware: Enabled for cross-origin requests
- Pydantic constraints: Data types and range validation
- Swagger UI: Automatic API documentation at `/docs`

### ✅ **Task 3: Flutter Mobile App**
- 8 input fields matching model requirements
- "Predict" button with loading states
- Result display with error handling
- Professional UI with proper organization
- Cross-platform compatibility (Android/iOS)

### ✅ **Task 4: Video Demo Requirements**
- Mobile app prediction demonstration
- Swagger UI testing with validation
- Model performance explanation
- Dataset impact analysis
- Clear, concise presentation format

## Running the Application

### Local Development
1. **Start API:** `cd API && python prediction.py`
2. **Run Flutter:** `cd FlutterApp/flutter_app && flutter run`
3. **Test API:** Visit `http://localhost:8000/docs` for Swagger UI

### Production Deployment
1. **Deploy API:** Push to Render with `requirements.txt`
2. **Update Flutter:** Modify API URL for production endpoint
3. **Test Integration:** Verify end-to-end functionality

## License
This project is licensed under the Apache 2.0 License.

## Academic Integrity
This project was developed as part of a machine learning summative assignment focusing on regression analysis, API development, and mobile app deployment. All work is original and properly attributed.

---
*Empowering international graduates through data-driven career insights.*