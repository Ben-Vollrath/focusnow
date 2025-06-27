# 📱 FocusNow – Gamify Your Study Time

[![Google Play](https://img.shields.io/badge/Google_Play-FocusNow-green?style=flat&logo=google-play)](https://play.google.com/store/apps/details?id=io.vollrath.focusnow)

**FocusNow** is a gamified productivity app that turns studying into a rewarding and social experience. Built with Flutter and backed by Supabase, it helps users stay motivated through challenges, XP progression, and group accountability.

---

## 🎯 Key Features

- ⏱️ Multiple study modes (Pomodoro, 52:17, 90:30, Endless)
- 🧠 XP system with leveling and streaks
- ✅ Daily & weekly challenges
- 🏆 Global and group-based leaderboards
- 👥 Study groups with shared progress
- 📊 Personalized study analytics

---

## 🛠 Tech Stack

| Layer         | Technology                                |
|--------------|--------------------------------------------|
| **Frontend**  | Flutter, Dart, BLoC (state management)     |
| **Backend**   | Supabase (PostgreSQL, Auth, Edge Functions)|
| **Auth**      | Supabase Auth (Magic Links, OAuth)        |
| **CI/CD**     | GitHub Actions, Play Developer API         |
| **Testing**   | `bloc_test`, `Deno Tests`     |

---

## 🚀 Deployment Architecture

The deployment process is fully automated:

- On push to the prod branch:
  - Flutter app builds are generated and published to Google Play via the Developer API
  - Supabase schema changes and edge functions are applied 
- Separate environments for development and production ensure safe rollout

---

## 💡 Technical Challenges

### 1. **State Management with BLoC**
Managing asynchronous study sessions, challenge tracking, and offline syncing required a robust and modular BLoC architecture. Multiple state layers interact smoothly without UI stutter or logic conflicts.

### 2. **Gamification Layer**
The leveling and challenge systems were designed to reward consistency while avoiding incentive abuse. This included dynamic XP curves, streak logic, and Supabase-based XP calculations.

### 3. **Leaderboard Scaling**
Real-time leaderboard updates across groups and global rankings posed scaling challenges under Supabase’s row-level security. Indexing and efficient policy writing were key to maintaining performance.

### 4. **CI/CD Integration**
A fully integrated pipeline (GitHub Actions + Play Console API + Supabase CLI) ensures that every commit can deploy:
- Flutter patches to production
- Database and function updates to Supabase
This eliminates manual deployment errors and speeds up iteration.

---

## 📲 Available On

**Google Play Store**  
[https://play.google.com/store/apps/details?id=io.vollrath.focusnow](https://play.google.com/store/apps/details?id=io.vollrath.focusnow)

