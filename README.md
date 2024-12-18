
# Movwe
Movwe is a movie app used to help groups of friends decide which movie to watch. Users form "lobbies", and add their favorite movies to the lobby's movie list. After finalizing the movie list, users can then personally rank the movies in order of preference. After each user in a lobby has ranked the movies, a "final rankings" list will be generated to determine which movie the group should watch.

## Authors

- [@GriffinMcCool](https://github.com/GriffinMcCool)
- [@vibha-h](https://github.com/vibha-h)
- [@Mirla-03](https://github.com/Mirla03)

## Running the App

Prerequisites:

- Windows machine
- VSCode with Flutter extension
- Virtualization enabled on device

Steps:

    1. Download .zip file (if you're reading this, you've likely already done so)
    2. Unzip folder to desired location
    3. Open folder in VSCode
    4. In VSCode terminal, navigate to ../Movwe
    5. In VSCode terminal run 'flutter clean'
    6. Run 'flutter pub get'
    7. Run 'flutter run'
    8. IMPORTANT: Select Windows emulator
    9. The application will open in a separate window


## Key Tasks in Demo (DEV 4)

- Create account
    - Create an account with username and password to login with 
- Login
    - Log in with a unique existing account
- Browse movies
    - View list of available movies
- Search movies
    - Search available movies by title
- View movie details
    - Select a movie to view title, description, ratings, etc.
- View user profiles _& statistics_
    - Username, _most liked genres_, and all previous lobbies joined listed
- Create lobby
    - Create a lobby with a unique ID for your friends to join
- Join lobby
    - Use a friend's lobby ID to join their lobby
- View lobby
    - View the name and movie list of a lobby
- Leave lobby
    - Leave a specific lobby and remove it from the user's lobby list
- Add movie to lobby
    - When viewing a movie's details or on the lobby page, add movies to a lobby's movie list
- Remove movie from lobby
    - When on the lobby page, a movie can be removed from the movie list by any lobby member
- Finalize lobby
    - The owner of the lobby can "finalize" the lobby, preventing new users from joining and adding movies
- Delete lobby
    - The owner of the lobby can delete the lobby, removing it from all members' lobby lists 
- Rank moives
    - Order the list of movies in a specific lobby by preference
- Create custom movie
    - Add movies that are not already included on the platform
- Pick a random movie
    - Select a random movie from the lobby's list of movies


### Create Account

    1. Click "Create Account" button on login screen
    2. Enter username, password, and password confirmation
    3. Click "Create Account"
    
    Note: Usernames must be unique

### Login

    1. Create an account (see "Create Account")
    2. On login screen, enter matching username and password
    3. Click "login" button

    Note: Account must be created before logging in

### Browse Movies

    1. Login with a valid account (see "Login")
    2. The user will be taken to the home page, where available movies can be browsed

### Search Movies

    1. Login with a valid account (see "Login")
    2. At home screen, click the magnifying glass icon
    3. Enter movie title into search box

### View Movie Details

    1. Login with a valid account (see "Login")
    2. Either browse or search for a movie (See "Browse Movies" and "Search Movies")
    3. Click on the desired movie to view the movie details

### View User Profile

    1. Login with a valid account (see "Login")
    2. Click the "profile" button

### Create Lobby

    1. Login with a valid account (see "Login")
    2. At home screen, press the "Create/Join Lobby" button
    3. Press "Create New Lobby" button

    Note: Lobby ID will be automatically assigned upon creation and displayed

### Join Lobby

    1. Login with a valid account (see "Login")
    2. At home screen, press the "Create/Join Lobby" button
    3. In the "Enter Join Code" text box, enter a valid join code
    4. Press "Join Lobby" button

### View Lobby

    1. Join a lobby (see "Join Lobby")
    2. At home screen, press the "profile" or "lobby" button
    3. Select the desired lobby
    
### Leave Lobby

    1. View a lobby (see "View Lobby")
    2. Select "Leave Lobby" under the lobby selector dropdown
    3. On the confirmation page, select "Yes"

    Note: You can't leave a lobby that has been finalized. Please ask the lobby owner to open the lobby if you'd like to leave.

### Add Movie to Lobby

    1. Create or join a lobby (see "Create lobby" or "Join Lobby")
    2. View a movie's details (see "View Movie Details")
    3. Press the "+" icon
    4. Select the desired lobby to add the movie to

    Note: You must be a member of at least one lobby to add a movie

### Remove Movie From Lobby

    1. Add a movie to a lobby (see "Add Movie to Lobby")
    2. View the lobby (see "View Lobby")
    3. Click the '-' icon in line with the movie you'd like to remove

    Note: Movies can't be removed from a finalized lobby.

### Finalize Lobby

    1. Create a lobby (see "Create Lobby")
    2. View the lobby (see "View Lobby")
    3. Select "Finalize Lobby" at the bottom of the screen

    Note: This action can only be performed by the lobby's owner. Users will no longer be able to join/leave the lobby or add/delete movies.

### Delete Lobby

    1. Create a lobby (see "Create Lobby")
    2. View the lobby (see "View Lobby")
    3. Select "Delete Lobby" under the lobby selector dropdown
    4. On the confirmation page, select "Yes"

    Note: This action can only be performed by the lobby's owner

## Create a Custom Movie

    1. Login with a valid account (see "Login")
    2. At home screen, press the "+" icon 
    3. Fill out the form with title, description, genre, content rating, and IMDb Rating
    4. Press the "Submit" button

### Rank Movies

    1. Create or join a lobby (see "Create lobby" or "Join Lobby")
    2. Ensure at least one movie has been added to the lobby (see "Add Movie to Lobby")
    3. View the lobby (see "View Lobby")
    4. Ensure the lobby has been finalized by the owner (see "Finalize Lobby")
    5. Press the "Rank Movies" button
    6. Use the sliders on the right to order the movies by preference (Top is favorite)
    7. Press the check mark to submit rankings

    Note: The lobby must be finalized by the host for this function.

### Pick a Random Movie

    1. Create or join a lobby (see "Create lobby" or "Join Lobby")
    2. Ensure at least one movie has been added to the lobby (see "Add Movie to Lobby")
    3. View the lobby (see "View Lobby")
    4. Ensure the lobby has been finalized by the owner (see "Finalize Lobby")
    5. Press "Pick Random Winner" button

    Note: The lobby must be finalized by the host for this function.

## Formal Description: MVP

### MVP
- Login: Users can create and log into profiles that save all their data and settings.

- Movie select:  While browsing listed movies, users can click an "Add Movie" button to select a movie and assign it to a lobby for ranking!

- (Not MVP) Movie details: Clicking on a movie reveals detailed information, including the title, description, genre, content rating, and IMDb rating.

- Group Ranking: In a lobby, users collaboratively rank movies. Once the host finalizes the process, the winner is determined based on the average of all users' rankings.

- (Not MVP) User Profile: Displays a user’s top genres and lists previous lobbies instead of individual movie ratings.

- Add a Movie: On the Home page, users can click an "Add Movie" button to input detailed information, exactly like the data shown in the Movie Details view.

- Search function:  Users can search for movies not displayed on the Home page, including those available through the API or added manually by the user.

- Enter Code: Users can join a lobby using a code generated when the host creates the lobby.

- Lobby Homepage:  When entering a lobby, users can view all movies added to that lobby and add more movies directly from this screen.

- Personal Rankings: Users rank movies individually, contributing to the final results calculated as the average of all the participant's rankings.

### Changes of MVP: 

The majority of our project remains unchanged, however during the course of this semester, we had run into some bugs and stylistic changes. The main issue we ran into during this project is the web app design change. Originally, we had hoped to make this an android-based app. However, after the considerable effort put in to solve this problem, we decided to prioritize implementing the core functionality and creating a well-designed web app.
The second change was the subsituition of user's ratings for previous lobbies. We felt that listing past lobbies would be more valuable and appreciated by users. This was more of a stylistic choice as user's rating could have been implemented instead and was ultimately set aside. 
The last slight change are due to the bugs encountered with QR scanning functionality. While we are currently continuing to resolve these issues, the join code feature is fully functional. This ensures that the app's core functionality is unaffected even if the QR scanner isn't working perfectly.
