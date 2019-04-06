# Speedrun VIPER iOS app

A speedrun is a play-through (or a recording thereof, namely run) of a video game performed with the intention of completing it as fast as possible within one's own ability. Wikipedia

This iOS app shows the world record speedruns. The goal is to extract the information from http://www.speedrun.com using its api: http://www.speedrun.com/api/v1/games.

The app must:

- Show a list with the games. Showing the game’s logo and the game’s name.

- When is selected a game from the list, the app must open a new screen containing
information of the first run in the api runs list.<br> 
The screen must contain:
  - a button to see the video in an outside app.
  - the name of the player (if there is more than one, you must show only the first player's name).
  - the time of that run.
  - the game's logo and.
  - the game's name.
  
Example gif with iPhone XS Xcode simulator and Slow Animations:
  
<p align="center">
  <img src="https://github.com/crabinvader/VIPER-Swift/blob/master/Readme_Images/gif-big.gif" width="234" height="500"/>
</p>
  
<br><br> 

# Architecture

The architecture used to this app is [VIPER based on my own templates](https://github.com/crabinvader/VIPER-Xcode) this templates are based in a classic VIPER twisted with Clean Swift arch.

<p align="center">
  <img src="https://github.com/crabinvader/VIPER-Xcode/blob/master/viperarch.png" width="500" height="238"/>
</p>

The reason that this architecture has used is because it's an advance architecture that modulates the code and respect the clean code and the best practices.

The app uses VIPER in two scenes. The first one, is the main view WelcomeList and the second, the game run detail GameDetail.

<p align="center">
  <img src="https://github.com/crabinvader/VIPER-Swift/blob/master/Readme_Images/viper-arch-1.png" width="253" height="350"/>
</p>

<br><br> 

# RxSwift

RxSwift is added to VIPER arch to improve the readability and maintainability of code. The app use VIPER in the next situations:

WelcomeList uses RxSwift to control the game list array updates and to show or hide the spinner loader when app calls the API services as well to control if the user have an internet connection.

<p align="center">
  <img src="https://github.com/crabinvader/VIPER-Swift/blob/master/Readme_Images/rxswift-1b.png" width="400" height="354"/>
</p>

GameDatil uses RxSwift to control the game object updates data and to show or hide the spinner loader when app calls the API services as well to control if the user have an internet connection. And one more thing, the video game run button are enabled or disabled with RxSwift depends if the object have or not a valid url.

<p align="center">
  <img src="https://github.com/crabinvader/VIPER-Swift/blob/master/Readme_Images/rxswift-2.png" width="400" height="228"/>
</p>

<br><br> 

# Workers

Classes:

- [Alerts](speedrun/Workers/Alerts.swift): Worker to show Alerts.<br>
- [NoInternetAlert](speedrun/Workers/NoInternetAlert.swift): Custom view to control internet connection. With protocol/delegate patters to inform when the internet connection come back. This class presents it view using autolayout by code with the help of the SnapKit pod.<br>

<p align="center">
  <img src="https://github.com/crabinvader/VIPER-Swift/blob/master/Readme_Images/protocol-delegate.png" width="350" height="130"/>
</p>

- [Modal](speedrun/Workers/Modal.swift): Modal class base to improve present and dismiss nointernet alert or others.<br>
- [SPLoaderSpinner](speedrun/Workers/SPLoaderSpinner.swift): To show custom loading message view.<br>
<br><br>
# Class extensions

Classes:

- [String+ToUIImage](speedrun/Workers/String+ToUIImage.swift): To convert string to url and then to UIImage.<br>
- [String+ToDouble](speedrun/Workers/String+ToDouble.swift): To convert string to Double.<br>
- [Double+StringTime](speedrun/Workers/Double+StringTime.swift): To convert Double to string time format in hours, minutes, and seconds.<br>
<br><br>
# Models

Classes:

- [Game](speedrun/Models/Game.swift): The game list model.<br>
- [GameRun](speedrun/Models/GameRun.swift): Child of game model, this model have the game run detail.<br>
<br><br>
# Networking

Classes:

- [APIservice](speedrun/Network/APIservice.swift): Alamofire request types, this app only implement get method.<br>
- [Constants](speedrun/Network/Constants.swift): To centralized network url and services types.<br>
- [HandleErrors](speedrun/Network/HandleErrors.swift): To implement alert error responses. The app currently call worker Alerts class.<br>
- [SPReachability](speedrun/Network/SPReachability.swift): To control internet connection status.<br>
- [NetworkResponse](speedrun/Network/NetworkResponse.swift): To implement presenter alert response type.<br>
<br><br>
# GRAN CENTRAL DISPATCH

Used to load the game list image asyncronous in uitableview. As well as to reload the table in asyncronous way.<br>
([WelcomeListViewController.swift](speedrun/Scenes/GameList/WelcomeListViewController.swift))

Used gcd groups to call two encadenated api services to solved the case if the game run service only respond with the user id and not with the player's name. In this case the app get the user id and call another service to get the player's name from the user player id. ([GameDetailInteractor.swift](speedrun/Scenes/GameDetail/GameDetailInteractor.swift))
<br><br>
# XCTests

This [app tests](speedrunTests/speedrunTests.swift) all the models and api services that have been used. Even in the two request that uses GCD.
<br><br>
# Swift Guide Style

The app code follows the [Ray Wenderlich Swift Style Guide](https://github.com/raywenderlich/swift-style-guide). 
<br><br>
# Centralized data

The app uses in "support" logical folder a ThemeManager.swift class to support centralized colors and icons. As well as use multilanguage with Localizable.strings to centralized all the text in the app.
<br><br>
# Pods

- [Alamofire](https://github.com/Alamofire/Alamofire): Used to network layer.<br>
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON): Used to parse data from api to models.<br>
- [RxSwift](https://github.com/ReactiveX/RxSwift): Used to implement reactive in a easy way.<br>
- [SnapKit](https://github.com/SnapKit/SnapKit): Used to make layout directly from code in some cases.<br>
<br><br>
# GitFlow

This app is developed using GifFlow, only using tool sourcetree and pull request directly from github.
<br><br>
# Design

The app is not focused in the design or UI/UX, but it respect the iOS native elements as Apple guidelines says and have a correct autolayout in his Xibs and implement the safe areas to correct view in last iPhone models. And, of course, the app don't use storyboards.
<br><br>
# Future lines

What next?

This app and its models are prepared to support Realm Encrypted Database using DBManager class and RealmSwift pod. The random encryption key could be save in keychain with pod KeyChainAccess.

Improves reachability to control the poor internet connection.

<br><br>
# Getting Started

Running in Xcode 10 and iOS 12. Written in Swift 4.2
<br><br>
# Usage

Individuals are welcome to use the code with commercial and open-source projects. 
<br><br>
# Branches

master - The production branch. Clone or fork this repository for the latest copy<br>
develop - The active development branch. Pull requests should be directed to this branch
<br><br>
# License

[The MIT License (MIT)](LICENSE)
 <br><br>
# Contributing

We'd love to see your ideas for improving this repo! Feel free to improve new features in this project. Please, send your pull request to develop brach. All the clean code are welcome in github community. You can also submit a [new GitHub issue](issues/new) if you find bugs. :octocat:

Please make sure to follow our general coding style and add test coverage for new features!
