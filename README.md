# ResumeIQ - AI Resume Analyzer and ATS Optimizer

![Flutter](https://img.shields.io/badge/Flutter-3.41.9-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.11.5-blue?logo=dart)
![Gemini AI](https://img.shields.io/badge/Gemini-1.5%20Flash-orange?logo=google)
![License](https://img.shields.io/badge/License-MIT-green)

> Land more interviews, optimize every application

## About
ResumeIQ is an AI-powered Flutter app that analyzes your resume against any job description and gives you an instant ATS match score, missing keywords, and specific improvement suggestions helping you land more interviews.

## Screenshots
Screenshots coming soon

## Features
- Upload PDF resume OR paste resume text
- AI generates ATS match score 0-100 with animated circle
- Shows matching keywords in green
- Shows missing keywords in red and amber
- Numbered improvement suggestions
- Section-by-section analysis for Contact, Summary, Experience, Skills, Education, Formatting
- Save full analysis history locally with Hive
- Share complete report as text
- Beautiful onboarding slides on first launch
- Deep Purple and Silver premium UI with Poppins font
- Undo delete with 7-second toast

## Tech Stack
| Technology | Version |
|---|---|
| Flutter | 3.41.9 |
| Dart | 3.11.5 |
| Gemini AI | 1.5 Flash |
| Hive | Local storage |
| syncfusion_flutter_pdf | PDF text extraction |
| file_picker | File selection |
| share_plus | Export and share |
| google_fonts Poppins | Typography |

## Getting Started
git clone https://github.com/guntimadhu/resume_iq.git
cd resume_iq
flutter pub get

Add your Gemini API key in lib/services/gemini_service.dart

flutter run

## How to Use
1. Tap + to start a new analysis
2. Upload your PDF resume or paste resume text
3. Paste the job description
4. Tap Analyze with AI
5. View your ATS score, matching and missing keywords, and suggestions
6. Save and track your analysis history

## Contributing
Contributions are welcome! Feel free to open issues and pull requests.

## License
This project is licensed under the MIT License.
