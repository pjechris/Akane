# Akane

Akane helps you building better iOS native apps by using MVVM design pattern.
Focus is to provide you :

- A safe environment to minimize code mistakes as much as possible.
- Team conflict "free". You're working on a different feature than your team members? Then you should be free of Git merging issues.
- A feature-oriented architecture. Adding/maintining features should be easy.
- SoC (Separation of Concern) so that you know where code belongs to.

# Getting started

## What is different from classic iOS MVC?

Not a lot changes actually. You still have your usual *M*odel, *V*iew and ViewController classes.

However we did added a fourth class: *V*iew*M*odel, hence the MVVM pattern.

How does it change you way of coding? Well it's pretty simple:
- All the *business* logic that you used to put into ViewController should be reported into ViewModel
- All the *layout* logic you used to put into ViewController should be reported into a custom View

Not that hard, yeah?

## Installation

```ruby
pod install Akane
```

# Contributing

Akane is an Open Source project. As such don't hesitate to contribute through tickets and/or pull requests!

# Liencse

Akane is released under the MIT License. Please see the LICENSE file for details.
