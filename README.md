# 🥗 NutriDay — Calorie Tracker

> Application iOS de suivi calorique quotidien, développée en SwiftUI.

[![Swift](https://img.shields.io/badge/Swift-5.9-orange?logo=swift&logoColor=white)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5-blue)](https://developer.apple.com/xcode/swiftui/)
[![Platform](https://img.shields.io/badge/Platform-iOS%2016%2B-lightgrey?logo=apple)](https://developer.apple.com)

---

## 📱 Fonctionnalités

- 🍽 Ajout de repas avec nom et calories
- 📊 Barre de progression journalière vs objectif
- 🔥 Streak de jours dans l'objectif
- 📅 Historique de navigation par jour
- 📈 Graphique des 7 derniers jours (Swift Charts)
- ⚙️ Objectif calorique configurable

---

## 🛠 Stack technique

| Catégorie | Technologies |
|---|---|
| Langage | Swift 5.9 |
| UI | SwiftUI |
| Architecture | MVVM |
| Persistance | Core Data |
| Graphiques | Swift Charts |

---

## 🏗 Architecture
```
NutriDay/
├── App/
│   └── NutriDayApp.swift
├── Models/
│   └── NutriDay.xcdatamodeld
├── ViewModels/
│   └── DayViewModel.swift
├── Persistence/
│   ├── PersistenceController.swift
│   └── DayPersistenceModel.swift
└── Views/
    ├── Home/
    │   ├── HomeView.swift
    │   ├── CalorieCardView.swift
    │   ├── StreakView.swift
    │   └── MealsListView.swift
    ├── Meal/
    │   └── AddMealView.swift
    ├── Stats/
    │   └── StatsView.swift
    └── Settings/
        └── SettingsView.swift
```

---

## 🚀 Installation
```bash
git clone https://github.com/Mody9156/NutriDay.git
cd NutriDay
open NutriDay.xcodeproj
```

Lancez avec `⌘R` sur un simulateur iOS 16+.

> Aucune dépendance externe requise.

---

## 👤 Auteur

**Modibo Keïta** — Développeur iOS  
[GitHub](https://github.com/Mody9156) · [LinkedIn](https://www.linkedin.com/in/modibo-keita-337746278)
