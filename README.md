# socialfeedplus_parvathi

App Overview:  
  
  This is a mock social feed application where users can:
- View a feed of existing (dummy) posts.
- Create new posts with text and optional images.
- Like posts and see the like count update instantly.
- Add comments to any post.
- Persist data across app restarts using local storage.



Features Implemented:
 - Login Screen: Simulated a one time login wherein the user is asked to enter his/her email and password. The characters prior to the @ character in the email ID are extracted using regex and stored as the name and username for the user.
 - Feed Screen: Displays a scrollable list of posts. Like and comment counts update dynamically. Opens the comment section when tapped.
 - Create Post Screen: Create new posts with text and optional image. If opened in “comment mode,” adds a comment to an existing post.
 - Comments Section: View and add comments for a post. Comment count updates automatically. Each comment shows the text(caption), date, and time.
 - Local Persistence: Posts and comments are stored using SharedPreferences. Dummy posts are preloaded and remain saved after adding new posts.
 - Used Riverpod for state management.




