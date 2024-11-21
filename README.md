
# Movwe

Currently an alpha prototype... More UI improvements and features to come

Movwe is a movie app used to help groups of friends decide which movie to watch. Users form "lobbies", and add their favorite movies to the lobby's movie list. After finalizing the movie list, users can then personally rank the movies in order of preference. After each user in a lobby has ranked the movies, a "final rankings" list will be generated to determine which movie the group should watch.

## Authors

- [@GriffinMcCool](https://github.com/GriffinMcCool)
- [@vibha-h](https://github.com/vibha-h)
- [@Mirla-03](https://github.com/Mirla03)

## Design Changes

IMPORTANT: The app currently only works on a Windows emulator. We planned (and still do plan) to have the app working for the Android emulator, but we are dealing with issues at the moment. For some reason, our database dependencies are not allowing the app to be run on the Android emulator, so it is currently only a desktop app. Thus, some of the design is more suited for a desktop app for the alpha prototype, which we still plan to change. For example, our taskbar is currently at the top of the screen instead of the bottom. Once we figure out this issue with the Android emulator, the app will be reconfigured.

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
    8. IMPORTANT: Select Windows (app is currently only supported on Windows emulator)
    9. The application will open in a separate window


## Key Tasks in Demo (DEV 3)

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
- Create lobby
    - Create a lobby with a unique ID for your friends to join
- Join lobby
    - Use a friend's lobby ID to join their lobby
- Add movie to lobby
    - When viewing a movie's details or on the lobby page, add movies to a lobby's movie list
- Rank moives
    - Order the list of movies in a specific lobby by preference
- TODO User Profiles & Statistics


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

### Add Movie to Lobby

    1. Create or join a lobby (see "Create lobby" or "Join Lobby")
    2. View a movie's details (see "View Movie Details")
    3. Press the "+" icon
    4. Select the desired lobby to add the movie to

    Note: You must be a member of at least one lobby to add a movie

### Rank Movies

    1. Create or join a lobby (see "Create lobby" or "Join Lobby")
    2. Ensure at least one movie has been added to the lobby (see "Add Movie to Lobby")
    3. At home screen, press the "Lobby" button
    4. At the lobby screen, press the dropdown and select which lobby you would like to view
    5. Press the "Rank Movies" button
    6. Use the sliders on the right to order the movies by preference (Top is favorite)
    7. Press the green check mark to submit rankings

