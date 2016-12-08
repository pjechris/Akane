## Collections

Handling collection data with `UITableView` or`UICollectionView` is a little harder than with usual `UIView`s as you will need a `DataSource` to provide data.

### Example

```swift
struct AuthorListDataSource: DataSourceTableViewItems {
  enum ItemIdentifier: String {
    case Author
  }

  init(authors: Array<Author>) {
    self.authors = authors
  }

  func itemAtIndexPath(indexPath: NSIndexPath) -> (item: Author?, identifier: ItemIdentifier) {
    return (item: self.data[indexPath.row], identifier: .Author)
  }

  func tableViewItemTemplate(identifier: ItemIdentifier) -> Template {
    return TemplateComponentView(AuthorViewCell.self)
  }

  func createItemViewModel(item: Author?) -> AuthorItemViewModel? {
    return AuthorItemViewModel(author: item!)
  }
}

class AuthorListViewModel: ComponentViewModel {
  let authors: Array<Author>
  let dataSource: AuthorListDataSource

  init() {
    self.authors = [
      Author("Emile Zola"),
      Author("Maupassant"),
      Author("Victor Hugo")
    ]
    self.dataSource = AuthorListDataSource(authors: self.authors)
  }
}

class AuthorListTableView: UITableView, ComponentView {

  func bindings(observer: ViewObserver, viewModel: ComponentViewModel) {
    let viewModel = viewModel as! AuthorListViewModel
    let delegate = TableViewDelegate(observer: observer, dataSource: viewModel.dataSource)

    delegate.becomeDataSourceAndDelegate(self, reload: true)
  }
}

```
