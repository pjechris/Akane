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

Akane makes you split your code into multiple classes, some of which should familiar:

- **M**odel
- **V**iew
- **V**iew **M**odel
- ViewController

Basically, the idea is to move code you used to write into your ViewController to those dedicated classes.

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

    // bind 'disconnect' with 'buttonDisconnect' 'hidden'
    observer.observe(viewModel.disconnect)
            .bindTo(self.buttonDisconnect.bnd_hidden)
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

# Collections

Handling collection data with `UITableView` or`UICollectionView` is a little harder than with usual `UIView`s. You will need 3 things:

- A `DataSource` providing the data to the view for consumption. You will need to use specific types depending on your needs: `DataSourceTableViewItems` or `DataSourceTableViewSections` for `UITableView`
- A `ComponentCollectionViewModel` providing the collection raw data and view models for each collection data. You will need to use specific types depending on your needs: `ComponentCollectionItemsViewModel` or `ComponentCollectionSectionsViewModel` for both `UITableView` and `UICollectionView`
- To make your view conform with `ComponentTableView`

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
}

class AuthorListTableView: UITableView, ComponentTableView {
  typealias DataSourceType = AuthorListDataSource
  typealias ViewModelType = AuthorListViewModel
}

class AuthorListViewModel: ComponentCollectionItemsViewModel {
  typealias CollectionDataType = Observable<Array<Author>>
  typealias ItemType = Author
  typealias ItemViewModelType = AuthorItemViewModel

  func createItemViewModel(item: ItemType) -> ItemViewModelType {
    return AuthorItemViewModel(author: item)
  }
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
