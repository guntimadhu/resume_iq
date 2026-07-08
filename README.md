# ResumeIQ 📄✨
### Land more interviews, optimize every application

![Flutter](https://img.shields.io/badge/Flutter-3.41.9-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.11.5-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Gemini AI](https://img.shields.io/badge/Gemini_AI-1.5_Flash-8E24AA?style=for-the-badge&logo=google&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-silver?style=for-the-badge)

---

## ✨ About

**ResumeIQ** is an AI-powered resume analyzer that helps you beat Applicant Tracking Systems (ATS) and land more interviews. Upload your resume, paste a job description, and get an instant match score with actionable insights — all powered by Google Gemini AI, running entirely on your device.

---

## 📱 Screenshots

> Screenshots coming soon

---

## 🚀 Features

- 📤 **Upload PDF resume** or paste resume text directly
- 📋 **Paste any job description** to analyze against
- 🎯 **ATS Match Score** (0–100) with animated circle gauge
- ✅ **Matching keywords** shown as green chips
- ❌ **Missing keywords** shown as red/amber chips
- 💡 **Numbered improvement suggestions** from Gemini AI
- 🔍 **Section-by-section analysis** — Contact, Summary, Experience, Skills, Education, Formatting
- 💾 **Full analysis history** saved locally with Hive
- 📤 **Share complete report** as text
- 🎓 **Onboarding slides** on first launch
- ✨ **Splash screen** with micro-animations
- ↩️ **Undo delete** with 7-second toast notification
- 🌙 **Dark / Light theme** toggle

---

## 🛠️ Tech Stack

| Technology | Version | Purpose |
|---|---|---|
| Flutter | 3.41.9 | Cross-platform UI framework |
| Dart | 3.11.5 | Programming language |
| Gemini AI | 1.5 Flash | ATS scoring & keyword analysis |
| Hive | 2.2.3 | Local database / history |
| syncfusion_flutter_pdf | 27.2.4 | PDF text extraction |
| file_picker | 8.1.4 | PDF file selection |
| share_plus | 10.1.2 | Share analysis report |
| google_fonts (Poppins) | 6.2.1 | Typography |

---

## ⚙️ Getting Started

### Prerequisites
- Flutter 3.41.9+
- Dart 3.11.5+
- A [Gemini API key](https://aistudio.google.com/app/apikey) (free)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/guntimadhu999-glitch/resume_iq.git
cd resume_iq

# 2. Install dependencies
flutter pub get

# 3. Run with your Gemini API key
flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
```

---

## 📖 How to Use

1. **Launch the app** — complete the onboarding slides on first launch
2. **Tap "New Analysis"** on the home screen
3. **Upload your resume** — pick a PDF file or paste your resume text
4. **Paste the job description** of the role you're applying for
5. **Tap Analyze** — Gemini AI processes your resume in seconds
6. **View your results** — ATS score, matching & missing keywords, suggestions
7. **Save the analysis** — stored in history for future reference
8. **Share the report** — send the full analysis as text to yourself or a mentor

---

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License.

---

<p align="center">Built with 💜 using Flutter & Gemini AI</p>
