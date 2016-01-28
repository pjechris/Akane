# Akane
[![Build Status](https://travis-ci.org/akane/Akane.svg)](https://travis-ci.org/akane/Akane)

```ruby
pod install Akane
```

Akane is a MVVM framework helping you to build safer, cleaner and more maintenable iOS native apps.
It provides you :

- A safe environment to minimize code mistakes as much as possible.
- Team conflict "free". You're working on a different feature than your team members? Then you should be free of Git merging issues.
- A feature-oriented architecture. Adding/maintining features is simple.
- SoC (Separation of Concern). You always know where to write code because there's only one place it belongs to.

# MVVM versus iOS MVC

iOS developers tend to write all their code into a unique and dedicated ViewController class. While this may have been OK some years ago, today native apps become bigger than ever. Maintaining a single file is not possible anymore.

Akane makes you split your code into small components which are composed of multiple classes, some of which should familiar:

- **M**odel
- **V**iew
- **V**iew **M**odel
- ViewController

### Model

Model is just the layer containing all your classes modeling your application business : Basket, Movie, Book, ... all those classes belong to this layer. They **must** contain no references to any UIKit or Akane components (UIView, UIControl, ViewModel, ...).

```swift
struct User {
  enum Gender: String {
    case Male
    case Female
  }

  let username: String
  let gender: Gender
}
```

## ViewModel

Put all your business logic into a ViewModel class. **Keep it agnostic**: no reference to any View or ViewController should be present into your ViewModel(s).

Prefer ViewModel composition over inheritance: split your code into multiple ViewModel, each one dealing with one business case and then create another ViewModel to aggregate all those logics.

```swift
import Akane

class UserViewModel : ComponentViewModel {
  let user: Observable<User>?
  let disconnect: Command = RelayCommand() { [unowned self]
    self.user.next(nil)
  }

  init(user: User) {
    self.user = Observable(user)
  }

  func isConnected() -> Bool {
    return self.user != nil
  }
}

```

## View

View **must** reflect one (and only one) ViewModel. It should be a dedicated (business named) class, just like your ViewModel. So name it BasketView, UserInfoView, ...

**View is only about UI logic**. Data **must** come from ViewModel, using binding to always be up-to-date.

ViewModel - View flow is always unidirectional :
- View <- ViewModel for data, through bindings
- View -> ViewModel for actions, through commands (like send a message, order a product, ...)

```swift
import Akane

class UserView : UIView, ComponentView {
  @IBOutlet var labelUserHello: UILabel!
  @IBOutlet var buttonDisconnect: UIButton!

  func bindings(observer: ViewObserver, viewModel: ViewModel) {
    let viewModel = viewModel as! UserViewModel

    // Bind 'user' with 'labelUserHello' 'text' using a converter
    observer.observe(viewModel.user)
            .convert(UserHelloConverter.self)
            .bindTo(self.labelUserHello.bnd_text)

    // bind 'disconnect' command with 'buttonDisconnect'
    observer.observe(viewModel.disconnect)
            .bindTo(self.buttonDisconnect)
  }
}

struct UserHelloConverter {
  typealias ValueType = User
  typealias ConvertValueType = String

  func convert(user: ValueType) -> ConvertValueType {
    let gender = (user.gender == .Male) ? "mr" : "miss"
    return "Hello \(gender) \(user.username)"
  }
}

```

## ViewController

ViewController, through `ComponentViewController` class, makes the link between `ComponentViewModel` and `ComponentView`.

Just pass your `ComponentViewModel` to your ViewController to bind it to its view.

```swift

application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {  

  let rootViewController = self.window.rootViewController as! ComponentViewController
  let user = User(username: "Mikasa", gender: .Female)

  rootViewController.viewModel = UserViewModel(user: user)

  return true
}

```

You can even define your custom ViewControllers if you need to:

```swift

extension UserView {
  static func componentControllerClass() -> ComponentViewController.Type {
    return UserViewController.self
  }
}

class UserViewController : ComponentViewController {
  func viewDidLoad() {
    super.viewDidLoad()
    print("User component view loaded")
  }
}

```


# Collections

Handling collection data with `UITableView` or`UICollectionView` is a little harder than with usual `UIView`s. You will need 3 things:

- A `DataSource`
- A `ComponentCollectionViewModel`
- To make your view conform to `ComponentTableView`

**Note that collection support is not yet implemented for `UICollectionView`.**

```swift
struct AuthorListDataSource: DataSourceTableViewItems {
  typealias DataType = Array<Author>

  typealias ItemType = Author
  enum ItemIdentifier: String {
    case Author
  }

  let data: DataType

  init(data: DataType) {
    self.data = data
  }

  func itemAtIndexPath(indexPath: NSIndexPath) -> (item: ItemType?, identifier: ItemIdentifier) {
    return (item: self.data[indexPath.row], identifier: .Author)
  }

  func tableViewItemTemplate(identifier: ItemIdentifier) -> Template {
    return TemplateComponentView(AuthorViewCell.self)
  }
}

class AuthorListViewModel: ComponentCollectionItemsViewModel {
  typealias DataType = Observable<Array<Author>>
  typealias ItemType = Author
  typealias ItemViewModelType = AuthorItemViewModel

  var data: DataType

  init() {
    self.data = Observable([
      Author("Emile Zola"),
      Author("Maupassant"),
      Author("Victor Hugo")
    ])
  }

  func createItemViewModel(item: ItemType) -> ItemViewModelType {
    return AuthorItemViewModel(author: item)
  }
}

class AuthorListTableView: UITableView, ComponentTableView {
  typealias DataSourceType = AuthorListDataSource
  typealias ViewModelType = AuthorListViewModel
}

```

# United we stand

Akane works great by itself but is even better when combined with our other tools:

- [Gaikan](https://github.com/akane/Gaikan), declarative view styling in Swift. Inspired by CSS modules.
- [Nabigeta](https://github.com/akane/Nabigeta), routing solution to decouple UI from navigation logic.

# Contributing

This project was first developed by [Xebia IT Architects](http://xebia.fr) and has been open-sourced since. We will continue working and investing on it.

We encourage the community to contribute to the project by opening tickets and/or pull requests.

# License

Akane is released under the MIT License. Please see the LICENSE file for details.
