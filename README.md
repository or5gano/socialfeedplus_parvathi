# socialfeedplus_parvathi

App Overview:  
  
  This is a mock social feed application where users can:
- View a feed of existing (dummy) posts.
- Create new posts with text and optional images.
- Like posts and see the like count update instantly.
- Add comments to any post.
- Persist data across app restarts using local storage.



<br>Features Implemented:
 - Login Screen: Simulated a one time login wherein the user is asked to enter his/her email and password. The characters prior to the @ character in the email ID are extracted using regex and stored as the name and username for the user.
 - Feed Screen: Displays a scrollable list of posts. Like and comment counts update dynamically. Opens the comment section when tapped.
 - Create Post Screen: Create new posts with text and optional image. If opened in “comment mode,” adds a comment to an existing post.
 - Comments Section: View and add comments for a post. Comment count updates automatically. Each comment shows the text(caption), date, and time.
 - Local Persistence: Posts and comments are stored using SharedPreferences. Dummy posts are preloaded and remain saved after adding new posts.
 - Used Riverpod for state management.

<br><br>Libraries Used:
 
  | Library            | Purpose                                           |
|--------------------|---------------------------------------------------|
| flutter_riverpod   | State management (for posts and comments)         |
| shared_preferences | Local data persistence                            |
| intl               | Date and time formatting                          |
| image_picker       | Pick images from the device gallery or camera     |
| permission_handler | Request and manage runtime permissions           |

<br><br>How to run the app:<br>
1. Clone the repository

```bash
   git clone https://github.com/or5gano/socialfeedplus_parvathi.git
   cd socialfeedplus_parvathi
```

2. Install dependencies

```bash
flutter pub get
```


3. Run the app
```bash
flutter run
```

<br><br>Notes about mock AI API:<br>
- The app does not connect to a real API.

- All posts and comments are handled locally using Riverpod state.

- Dummy data is used to simulate posts and comments on first launch.

- Data is persisted in SharedPreferences.

