![Introduction](https://github.com/melissahe/TestInk/blob/qa/Gifs/Screen%20Shot%202018-04-06%20at%2012.00.41%20PM.png)

## TestInk is an app that allows users to preview tattos using augmented reality

## What's the Problem?
There are 45,000,000 Americans who have at least one tattoo abut there is a lack of technology that specifically aims to serve and cultivate the tattoo community at large.

## TestInk's Solution
- Preview designs on your skin using AR Technology!
- Discover and share designs with the community.
- Accessible to ANY artistic level!


## App Flow
|TODO|TODO|
|:-------------:|:-------------:|
|<img src="TODO" width="358" height="626">|<img src="TODO" width="358" height="626">|

## Future Updates
- Network with other tattoo artists and use their designs
- Use photo sharing services to import other tattoo designs
- Try on tattoos without needing stickers using Core ML to recognize a drawing as the image on you skin

## Technologies Used
- Firebase as a backend service
- ARKit Technology
- Core Image to add filtering functionality
- Core Graphics for cropping functionality


## Requirements
- iOS 8.0+ / Mac OS X 10.11+ / tvOS 9.0+
- Xcode 9.3+
- iOS 11.3
- Swift 4.0+
- ARKit Compatible Device (Apple A9 processor or higher)

## Installation

### CocoaPods
CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:

`$ sudo gem install cocoapods`

### Pods
- [Firebase](https://firebase.google.com)
  - Firebase/Core
  - Firebase/Auth
  - Firebase/Database
  -Firebase/Storage
- [SnapKit](http://snapkit.io/docs)
- [Toucan](https://github.com/gavinbunney/Toucan)

### How to Install Pods
To integrate these pods into your Xcode project using CocoaPods, specify it in your Podfile:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'SnapKit'
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
    pod 'Firebase/Storage'
    pod 'Toucan'
end
```

Then, run the following command in Terminal:

`$ pod install`

## Credits - Team Nosleep
- **Project Manager**: [Iram Fattah](https://github.com/ifattah94/)
- **Scrum Master/Co-Tech Lead**: [Melissa He](https://github.com/melissahe/)
- **Tech Lead**: [Nicole Souvenir](https://github.com/ncsouvenir/)
- **Design Lead**: [Meseret Gebru](https://github.com/meseretgebru/)
- **Demo Lead**: [Izza Nadeem](https://github.com/izzanadeem/)
