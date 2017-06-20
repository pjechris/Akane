//
//  AuthorsView.swift
//  Example
//
//  Created by Martin MOIZARD-LANVIN on 15/09/16.
//  Copyright © 2016 Akane. All rights reserved.
//

import Foundation
import ReactiveKit
import Akane

class AuthorsView : UITableView, ComponentView {
    
    var observableAuthors: Disposable?
    
    override func awakeFromNib() {
        self.estimatedRowHeight = 44

        self.register(UINib(nibName: "AuthorViewCell", bundle: nil), forCellReuseIdentifier: AuthorsListDataSource.author)
    }
    
    func bindings(_ observer: ViewObserver, viewModel: AuthorsViewModel) {
        observableAuthors = viewModel.dataSource.observe { _ in
            let delegate = TableViewAdapter(observer: observer, dataSource: viewModel.dataSource.value!)
            delegate.becomeDataSourceAndDelegate(self, reload: true)
        }
    }
}
