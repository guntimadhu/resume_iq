<div align="center">

# ResumeIQ 📄✨

### *Land more interviews, optimize every application*

![Flutter](https://img.shields.io/badge/Flutter-3.41.9-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.11.5-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Gemini AI](https://img.shields.io/badge/Gemini-1.5%20Flash-4285F4?style=for-the-badge&logo=google&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-9B59B6?style=for-the-badge)

</div>

---

## ✨ About

**ResumeIQ** is an AI-powered resume optimizer built with Flutter and Google Gemini 1.5 Flash. Upload your PDF resume or paste your resume text, add a job description, and get an instant ATS compatibility score with keyword gap analysis, section-by-section feedback, and actionable improvement suggestions — all stored locally on your device.

---

## 📱 Screenshots

> Screenshots coming soon

---

## 🚀 Features

- 📄 **PDF Upload or Text Paste** — Upload your resume as a PDF or paste it directly as text
- 💼 **Job Description Input** — Paste any job posting to match your resume against
- 📊 **ATS Match Score** — Animated circular gauge (0–100) showing how well your resume matches
- ✅ **Matching Keywords** — Green keyword chips showing what you already have covered
- ❌ **Missing Keywords** — Red/amber chips highlighting what you need to add
- 💡 **Improvement Suggestions** — Numbered, actionable tips to boost your ATS score
- 🔍 **Section-by-Section Analysis** — Detailed feedback on Contact, Summary, Experience, Skills, Education, and Formatting
- 💾 **Analysis History** — All past analyses saved locally with Hive — never lose a review
- 🗑️ **Soft Delete + Undo** — 7-second undo toast so you never accidentally lose an analysis
- 📤 **Share Report** — Export the full analysis as formatted text via `share_plus`
- 🎬 **Onboarding Flow** — 4-slide intro with dot indicator (shown only on first launch)
- 🌙 **Deep Purple & Silver** — Elegant, professional color scheme built for job seekers

---

## 🛠️ Tech Stack

| Technology | Version / Package |
|---|---|
| **Flutter** | 3.41.9 |
| **Dart** | 3.11.5 |
| **AI Model** | Google Gemini 1.5 Flash |
| **Local Storage** | `hive` + `hive_flutter` |
| **PDF Parsing** | `syncfusion_flutter_pdf` |
| **File Picker** | `file_picker` |
| **Share** | `share_plus` |
| **Fonts** | `google_fonts` — Poppins |
| **Networking** | `http` |
| **Date Formatting** | `intl` |

---

## ⚙️ Getting Started

### Prerequisites
- Flutter SDK 3.41+ installed
- A [Google AI Studio](https://aistudio.google.com) API key for Gemini

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/your-username/resume_iq.git
cd resume_iq

# 2. Install dependencies
flutter pub get

# 3. Add your Gemini API key
#    Open lib/services/gemini_service.dart and replace the key:
#    const _apiKey = 'YOUR_GEMINI_API_KEY';

# 4. Run the app
flutter run
```

> **Supported targets:** Android, iOS, Web, Windows, macOS, Linux

---

## 📖 How to Use

1. **Launch** the app and complete the one-time onboarding
2. **Tap +** on the Home screen to start a new analysis
3. **Add your resume** — upload a PDF file or paste your resume text directly
4. **Paste the job description** you want to apply for
5. **Tap "Analyze with AI"** — Gemini reviews your resume against the job description
6. **View your results:**
   - ATS match score with animated ring
   - Green chips for matching keywords you already have
   - Red/amber chips for missing keywords to add
   - Numbered improvement suggestions
   - Section-by-section breakdown (Contact, Summary, Experience, Skills, Education, Formatting)
7. **Share the report** via any app using the 📤 button
8. **Analysis saved automatically** — browse your full history on the Home screen

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

Built with ❤️ using Flutter & Google Gemini AI

*ResumeIQ v1.0.0 — AI Resume Optimizer*

</div>
