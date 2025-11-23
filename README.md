# International Graduates Salary Prediction System

## Mission Statement
Empowering international students with data-driven career insights through machine learning salary predictions.
This system bridges critical information gaps in global education decisions, addressing employment uncertainty for international graduates.
My solution enables students to maximize their educational investment returns through predictive analytics.
Providing actionable insights for informed career planning and strategic educational choices.

## Dataset Description
**Source:** [International Graduates Employment Dataset - Kaggle](https://www.kaggle.com/datasets/quackquackrp/international-graduates-employment-dataset)  
**Volume:** 300,000+ anonymized records of international graduates across multiple countries  
**Variety:** Comprehensive dataset combining graduate-outcomes survey data with visa, language, and academic information from authoritative sources including UK HESA Graduate Outcomes Survey and Eurostat EU Labour Force Survey. Features include Education Level, Field of Study, Language Proficiency, Visa Type, University Ranking, Region of Study, Age, and Years Since Graduation.

## Key Visualizations

### 1. Correlation Heatmap - Feature Impact Analysis
![Correlation Heatmap](images/correlation_heatmap.png)

**Training Impact:**
- **Education Level:** Strongest predictor (0.893 correlation) - PhD graduates earn 2.6x more than Diploma holders
- **Language Proficiency:** Moderate impact (0.120 correlation) - Advanced proficiency increases salary potential
- **Years Since Graduation:** Minor impact (0.061 correlation) - Experience factor in predictions
- **University Ranking:** Minor impact (0.060 correlation) - Institution prestige influence

This correlation analysis directly influenced feature selection and model training by identifying Education Level as the dominant predictor, leading to proper feature weighting in the linear regression model.

### 2. Model Performance Comparison - Training Outcome
![Model Performance](images/model_performance_comparison.png)

**Training Results:**
- **Best Model:** Linear Regression (Lowest MSE: 36,009,030)
- **Test R² Score:** 88.77% variance explained
- **Selection Criteria:** Lowest loss with high interpretability
- **Model Comparison:** Outperformed Random Forest, Decision Tree, and SGD Regressor

This visualization shows the direct impact of model selection on training outcomes, with Linear Regression achieving the lowest Mean Squared Error, making it the optimal choice for deployment.

## Live API Endpoint
**API URL:** https://international-graduates-salary-api.onrender.com  
**Swagger Documentation:** https://international-graduates-salary-api.onrender.com/docs  
**Health Check:** https://international-graduates-salary-api.onrender.com/health  
**Status:** LIVE & DEPLOYED

### API Testing with Swagger UI
Access the interactive API documentation at: https://international-graduates-salary-api.onrender.com/docs

**Test the API directly in Swagger UI:**
1. Click on the `/predict` endpoint
2. Click "Try it out"
3. Use this sample input:
```json
{
  "education_level": "Master's",
  "field_of_study": "Engineering",
  "language_proficiency": "Fluent",
  "visa_type": "Work Visa",
  "university_ranking": "High",
  "region_of_study": "UK",
  "age": 28,
  "years_since_graduation": 3
}
```

### API Usage Example (cURL)
```bash
curl -X POST "https://international-graduates-salary-api.onrender.com/predict" \
-H "Content-Type: application/json" \
-d '{
  "education_level": "Master'\''s",
  "field_of_study": "Engineering",
  "language_proficiency": "Fluent",
  "visa_type": "Work Visa",
  "university_ranking": "High",
  "region_of_study": "UK",
  "age": 28,
  "years_since_graduation": 3
}'
```

**Expected Response:**
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

## Demo Video
**YouTube Link:** [5-Minute Demo Video](https://youtu.be/TKC4TgPqrxU)

**Demo Content:**
- Mobile app prediction demonstration
- Swagger UI API testing with validation
- Model performance explanation
- Dataset impact analysis
- Code walkthrough of key components

## Mobile App Instructions

### Prerequisites
- Flutter SDK 3.1.0+
- Android Studio or VS Code with Flutter extension
- Android device/emulator or iOS simulator
- Git for cloning repository

### Step-by-Step Setup & Run

#### 1. Clone Repository
```bash
git clone https://github.com/Chol1000/linear_regression_model.git
cd linear_regression_model
```

#### 2. Navigate to Flutter App
```bash
cd FlutterApp/flutter_app
```

#### 3. Install Dependencies
```bash
flutter pub get
```

#### 4. Verify Flutter Installation
```bash
flutter doctor
```

#### 5. Run on Device/Emulator
```bash
# For Android
flutter run

# For iOS (macOS only)
flutter run -d ios

# For specific device
flutter devices  # List available devices
flutter run -d [device-id]
```

### App Features & Screenshots
![App Input Fields](images/inputs.png) ![Prediction Results](images/results.png)

**Core Features:**
- **8 Input Fields:** Education Level, Field of Study, Language Proficiency, Visa Type, University Ranking, Region of Study, Age, Years Since Graduation
- **Real-time Predictions:** Direct API integration with loading states and error handling
- **Data Validation:** Range constraints (Age: 18-65, Years: 0-40) with user-friendly error messages
- **Cross-platform:** Native performance on both Android and iOS
- **Professional UI:** Material Design 3 with responsive layout and accessibility support

### Troubleshooting Guide

#### Common Issues:
1. **Flutter not recognized:**
   ```bash
   export PATH="$PATH:`pwd`/flutter/bin"  # Add Flutter to PATH
   ```

2. **Android build issues:**
   ```bash
   flutter clean
   flutter pub get
   cd android && ./gradlew clean && cd ..
   flutter run
   ```

3. **iOS build issues (macOS only):**
   ```bash
   cd ios
   pod install
   cd ..
   flutter run
   ```

#### Network Configuration:
- **Android Emulator:** App automatically uses `10.0.2.2` for API access
- **iOS Simulator:** App uses `localhost` for API access
- **Physical Devices:** Uses live API URL: `https://international-graduates-salary-api.onrender.com`

#### API Connection Issues:
- Check internet connection
- Verify API status at: https://international-graduates-salary-api.onrender.com/health
- Test API directly in Swagger UI: https://international-graduates-salary-api.onrender.com/docs

## Project Architecture

### Directory Structure
```
linear_regression_model/
├── API/
│   ├── prediction.py           # FastAPI application with ML model integration
│   ├── requirements.txt        # Python dependencies for deployment
│   └── render.yaml            # Render.com deployment configuration
├── FlutterApp/flutter_app/     # Complete cross-platform mobile application
│   ├── lib/main.dart          # Main application code with UI and API integration
│   ├── pubspec.yaml           # Flutter dependencies and configuration
│   ├── android/               # Android-specific configurations
│   ├── ios/                   # iOS-specific configurations
│   └── test/                  # Widget and unit tests
├── linear_regression/
│   ├── multivariate.ipynb     # Complete ML pipeline, analysis, and visualizations
│   ├── predict_salary.py      # Standalone prediction script
│   ├── models/                # Saved models and preprocessors
│   │   ├── best_linear_model.pkl      # Trained Linear Regression model
│   │   ├── scaler.pkl                 # Feature scaler for normalization
│   │   ├── feature_names.pkl          # Feature names for consistency
│   │   └── categorical_columns.pkl    # Categorical encoding reference
│   └── dataset.csv           # Training dataset (300K+ records)
├── images/                   # Screenshots and visualizations
│   ├── correlation_heatmap.png       # Feature correlation analysis
│   ├── model_performance_comparison.png  # Model comparison results
│   ├── inputs.png                    # Mobile app input interface
│   ├── results.png                   # Mobile app prediction results
│   └── [other visualizations]
└── README.md                 # This comprehensive documentation
```

## Technical Implementation Details

### Machine Learning Pipeline
1. **Data Preprocessing:** One-hot encoding for categorical variables, StandardScaler for numerical features
2. **Feature Engineering:** 8 input features expanded to 27 encoded features for model training
3. **Model Training:** Comparison of Linear Regression, Random Forest, Decision Tree, and SGD Regressor
4. **Model Selection:** Linear Regression chosen based on lowest MSE (36,009,030) and high interpretability
5. **Model Persistence:** Saved using joblib for consistent production deployment

### API Architecture
- **Framework:** FastAPI for high-performance async operations
- **Validation:** Pydantic models with strict data type and range constraints
- **CORS:** Enabled for cross-origin requests from mobile and web clients
- **Documentation:** Automatic OpenAPI/Swagger documentation generation
- **Deployment:** Render.com for reliable cloud hosting with health monitoring

### Mobile Development
- **Framework:** Flutter for cross-platform native performance
- **State Management:** StatefulWidget with reactive UI updates
- **HTTP Integration:** RESTful API consumption with proper error handling
- **Platform Detection:** Automatic API URL configuration for different environments
- **UI/UX:** Material Design 3 with accessibility compliance

## Model Performance Metrics

| Model | Test MSE | Test R² | RMSE | Selection Criteria |
|-------|----------|---------|------|-------------------|
| **Linear Regression** | **36,009,030** | **0.8877** | **$6,001** | **Lowest Loss** |
| Random Forest | 36,058,265 | 0.8875 | $6,005 | Higher complexity |
| SGD Regressor | 36,202,098 | 0.8871 | $6,017 | Less stable |
| Decision Tree | 36,682,082 | 0.8856 | $6,057 | Overfitting risk |

### Model Selection Justification
Linear Regression was selected as the production model based on:
- **Lowest Test MSE:** 36,009,030 (meets "Least Loss" requirement)
- **High Interpretability:** Clear feature importance for stakeholder understanding
- **Computational Efficiency:** Fast inference suitable for real-time API responses
- **Stability:** Consistent performance across validation sets
- **Robustness:** Effective handling of the large dataset without overfitting

## Dataset Impact on Training Outcomes

### Volume Impact (300,000+ Records)
- **Sufficient Samples:** Robust training across all feature combinations
- **Statistical Significance:** Reliable correlation analysis and feature importance
- **Generalization:** Strong model performance on unseen data

### Variety Impact (8 Key Features)
- **Education Level:** Primary predictor with 0.893 correlation
- **Demographic Factors:** Age, years of experience for personalized predictions
- **Academic Credentials:** University ranking and field of study
- **Immigration Status:** Visa type impact on employment outcomes
- **Geographic Factors:** Region of study influence on salary expectations

### Quality Impact (Authoritative Sources)
- **UK HESA Graduate Outcomes Survey:** Verified employment data
- **Eurostat EU Labour Force Survey:** Standardized international metrics
- **Real-world Applicability:** Practical relevance for career planning

## Key Features Implementation Summary

### Task 1: Linear Regression Model
- **Non-generic Use Case:** International graduate salary prediction for career guidance
- **Rich Dataset:** 300K+ records with 8 meaningful features across multiple countries
- **Comprehensive Analysis:** Correlation heatmap, feature importance, model comparison
- **Best Model Selection:** Linear Regression with lowest MSE (36,009,030)
- **Model Persistence:** Saved models with preprocessing pipeline

### Task 2: Production API
- **Live Endpoint:** https://international-graduates-salary-api.onrender.com/predict
- **Swagger Documentation:** Interactive testing at `/docs` endpoint
- **Data Validation:** Pydantic constraints with proper error handling
- **CORS Support:** Cross-origin requests enabled for mobile integration

### Task 3: Mobile Application
- **Cross-platform:** Flutter app for Android and iOS
- **8 Input Fields:** All model features with proper validation
- **Real-time Predictions:** API integration with loading states
- **Professional UI:** Material Design 3 with responsive layout

### Task 4: Documentation & Demo
- **Comprehensive README:** All requirements covered with detailed instructions
- **Video Demo:** 5-minute demonstration covering all components
- **Clear Instructions:** Step-by-step setup and troubleshooting guide

## Getting Started Quick Guide

1. **Test the API:** Visit https://international-graduates-salary-api.onrender.com/docs
2. **Watch the Demo:** https://youtu.be/TKC4TgPqrxU
3. **Run the Mobile App:**
   ```bash
   git clone https://github.com/Chol1000/linear_regression_model.git
   cd linear_regression_model/FlutterApp/flutter_app
   flutter pub get
   flutter run
   ```

---
*Empowering international graduates through data-driven career insights.*