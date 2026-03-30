# Kai - AI Chatbot

עוזר AI חכם מבוסס DialoGPT-medium, זמין כאתר React ואפליקציית Flutter לאנדרואיד.

---

## מבנה הפרויקט

```
kai/
├── web/              # אתר React
└── flutter_app/      # אפליקציית Flutter (Android APK)
```

---

## אתר React (`web/`)

### הרצה מקומית

```bash
cd web
cp .env.example .env
# ערוך את .env והכנס את ה-HF token שלך
npm install
npm start
```

### בנייה לפרודקשן

```bash
npm run build
# תיקיית build/ מוכנה להעלאה לשרת
```

### הגדרות

| משתנה | תיאור |
|-------|-------|
| `REACT_APP_HF_TOKEN` | Hugging Face API token (אופציונלי) |

---

## אפליקציית Flutter (`flutter_app/`)

### דרישות

- Flutter SDK 3.10+
- Android SDK (minSdk 21)

### הרצה

```bash
cd flutter_app
flutter pub get
flutter run
```

### בנייה של APK

```bash
flutter build apk --release
# ה-APK נמצא ב: build/app/outputs/flutter-apk/app-release.apk
```

### העברת APK לאתר

```bash
cp build/app/outputs/flutter-apk/app-release.apk ../web/public/kai.apk
```

---

## Hugging Face API

המודל: [microsoft/DialoGPT-medium](https://huggingface.co/microsoft/DialoGPT-medium)

- **ללא token**: rate limit נמוך (כ-30 בקשות/שעה)
- **עם token חינמי**: rate limit גבוה יותר

קבל token ב: https://huggingface.co/settings/tokens

---

## תכונות

- עיצוב כהה ומודרני
- אנימציית typing indicator
- היסטוריית שיחה
- שמירת API token (Flutter)
- כפתור הורדת APK (אתר)
- תמיכה ב-RTL (עברית)
