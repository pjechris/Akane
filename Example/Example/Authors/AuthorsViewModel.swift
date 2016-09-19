//
//  AuthorsViewModel.swift
//  Example
//
//  Created by Martin MOIZARD-LANVIN on 15/09/16.
//  Copyright © 2016 Akane. All rights reserved.
//

import Foundation
import Akane
import Bond

class AuthorsViewModel : ComponentViewModel {
   let authors: Observable<[Author]>
   let dataSource: Observable<AuthorsListDataSource?> = Observable(nil)
   
   init(authors: [Author]) {
      self.authors = Observable(authors)
      self.authors.observe {
         self.dataSource.next(AuthorsListDataSource(authors: $0))
      }
   }
}

struct AuthorsListDataSource: DataSourceTableViewItems {
   enum ItemIdentifier: String, RawStringRepresentable {
      case Author
   }
   
   let authors: [Author]
   
   init(authors: [Author]) {
      self.authors = authors;
   }
   
   func itemAtIndexPath(indexPath: NSIndexPath) -> (item: Author?, identifier: ItemIdentifier) {
      return (item: self.authors[indexPath.row], identifier: .Author)
   }
   
   func tableViewItemTemplate(identifier: ItemIdentifier) -> Template {
      return TemplateComponentView(AuthorViewCell.self, from: .Nib(UINib(nibName: "AuthorViewCell", bundle: nil)))
   }
   
   func createItemViewModel(item: Author?) -> AuthorViewModel? {
      return AuthorViewModel(author: item!)
   }
   
   func numberOfItemsInSection(section: Int) -> Int {
      return self.authors.count
   }
}