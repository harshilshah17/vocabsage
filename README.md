# VocabSage

A private CS vocabulary and knowledge app for developers. VocabSage helps you capture, organize, and recall technical concepts in your own words. Built with SwiftUI and Core Data, optimized for fast recall and search.

**Status:** 🚀 Preparing for App Store submission

## Overview

VocabSage is an offline-first iOS/macOS application designed for developers who want to build their own personal knowledge base of technical concepts. Each entry represents a concept written in your own words, making it easier to recall and understand complex technical topics.

## Features

### 📚 Concept Management
- **Create & Edit Concepts**: Add technical concepts with structured information including:
  - Title and summary
  - Mental model (how you think about the concept)
  - Why it exists (the problem it solves)
  - Trade-offs (pros and cons)
  - Gotchas (common pitfalls and things to watch out for)

### 🔍 Fast Search
- **Instant Search**: Quickly find concepts by title or summary
- **Real-time Filtering**: See results as you type
- **Optimized for Speed**: Built for quick retrieval and recall

### 📱 Cross-Platform Support
- **iOS**: Native iOS app with full feature parity
- **macOS**: Desktop version with split-view support
- **Universal**: Single codebase, optimized for both platforms

### 🎨 Minimal, Focused Design
- **Dark Mode Friendly**: Automatically adapts to system appearance
- **Large, Readable Text**: Optimized for reading and comprehension
- **Clean UI**: Minimal interface focused on content, not clutter
- **No Folders, No Heavy Tagging**: Simple, straightforward organization

### 💾 Offline-First Architecture
- **Core Data**: Local-only storage, no cloud sync required
- **Fast Performance**: Instant access to your concepts
- **Privacy-Focused**: All data stays on your device

### ✨ Additional Features
- **Review Tracking**: Mark concepts as reviewed with timestamps
- **Settings Screen**: Configure app behavior and manage data
- **Privacy First**: No account, no tracking, no analytics - all data stored locally

## Technical Stack

- **SwiftUI**: Modern declarative UI framework
- **Core Data**: Local persistence layer
- **MVVM Architecture**: Clean separation of concerns
- **Combine**: Reactive programming for state management

## Project Structure

```
vocabsage/
├── Views/              # SwiftUI views
│   ├── ConceptListView.swift
│   ├── ConceptDetailView.swift
│   ├── AddEditConceptView.swift
│   ├── LoadingView.swift
│   └── SettingsView.swift
├── ViewModels/         # MVVM view models
│   ├── ConceptListViewModel.swift
│   ├── ConceptDetailViewModel.swift
│   └── AddEditConceptViewModel.swift
├── Helpers/            # Utility functions
│   └── MockData.swift
├── Persistence.swift   # Core Data stack
└── vocabsageApp.swift # App entry point
```

## Getting Started

### Requirements
- Xcode 15.0 or later
- iOS 17.0+ / macOS 14.0+
- Swift 5.9+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/harshilshah17/vocabsage.git
```

2. Open the project in Xcode:
```bash
cd vocabsage
open vocabsage.xcodeproj
```

3. Build and run the app in Xcode

### Sample Data

The app includes example concepts for preview and testing (clearly marked with "[Example]" prefix):
- [Example] Consistent Hashing
- [Example] Backpressure
- [Example] Idempotency
- [Example] Eventual Consistency

Example data is automatically seeded on first launch if the database is empty. You can disable or remove example concepts from Settings.

## App Store Submission

This app is currently being prepared for submission to the App Store. The app follows Apple's Human Interface Guidelines and is designed to provide a focused, distraction-free experience for developers building their technical knowledge base.

## Privacy

VocabSage is designed with privacy in mind:
- **No account required**: Use the app without signing up
- **No tracking**: We don't track your usage or behavior
- **No analytics**: No data collection or analytics services
- **Local storage only**: All your concepts are stored locally on your device
- **Privacy Nutrition Label**: Nearly empty - we collect nothing

## Future Enhancements

- **Export/Import**: Backup and restore your concepts
- **Rich Text Support**: Enhanced formatting options
- **Concept Linking**: Link related concepts together

## License

This project is private and not currently open for contributions.

## Contact

For questions or feedback, please open an issue on GitHub.

---

**Built with ❤️ for developers who value knowledge organization and quick recall.**

