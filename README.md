# Akane
![CocoaPods](https://img.shields.io/cocoapods/v/Akane.svg) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Build Status](https://travis-ci.org/akane/Akane.svg?branch=master)](https://travis-ci.org/akane/Akane)

Akane is a iOS framework that helps you building better native apps by adopting an **MVVM** design pattern.

Head up to our [example](Example) if you want to see a framework real use-case.

*NOTE: Current version (0.30) is in beta. [Click here](https://github.com/akane/Akane/tree/0.20.0) if you want documentation for latest stable release (0.20.0).*


|               |  Main Goals  |
|---------------|--------------|
| :sweat_smile: | Safety: **minimize bad coding practices** as much as possible
| :wrench:       | **Feature-Oriented**: adding and maintaining features is easy and, yes, safe
| :capital_abcd: | **Component-Oriented**: each visual feature you want to add to your app is a *Component* (smart or dumb)
| :scissors:     | fine-grained **Separation of Concerns**, which means:
| :dancers:      | Much less merge conflicts
| :sunglasses:   | A better understanding of your code

Smart components are composed of:
- `ComponentViewController`
- `ComponentViewModel`
- `ComponentDisplayable`

**(New in 0.19!)** _Dumb_ components are simply composed of a `Displayable` and do not have an associated `ViewModel`.

## Why Akane, Or MVVM versus iOS MVC

iOS developers tend to write all their code into a unique and dedicated ViewController class. While this may have been OK some years ago, today's app codebases grow bigger and bigger. Maintaining a single, huge, ViewController file is a dangerous operation which often results in unpredictable side effects.

Akane makes you split your code into small components which are composed of multiple classes.

## Model

The *Model* is the layer containing the classes that model your application business.

Songs, Movies, Books: all those `classes` or `struct`s belong to this layer. They should contain no reference to any `UIKit` or `Akane` component.

```swift
struct User {
  enum Title: String {
    case sir
    case master
  }

  let username: String
  let title: Title
}
```

## Dumb component

Dumb component is not bound to a specific state but can still be updated with raw data.

It is represented by `Displayable` protocol.

```swift
class UserView: UIView, Displayable {
   @IBOutlet var title: UILabel!

   func bindings(_ observer: ViewObserver, params user: User) {
     self.title = UserFullNameConverter().convert(user)
   }
}
```

## Smart component

Smart component represents a component who has a state defining its rendering:

- State is represented using `ComponentViewModel`.
- UI is represented using `ComponentDisplayable`.

### ViewModel

The *ViewModel* is where all your business logic should be implemented.

Please, *Keep it agnostic*: no reference to any View or ViewController should be present in your ViewModel. Also, *Prefer ViewModel composition over inheritance*: split your code into multiple ViewModel, each one dealing with one business case and then create another ViewModel to aggregate all those logics.

```swift
import Akane

class UserViewModel : ComponentViewModel {
  let user: Observable<User>?
  var disconnect: Command! = nil

  init(user: User) {
    self.user = Observable(user)
    self.disconnect = RelayCommand() { [unowned self] in
      self.user.next(nil)
    }
  }

  func isConnected() -> Bool {
    return self.user != nil
  }
}

```

### ComponentDisplayable

Data flow between a ViewModel and its ComponentDisplayable is bidirectional:

- View <- ViewModel for data, through *bindings*
- View -> ViewModel for actions, through *commands*: for instance, send a message or order a product.

```swift
import Akane

class LoggedUserView : UIView, ComponentDisplayable {
  @IBOutlet var userView: UserView!
  @IBOutlet var buttonDisconnect: UIButton!

  func bindings(observer: ViewObserver, params viewModel: UserViewModel) {
    observer.observe(viewModel.user).bind(to: self.userView)

    // bind 'disconnect' command with 'buttonDisconnect'
    observer.observe(viewModel.disconnect)
            .bind(to: self.buttonDisconnect)
  }
}

```

### ComponentController

`ComponentController` protocol, makes the link between `ComponentViewModel` and its `ComponentDisplayable`.

Pass your `ComponentViewModel` to your ViewController to bind it to its view.
You'll also need to declare your `ComponentDisplayable` as being `Wrapped`.

```swift

class LoggedUserViewController : UIViewController, ComponentController {
  typealias ViewType = LoggedUserView

  func didLoadComponent() {
    print("User component loaded")
    // here you can access self.viewModel
  }
}

extension LoggedUserView : Wrapped {
  typealias Wrapper = LoggedUserViewController
}
```

### SceneController

`ComponentController` is unable to receive a `ComponentViewModel` from the "outside".
So how to initialize a view hierarchy when, say, you push a view controller? That's the role of `SceneController`.

```swift

class HomeViewController : UIViewController, SceneController {
  typealias ViewType = HomeView
}

class AppDelegate {
  let context = MyContext() // In 0.30 beta, you have to create your own custom Context class

  application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {  
    let homeViewController = self.window.rootViewController as! HomeViewController
    homeViewController.renderScene(HomeViewModel(), context: self.context)

    return true
  }

  class MyContext : Context {
  }
}

```


## Advanced usage
### Collections

Akane supports displaying collections of objects in `UITableViews` and `UICollectionViews`.
Please [read the Collections.md documentation](Documentation/Collections.md) to know more.

### Navbar

Navbars like views can be customized in Akane. All you have to do is to create a `(Component)Displayable` class and bind it
to your navbar. Sounds complicated? [Head over the example](Example/Example/HomeViewController.swift) to see how you can do it easily!


## Installation

Akane supports installation via CocoaPods and Carthage.

### CocoaPods

```ruby
pod 'Akane'
```

Akane builds on top of Bond for managing bindings. If you do want to use your own library (like RxSwift), you can use Akane core only:

```ruby
pod 'Akane/Core'
```

### Carthage

Add `github "akane/Akane"` to your `Cartfile`.
In order to use Akane Bindings and Akane Collections, you should also append `github "ReactiveKit/Bond"`.

## United We Stand

Akane works great by itself but is even better when combined with our other tools:

- [Gaikan](https://github.com/akane/Gaikan), declarative view styling in Swift. Inspired by CSS modules.
- [Magellan](https://github.com/akane/Magellan), routing solution to decouple UI from navigation logic.

## Contributing

This project was first developed by [Xebia IT Architects](http://xebia.fr) and has been open-sourced since. We are committed to keeping on working and investing our time in Akane.

We encourage the community to contribute to the project by opening tickets and/or pull requests.

## License

Akane is released under the MIT License. Please see the LICENSE file for details.
