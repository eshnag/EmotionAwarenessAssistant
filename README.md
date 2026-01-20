# Emotion-Aware Writing Assistant (iOS)

An iOS app that analyzes the emotional tone of text and rewrites it to better convey a target emotion—combining **NLP**, **LLMs**, and a polished **SwiftUI** experience.

Inspired by my background in **poetry and creative writing**, this project explores how AI can support expressive writing rather than replace it.

Demo: https://drive.google.com/file/d/1I_ktMT37sqq01tCg7hMwtWVIzt_VWWsO/view?usp=sharing
---

## Features

- **Emotion Detection**  
  Classifies text emotion with confidence scores using a Hugging Face transformer model.

- **Emotion-Targeted Rewriting**  
  Uses OpenAI to preserve meaning while shifting tone (e.g., neutral → joyful, sad → hopeful).

- **Native SwiftUI UI**  
  Clean editor, loading states, animations, and accessibility-friendly design.

- **Secure Key Management**  
  API keys are injected via `.xcconfig` files and never committed to source control.

---

## Tech Stack

### Frontend
- SwiftUI
- MVVM architecture

### AI / NLP
- Hugging Face Inference API (emotion classification)
- OpenAI Responses API (text rewriting)

---

## API Keys & Setup

This app requires:
- **OpenAI API key** (rewriting)
- **Hugging Face API key** (emotion classification)

### 1. Create a local secrets file

cp EmotionAwareSecrets.xcconfig.example EmotionAwareSecrets.xcconfig

Add your keys:
OPENAI_API_KEY = YOUR_OPENAI_API_KEY_HERE
HF_API_KEY = YOUR_HUGGINGFACE_API_KEY_HERE

### Running the App

Clone the repo

Select an iOS simulator (iOS 17+ recommended)

Run in Xcode


