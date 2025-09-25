
# Blueprint: Rádio Top FM Flutter App

This document outlines the plan and features for the Rádio Top FM mobile application, built with Flutter.

## 1. Overview

The goal is to create a mobile application for "Rádio Top FM 88.9" that mirrors and enhances the functionality of the existing web player. The app will provide live audio streaming, live video streaming, social media integration, and information about the radio station.

## 2. Core Features

*   **Live Audio Player:** Stream the main radio feed.
*   **Live Video Stream:** View the studio's live video feed.
*   **Dynamic UI:**
    *   A visually engaging background slideshow.
    *   A central player card with all essential controls.
    *   A scrolling ticker with "NO AR" status.
*   **Navigation:**
    *   A side menu (Drawer) for accessing secondary content.
    *   Links to the station's social media profiles.
*   **Informational Content:**
    *   "About Us" section.
    *   "Terms of Use".
    *   "Privacy Policy".
*   **Future-proofing:** A placeholder for a "Send Audio" feature.

## 3. Design and Style

*   **Color Palette:**
    *   Primary (Ruby): `#d80c25`
    *   Accent (Gold): `#ffd700`
    *   Dark variant: `#b5091f`
*   **Typography:** "Poppins" as the main font, sourced from Google Fonts.
*   **Layout:**
    *   The UI will be centered around a "player card" with a blurred background effect.
    *   A stack-based layout will be used to manage the background slideshow and the main content.
    *   The app will be designed to be responsive for various mobile screen sizes.

## 4. Technical Implementation Plan

### Step 1: Project Setup
*   **Dependencies:** Add the following packages to `pubspec.yaml`:
    *   `google_fonts`: For custom typography.
    *   `provider`: For state management.
    *   `just_audio`: For robust audio streaming.
    *   `video_player`: For HLS video playback.
    *   `chewie`: For a ready-to-use video player UI.
    *   `url_launcher`: To open external social media links.
    *   `carousel_slider`: For the background image slideshow.
    *   `marquee`: For the scrolling text ticker.
*   **Assets:**
    *   Create an `assets/images/` directory.
    *   Add placeholder images for the background slides, logo, and banner.
    *   Declare the assets folder in `pubspec.yaml`.

### Step 2: Theming & Main Layout
*   Modify `lib/main.dart` to set up `MaterialApp` with a custom `ThemeData`.
*   Use `ColorScheme.fromSeed` with the primary Ruby color.
*   Integrate `google_fonts` into the `textTheme`.
*   Create the main home screen widget (`lib/screens/home_screen.dart`) with a `Scaffold` containing a `Stack` and a `Drawer`.

### Step 3: Implement Player UI
*   Build the player card UI inside `home_screen.dart`.
*   Use `Image.asset` for the logo.
*   Add `Text` widgets for the radio title and subtitle.
*   Create the control buttons (Play/Pause, Live Video, Send Audio).
*   Implement the social media icon bar.

### Step 4: Audio Streaming
*   Integrate `just_audio`.
*   Initialize an `AudioPlayer` instance.
*   Create a state management solution (using `Provider`) to manage the player's state (playing, paused).
*   Connect the Play/Pause button to the audio player's methods.
*   Use a `StreamBuilder` to update the UI based on the player's state.

### Step 5: Background Slideshow & Ticker
*   Use `carousel_slider` in the `Stack` background to cycle through the background images.
*   Use the `marquee` widget to create the scrolling "NO AR" text at the bottom of the player card.

### Step 6: Video Player & Navigation
*   Create a new screen (`lib/screens/video_screen.dart`) for the video player.
*   Use `video_player` and `chewie` to implement the HLS stream.
*   Navigate to this screen when the "Ao vivo" button is tapped.
*   Set up navigation for the "Send Audio" button to a placeholder screen.

### Step 7: Sidebar (Drawer) & Modals
*   Populate the `Drawer` with links for "Sobre", "Termos", and "Privacidade".
*   Use `showDialog` to display the content for each of these sections in a modal dialog when a link is tapped.
*   Use `url_launcher` for the social media links in the drawer.

