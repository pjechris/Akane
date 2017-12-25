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

class AuthorsView : UITableView, Displayable {

    var authors: [Author]!
    var observer: ViewObserver!
    
    override func awakeFromNib() {
        self.estimatedRowHeight = 44

        self.register(UINib(nibName: "AuthorViewCell", bundle: nil), forCellReuseIdentifier: "author")

        self.delegate = self
        self.dataSource = self
    }
    
    func bindings(_ observer: ViewObserver, params: [Author]) {
        self.authors = params
        self.observer = observer

        self.reloadData()
    }
}

extension AuthorsView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.authors?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "author", for: indexPath) as! AuthorViewCell
        let author = self.authors[indexPath.row]

        self.observer
            .observe(author)
            .bind(to: cell)

        return cell
    }
}
