# Akane
[![Build Status](https://travis-ci.org/akane/Gaikan.svg?branch=travis)](https://travis-ci.org/akane/Akane)

```ruby
pod install Akane
```

Akane is a MVVM framework helping you to build safer, cleaner and more maintenable iOS native apps.
It provides you :

- A safe environment to minimize code mistakes as much as possible.
- Team conflict "free". You're working on a different feature than your team members? Then you should be free of Git merging issues.
- A feature-oriented architecture. Adding/maintining features is simple.
- SoC (Separation of Concern). You always know where to write code because there's only one place it belongs to.

# Getting started

## What is different from classic iOS MVC?

iOS developers tend to write all their code into a unique and dedicated ViewController class. While this may have been OK some years ago, today native apps become bigger than ever. Maintaining a single file is not possible anymore.

Akane makes you split your code into multiple classes, some of which should familiar:
- **M**odel
- **V**iew
- **V**iew **M**odel
- ViewController

Basically, this idea is to move code from your ViewController to those classes.

### Model

Model is just the layer containing all your classes modeling your application business : Basket, Movie, Book, ... all those classes belong to this layer. They **must** contain no references to any UIKit or Akane components (UIView, UIControl, ViewModel, ...).

### View

View **must** reflect one (and only one) ViewModel. It should be a dedicated (business named) class, just like your ViewModel. So name it BasketView, UserInfoView, ...

**View is only about UI logic**. Data **must** come from ViewModel, using binding to always be up-to-date.

ViewModel - View flow is always unidirectional :
- View <- ViewModel for data, through bindings
- View -> ViewModel for actions, through commands (like send a message, order a product, ...)

### ViewModel

Put all your business logic into the ViewModel. **Keep it agnostic**: No reference to any View or ViewController should be present into your ViewModel(s).

Prefer ViewModel composition over inheritance: split your code into multiple ViewModel, each one dealing with one business case and then create another ViewModel to aggregate all those logics.

# United we stand

Akane works great by itself but is even better when combined with our other tools:

- [Gaikan](https://github.com/akane/Gaikan), declarative view styling in Swift. Inspired by CSS modules.
- [Nabigeta](https://github.com/akane/Nabigeta), a routing solution to decouple navigation UI and logic.

# Contributing

This project was first developed by [Xebia](http://xebia.fr) and has been open-sourced since. We will continue working and investing on it.

We encourage the community to contribute to the project by opening tickets and/or pull requests.

# License

Akane is released under the MIT License. Please see the LICENSE file for details.
