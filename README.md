# YouTube Clone

This project is a YouTube Clone app built using Flutter and the YouTube Data API v3. The app provides a scrollable list of the most popular videos based on a statically set region code. It features search functionality, previous searches history, and a basic implementation of video playback and interaction.

## Features

### Home Screen
- **Scrollable List of Most Popular Videos**: Displays the most popular videos according to a statically set region code.
- **Cast and Notification Buttons**: Present on the app bar but not yet functional.
- **Search Functionality**: A search icon in the app bar allows users to search for videos. The search results are displayed on a new screen with a scrollable list of videos.
- **Previous Searches**: Maintains a list of previous searches on the main screen. Clicking on a previous search query executes the search again.

### Video Playback Screen
- **Video Player**: Opens at the top of the screen upon clicking a video.
- **Video Information**: Displays the video title, view count, and upload date.
- **Channel Information**: Shows the channel logo, title, subscriber count, and a functioning (but non-persistent) subscribe button.
- **Interaction Buttons**: Like and dislike buttons, clip, and download buttons are present but not functional.
- **Comments Section**: Displays the top comment directly. Clicking the comments section opens a modal bottom sheet showing more comments fetched from the API.
- **Related Videos**: Displays a scrollable list of the most popular videos below the comments section.

### Bottom Navigation Bar
- **Clickable Buttons**: All five buttons in the bottom navigation bar are clickable, but only the home page is fully implemented. Other pages are static and show no content.

## Scope of Improvement

- **Geolocation Integration**: Implement geolocation to dynamically set the region code for fetching the most popular videos.
- **Functionality for Cast and Notification Buttons**: Add functionality to the cast and notification buttons in the app bar.
- **State Persistence for Subscribe Button**: Make the subscribe button persist its state across sessions.
- **Implementation of Like, Dislike, Clip, and Download Buttons**: Add functionality to these interaction buttons.
- **Full Implementation of Other Navigation Tabs**: Complete the implementation of the other tabs in the bottom navigation bar to provide full functionality.
- **Enhanced Search Experience**: Improve the search functionality to include auto-suggestions and better error handling.
- **UI/UX Enhancements**: Improve the overall user interface and user experience with more responsive design elements and animations.

## Installation

To run this project locally, follow these steps:

1. Clone the repository: `git clone https://github.com/your-username/youtube-clone.git`
2. Navigate to the project directory: `cd youtube-clone`
3. Install dependencies: `flutter pub get`
4. Run the app: `flutter run`

## Contributions

Contributions to this project are welcome! If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
