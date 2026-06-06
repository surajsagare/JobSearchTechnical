# JobSearchApp

A production-quality SwiftUI app demonstrating MVVM, async/await, dependency injection, state handling, and testing.

## Features
- Job list with title, company, location, and salary
- Search by title or company
- Job details with description and metadata
- Loading, empty, and error states
- Mock service for offline development
- Unit tests with Swift Testing framework

## Architecture
- SwiftUI views (ContentView, JobDetailView)
- ViewModels (JobListViewModel) using @MainActor and async/await
- Services conforming to `JobServiceProtocol` for DI
- Simple `ContentView` provides dependencies

## Setup
1. Open the project in Xcode 26+
2. Build and run the `JobSearch` target
3. The app uses a mock service by default; no network required

## Testing
- Tests are in `JobSearchTests.swift` using the Swift Testing framework
- Run Product > Test (Command-U)
- Coverage: tests cover service filtering and view model states

## Assumptions
- Salary is a string for simplicity
- Using mock data; swapping to a real API is a matter of creating a new `JobServiceProtocol` implementation and injecting it into `ContentView`

