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

struct AuthorsListDataSource: DataSource {
    static let author = "author"

    enum Item : Identifiable {
        case author(Author)

        var reuseIdentifier: String {
            return AuthorsListDataSource.author
        }
    }
    
    let authors: [Author]
    
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
