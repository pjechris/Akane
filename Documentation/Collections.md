## Collections

Starting with 0.18, you can handle collections in two ways:
- using UIKit
- or using Akane adapters

### Using UIKit

You can use `UITableViewDataSource` and `UICollectionViewDataSource`. You just must ensure to have access to `ViewObserver`
from your data source.

```swift
class AuthorTableViewDataSource : UITableViewDataSource {
  var observer: ViewObserver

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "author", for: indexPath)
    let viewModel = ...

    self.observer.observe(viewModel).bind(to: cell)
  }
}

```

### Using Adapters

`TableViewAdapter` and `CollectionViewAdapter` allow you to make the link between Akane and `UIKit` DataSources.
To use them you'll have to provide a `DataSource`.

DataSource provides:
- number of sections/items (like UIKit datasource)
- data associated with sections/items.

```swift
struct AuthorListDataSource: DataSource {
  let authors: [Author]

  enum Item: Identifiable {
    case author

    var reuseIdentifier: String {
      return AuthorsListDataSource.author
    }  
  }

  init(authors: [Author]) {
    self.authors = authors;
  }

  func numberOfItemsInSection(_ section: Int) -> Int {
    return self.authors.count
  }

  func item(at indexPath: IndexPath) -> Item {
    return .author(self.authors[indexPath.row])
  }

  func itemViewModel(for item: Item) -> AuthorViewModel? {
    switch(item) {
      case .author(let author):
        return AuthorViewModel(author: author)
      }
  }
}

class AuthorsViewModel : ComponentViewModel {
    let authors: Observable<[Author]>
    let dataSource: Observable<AuthorsListDataSource?> = Observable(nil)
    var bag = DisposeBag()

    init(authors: [Author]) {
      self.authors = Observable([
        Author("Emile Zola"),
        Author("Maupassant"),
        Author("Victor Hugo")
      ])

      self.authors.observe {
        guard case let Event.next(authors) = $0 else { return }
        self.dataSource.next(AuthorsListDataSource(authors: authors))
      }
      .dispose(in: self.bag)
    }
}

class AuthorListTableView: UITableView, ComponentView {

  func bindings(observer: ViewObserver, viewModel: ComponentViewModel) {
    viewModel.dataSource.observe { _ in
      let adapter = TableViewAdapter(observer: observer, dataSource: viewModel.dataSource.value!)
      adapter.becomeDataSourceAndDelegate(self, reload: true)
    }
}

```
