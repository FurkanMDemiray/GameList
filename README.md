<div align="center">
  <h1>Game List TGY Puanlı Ödev 3</h1>
</div>
 
Welcome to Game List. A simple game list app that shows games.

## Table of Contents
- [Features](#features)
  - [Screenshots](#screenshots)
  - [Tech Stack](#tech-stack)
  - [Architecture](#architecture)
  - [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
- [Usage](#usage)
  - [Games](#games)
  - [Searching](#searching)
  - [Detail](#detail)
  - [Get Suggestion](#get-suggestion)
  - [Screenshots](#screenshots)
- [Known Issues](#known-issues)
- [Improvements](#improvements)

## Features

  **Games:**
- It is a simple application where you can look at the name, release date, rating of the games.
  
 **Searching:**
- You can search for games by their names.
  
 **Detail:**
- You can look details of games.

 **Get Suggestion:**
- You can get suggestion from gemini ai based on your feature selection on the screen.

## Screenshots

| Image 1 | Image 2 | Image 3 |
|:-------:|:-------:|:-------:|
| <img src="https://github.com/FurkanMDemiray/GameList/blob/main/Gifs/1.gif" width="250"> | <img src="https://github.com/FurkanMDemiray/GameList/blob/main/Gifs/2.gif" width="250"> | <img src="https://github.com/FurkanMDemiray/GameList/blob/main/Gifs/3.gif" width="250"> |
| Home | Search | Detail |

| Image 4 | Image 5 |
|:-------:|:-------:|
 <img src="https://github.com/FurkanMDemiray/GameList/blob/main/Gifs/4.gif" width="250"> | <img src="https://github.com/FurkanMDemiray/GameList/blob/main/Gifs/5.gif" width="250"> |
| Favorites | AI |

## Tech Stack

- **Xcode:** Version 15.3
- **Language:** Swift 5.10
- **Minimum iOS Version:** 15.0
- **Dependency Manager:** SPM

## Architecture

![Architecture](https://devnot.com/wp-content/uploads/2015/01/mvvm-pattern.gif)

In developing Game List Project, MVVM (Model-View-View Model) architecture is used.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following:

- Xcode installed

Also, make sure that these dependencies are added in your project's target:

- [SDWebImage](https://github.com/SDWebImage/SDWebImage):  SDWebImage is a lightweight and pure Swift library for downloading and caching images from the web.
- [GenerativeAI](https://github.com/google-gemini/generative-ai-swift): The Google AI SDK for Swift enables developers to use Google's state-of-the-art generative AI models (like Gemini) to build AI-powered features and applications.

## Usage

###  Listing - Games

1. Open the app on your simulator or device.
2. Browse and analyse the games.
3. Navigate to game detail by tapping on the relevant game image.

 <p align="left">
  <img src="https://github.com/FurkanMDemiray/GameList/blob/main/Gifs/1.gif" alt="Listing" width="200" height="400">
</p>

---

### Game Searching 

1. Search games by its name.

   <p align="left">
  <img src="https://github.com/FurkanMDemiray/GameList/blob/main/Gifs/2.gif" alt="Listing" width="200" height="400">
</p>

---

## Detail

1. Click to game image to see the detail of the game.

<p align="left">
  <img src="https://github.com/FurkanMDemiray/GameList/blob/main/Gifs/3.gif" alt="Listing" width="200" height="400">
</p>

## Favorites

1. Click to heart image on the detail screen to add game to your favorites.

<p align="left">
  <img src="https://github.com/FurkanMDemiray/GameList/blob/main/Gifs/4.gif" alt="Listing" width="200" height="400">
</p>

## Suggestion From AI

1. Navigate to ai screen select some features and after that click to the get suggestion button to get suggestions.

<p align="left">
  <img src="https://github.com/FurkanMDemiray/GameList/blob/main/Gifs/5.gif" alt="Listing" width="200" height="400">
</p>

## Known Issues
- At first, if we scroll the table view fast enough and search for games, the search results also show other games. This disappears after waiting for the data to load.


## Improvements
- More content can be added to the detail view.
- Localization for other languages can be added to be able to reach more user.
