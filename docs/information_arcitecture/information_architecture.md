# Information Architecture (IA) - ReFocus

---

## 1. Sitemap

```text
ReFocus
│
├── Introduction
│   ├── Welcome
│   ├── App Overview
│   └── Get Started
│
├── Authentication
│   ├── Login
│   ├── Sign Up
│   └── Forgot Password
│
├── Home
│   ├── Greeting
│   ├── Daily Focus Goal
│   ├── Focus Session
│   ├── Quick Actions
│   ├── Today's Progress
│   └── Recent Activity
│
├── Statistics
│   ├── Daily Statistics
│   ├── Weekly Statistics
│   ├── Monthly Statistics
│   ├── Screen Time
│   ├── Focus Time
│   ├── Focus Score
│   └── Usage Report
│
├── Challenge
│   ├── Daily Challenge
│   ├── All Challenges
│   ├── Completed Challenges
│   ├── Memory Match
│   ├── Color Focus
│   ├── Math Sprint
│   ├── Pattern Recall
│   └── Reaction Tap
│
├── Focus Mode
│   ├── Select Duration
│   ├── Select Apps to Lock
│   ├── Timer
│   ├── Active Session
│   └── Session Complete
│
├── App Lock
│   ├── Locked Apps
│   ├── Countdown
│   ├── Unlock Rules
│   └── Launch Challenge
│
├── Profile
│   ├── Personal Information
│   ├── Focus Streak
│   ├── Achievements
│   ├── Badges
│   ├── Goals
│   └── Settings
│
└── Settings
    ├── Notifications
    ├── App Permissions
    ├── Theme
    ├── Focus Schedule
    ├── Privacy
    ├── Help Center
    ├── About
    └── Logout

```

---

## 2. Navigation Structure

### Bottom Navigation

* 🏠 **Home**
* 📊 **Statistics**
* 🎮 **Challenge**
* 👤 **Profile**

---

### Navigation Detail per Main Screen

| Main Screen | Sub-Navigation |
| --- | --- |
| **Home** | Start Focus, Today's Goal, Focus Timer, Statistics, Challenge, Recent Activity |
| **Statistics** | Today, Week, Month, Focus Time, Screen Time, Focus Score, Challenge Progress |
| **Challenge** | Daily, All, Completed, Memory Match, Color Focus, Math Sprint, Pattern Recall, Reaction Tap |
| **Profile** | Edit Profile, Achievements, Focus Streak, Goals, Settings, Logout |

---

## 3. Content Hierarchy

### Level 1 (Primary)

* Home
* Statistics
* Challenge
* Profile

### Level 2 (Secondary)

* **Home:** Focus Session, Today's Goal, Recent Activity
* **Statistics:** Focus Time, Screen Time, Focus Score
* **Challenge:** Daily, All, Completed
* **Profile:** Achievement, Settings, Streak

### Level 3 (Detail)

* **Challenge:** Memory Match, Math Sprint, Color Focus, Pattern Recall, Reaction Tap
* **Statistics:** Daily Report, Weekly Report, Monthly Report
* **Settings:** Theme, Notification, Permission, Privacy

---

## 4. Screen Hierarchy

```text
Splash Screen
      │
      ▼
Introduction
      │
      ▼
Login / Sign Up
      │
      ▼
Home
 ┌────┼──────┬──────┐
 ▼    ▼      ▼      ▼
Statistics Challenge Profile Focus Mode

```

---

## 5. Navigation Flow

```text
Home
│
├── Start Focus
│      │
│      ▼
│   Focus Session
│      │
│      ▼
│  App Lock
│      │
│      ▼
│  Challenge
│      │
│      ▼
│ Session Complete
│
├── Statistics
│
├── Challenge
│
└── Profile

```

---

## 6. Information Grouping

* **Productivity:** Focus Session, Focus Goal, Focus Timer, Focus Score
* **Monitoring:** Statistics, Screen Time, Usage Report, Daily Progress
* **Gamification:** Challenge, Achievement, Badge, Streak, Reward
* **Account:** Profile, Settings, Logout

---

## 7. Breadth vs Depth

ReFocus menggunakan arsitektur yang lebih lebar (*breadth*) daripada terlalu dalam (*depth*).

* **Arsitektur Pilihan (Breadth):**
```text
Home
├── Statistics
├── Challenge
├── Focus
└── Profile

```


* **Dihindari (Too Deep):**
```text
Home ──> Menu ──> Challenge ──> Game ──> Detail

```



> **Alasan:** Pendekatan ini dipilih agar pengguna dapat mengakses fitur utama dalam maksimal **2–3 ketukan**, sehingga pengalaman penggunaan menjadi lebih cepat dan efisien.

---

## 📌 IA Diagram (Final)

```text
                           ReFocus
                              │
      ┌──────────────┬─────────┼──────────┬──────────────┐
      │              │         │          │              │
 Introduction   Authentication Home   Statistics    Challenge
      │              │         │          │              │
 Welcome         Login      Focus     Daily Stats   Daily Challenge
 App Overview    Sign Up    Goal      Weekly Stats  All Challenges
 Get Started     Forgot PW  Timer     Monthly Stats Completed
                            Activity  Screen Time   Memory Match
                                      Focus Score   Color Focus
                                                    Math Sprint
                                                    Pattern Recall
                                                    Reaction Tap
                              │
                         Focus Mode
                              │
                     Select Apps
                     Timer
                     Active Session
                     App Lock
                     Session Complete
                              │
                           Profile
                              │
                    Achievement
                    Focus Streak
                    Goals
                    Settings
                              │
                           Settings
                              │
                Notifications
                Theme
                Permissions
                Privacy
                About
                Logout

```



