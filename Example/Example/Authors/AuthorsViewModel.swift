//
//  AuthorsViewModel.swift
//  Example
//
//  Created by Martin MOIZARD-LANVIN on 15/09/16.
//  Copyright © 2016 Akane. All rights reserved.
//

import Foundation
import Akane
import ReactiveKit
import Bond

class AuthorsViewModel : ComponentViewModel {
    let authors: Observable<[Author]>
    let dataSource: Observable<AuthorsListDataSource?> = Observable(nil)
    var observableAuthors: Disposable?
    
    init(authors: [Author]) {
        self.authors = Observable(authors)
        observableAuthors = self.authors.observe {
            guard case let Event.next(authors) = $0 else { return }
            self.dataSource.next(AuthorsListDataSource(authors: authors))
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
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> (item: Author?, identifier: ItemIdentifier) {
        return (item: self.authors[indexPath.row], identifier: .Author)
    }
    
    func tableViewItemTemplate(_ identifier: ItemIdentifier) -> Template {
        return TemplateComponentView(AuthorViewCell.self, from: .nib(UINib(nibName: "AuthorViewCell", bundle: nil)))
    }
    
    func createItemViewModel(_ item: Author?) -> AuthorViewModel? {
        return AuthorViewModel(author: item!)
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return self.authors.count
    }
}
