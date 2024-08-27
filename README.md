# Modu.lite

Modu.lite is an app that embraces the trend of healthy phone use, reducing screen time, and minimizing overstimulation from social media, aligning with the concept of "dumbifying" smartphones. With Modu.lite, change the way you use and perceive your phone, and make the most out of life.

## Table of Contents

- [About the Project](#about-the-project)
- [Motivation](#motivation)
- [Key Features](#key-features)
- [Screenshots](#screenshots)
- [Technologies and Tools](#technologies-and-tools)
- [Learnings and Challenges](#learnings-and-challenges)

## About the Project

The main idea of this project is to provide a customizable widget for the iPhone home screen, making it cleaner and more stylish, and allowing it to reflect your personality with a wide range of customization options. It combines an old-school, nostalgic aesthetic with modern technologies to enhance your daily life.

Modu.lite integrates with Apple's Screen Time API on the iPhone and also features a backend built in Rust to handle data and ensure persistence.

## Motivation
There is a growing problem in our society related to excessive smartphone use, which is directly linked to increased anxiety, concentration issues, and a lack of time for the things that matter most. We want interfaces to be useful and enjoyable again.

## Key Features
- Customizable widget that best adapts to your routine
- Unique backgrounds that match the widget
- App blocking
- Insights and tips about your phone usage


## Technologies and Tools
- **Language:** Swift
- **Frameworks:** UIKit, SwiftUI, Combine, SwiftData
- **Tools:** Xcode, SPM, Git
- **APIs Used:** External Backend API in Rust https://github.com/AndreWozniack/Modulite_backend.git

## Learnings and Challenges

There were many challenges in this project, such as learning about the MVVM architecture with coordinators in UIKit, understanding how interactive widgets work, sharing information between the app and the widget, integrating with a custom Rust API for database management and handling other information, as well as implementing iPhone usage control features.
