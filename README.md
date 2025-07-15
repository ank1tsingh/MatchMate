# MatchMate - iOS Matrimonial App

A modern iOS matrimonial app built with **SwiftUI** and **MVVM Clean Architecture**, featuring profile cards with accept/decline functionality and full offline support.
## ✨ Features

- **SwiftUI Profile Cards** - Cards with user photos and info
- **Accept/Decline Actions** - Button with smooth animations
- **API Integration** - Fetches profiles from RandomUser API
- **Offline Mode** - Full functionality without internet connection
- **Reactive Programming** - Combine framework for data flow
- **Image Caching** - SDWebImage for efficient image loading
- **Core Data** - Local persistence for match decisions

## 🏗️ Architecture

**MVVM Clean Architecture** with proper separation of concerns:

- **Presentation** - SwiftUI Views & ViewModels
- **Domain** - Use Cases & Business Logic  
- **Data** - Repository, API Service & Core Data

## 🛠️ Tech Stack

- **SwiftUI** - Modern declarative UI
- **Combine** - Reactive programming
- **Core Data** - Local persistence
- **SDWebImage** - Image loading & caching
- **URLSession** - Network requests

## 📱 Screenshots
<p align="center">
  <img src="https://github.com/user-attachments/assets/5c065c23-8e1d-41d9-b890-cefa1b6c56e6" alt="Screenshot 1" width="300"/>
  &nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/a8abaf8b-e8ab-441e-8854-907afa556a53" alt="Screenshot 2" width="300"/>
</p>

## 🚀 Getting Started

### Prerequisites
- Xcode 14.0+
- iOS 15.6+
- Swift 5.7+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/MatchMate.git
   cd MatchMate
   ```

2. **Open in Xcode**
   ```bash
   open MatchMate.xcodeproj
   ```

3. **Build and Run**
   - Select your target device
   - Press `⌘ + R`

## 📂 Project Structure

```
MatchMate/
├── App/                    # App entry point
├── Core/
│   ├── Data/              # Repository, API, Core Data
│   ├── Domain/            # Use Cases, Entities
│   └── Presentation/      # Views, ViewModels
├── Utilities/             # Extensions, Constants
└── Resources/             # Assets, Core Data model
```

## 🔧 Key Features

### API Integration
- Fetches user data from `https://randomuser.me/api/?results=10`
- URLSession with Combine for reactive networking

### Offline Support
- Core Data for local storage
- Cached data displayed when offline
- Accept/decline works without internet

### Clean Architecture
- MVVM pattern with SwiftUI
- Repository pattern for data management
- Use cases for business logic separation


## 🔄 Offline Mode

**Test offline functionality:**
  - Turn off WiFi/Cellular
  - App continues to work with cached data
  - Accept/decline saves locally


