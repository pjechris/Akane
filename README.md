# Akane
[![Build Status](https://travis-ci.org/akane/Akane.svg)](https://travis-ci.org/akane/Akane)

```ruby
pod install Akane
```

Akane helps you building better iOS native apps by leveraging an **MVVM** design pattern.

The main goal of Akane is to provide you with:

- A safe environment conceived to **minimize bad coding practices** as much as possible
- A **feature-oriented** architecture. Adding/maintaining features is easy with Akane
- A fine-grained **Separation of Concerns**, which translates to 
  - much less merge conflicts
  - a deeper knowledge of your code

# MVVM versus iOS MVC

iOS developers tend to write all their code into a unique and dedicated ViewController class. While this may have been OK some years ago, today's app codebases grow bigger and bigger. Maintaining a single, huge, ViewController file is a dangerous operation which often results in unpredictable side effects.

Akane makes you split your code into small components which are composed of multiple classes, some of which should sound familiar:

- **M**odel
- **V**iew
- **V**iew **M**odel
- ViewController

## Model

The *Model* is the layer containing the classes that model your application business.

### Tips

- A Song, a Movie, a Book, ... all those classes belong to this layer. They **must** contain no references to any `UIKit` or `Akane` component, such as `UIView`, `UIControl`, `ViewModel`, etc.

### Example

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

The *ViewModel* is where all your business logic should be put into. 

### Tips

- *Keep it agnostic*: no reference to any View or ViewController should be present in your ViewModel.
- *Prefer ViewModel composition over inheritance*: split your code into multiple ViewModel, each one dealing with one business case and then create another ViewModel to aggregate all those logics.

### Example

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

Each View **must** correspond to one (and only one) ViewModel. It should be a dedicated (business named) class, just like your ViewModel. 

### Tips

- Name a view meaningfully, by reflecting its business value: for instance BasketView, UserInfoView, etc.
- *View is only about UI logic*. Data **must** come from the ViewModel, by using binding to always be up-to-date.

The data flow between a ViewModel and its View is **always** unidirectional:

- View <- ViewModel for data, through *bindings*
- View -> ViewModel for actions, through *commands*: for instance, send a message or order a product.

### Example

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

The ViewController, through the `ComponentViewController` class, makes the link between `ComponentViewModel` and `ComponentView`.

### Tips

Just pass your `ComponentViewModel` to your ViewController to bind it to its view.

### Example

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

## Collections

Handling collection data with `UITableView` or`UICollectionView` is a little harder than with usual `UIView`s. You will need 3 things:

- A `DataSource`
- A `ComponentCollectionViewModel`
- To make your view conform to `ComponentTableView`

**Collection support is not implemented yet for `UICollectionView`.**

### Example

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

# Akane is *Component-Oriented*

With Akane, each visual feature you want to add to your app is a *Component*.

A screen containing a tableView of tasks to do is a component, and the tableView's header can be a component too if it contains some logic.
Akane encourages the creation of small reusable components throughout your app, in order to improve the maintainability and the meaningfulness of your code.

Each component, with Akane, is composed of:
- `ComponentViewController`
- `ComponentViewModel`
- `ComponentView`

# United We Stand

Akane works great by itself but is even better when combined with our other tools:

- [Gaikan](https://github.com/akane/Gaikan), declarative view styling in Swift. Inspired by CSS modules.
- [Nabigeta](https://github.com/akane/Nabigeta), routing solution to decouple UI from navigation logic.

# Contributing

This project was first developed by [Xebia IT Architects](http://xebia.fr) and has been open-sourced since. We are committed to keeping on working and investing our time in Akane.

We encourage the community to contribute to the project by opening tickets and/or pull requests.

# License

Akane is released under the MIT License. Please see the LICENSE file for details.
