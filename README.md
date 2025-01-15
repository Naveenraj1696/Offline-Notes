# Offline-Notes

# Overview

The Offline Files App is an iOS application that allows users to organize and manage their files and photos offline. The app supports folder creation, file management, and various customization features, ensuring a user-friendly and efficient experience.

## Features

### Folder Management
Create,Edit and View folders.\
Assign colors to each folders.\
Mark folders as favorites.\
Sort folders by name or creation date.

### File Management
Add files and photos to folders

### Data Persistence
Core Data integration for saving folder and file structures locally.

### User Interface
Intuitive design using SwiftUI

### Device Compatibility
Supports both iPhone and iPad.\
Optimized for multiple orientations (portrait and landscape).

### Tech Stack
Language: Swift, SwiftUI, UIKit\
Database: Core Data\
Tools: Xcode

### Design Patterns
The app follows the MVVM (Model-View-ViewModel) design pattern for better separation of concerns, scalability, and testability.

## Usage Guide
### Launch the App:  
Open the app on your device or simulator.
### Creating a Folder: 
Tap the menu icon (...) in the top-right corner of the navigation bar. Select "New Folder" from the dropdown menu. Provide a name and optionally choose a color for the folder. Tap "Save" to create the folder. It will appear in the list.
### Marking Folders as Favorites
Long press (or use the context menu) on a folder to open the actions menu. Select "Favourite" from the menu to mark it as a favorite. A star icon will indicate the folder is now a favorite.
### Editing a Folder
Long press (or use the context menu) on a folder.
Select "Edit" to modify the folder name or color.
Tap "Update" to update the changes.
### Sorting Folders
Tap the menu icon (...) in the top-right corner of the navigation bar. Select "Name" or "Creation Date" to sort folders accordingly. The folders list will update to reflect the selected sorting option.
### Adding Files/Photos to a Folder
Tap on the folder you want to open.
Inside the folder, tap the "+" button.
Select files or photos to upload to this folder.
### Using the App in Landscape or Portrait Mode
Rotate your device to switch between portrait and landscape mode.
The app adjusts dynamically to provide an optimal layout for your screen size.
### iPad and iPhone Compatibility
The app supports iPads and iPhone with dynamic layouts, allowing for more columns in the folder grid.
Use the app seamlessly in both portrait and landscape orientations.
