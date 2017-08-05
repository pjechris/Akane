//
//  SearchAutorsViewModel.swift
//  Example
//
//  Created by Martin MOIZARD-LANVIN on 15/09/16.
//  Copyright © 2016 Akane. All rights reserved.
//

import Foundation
import Akane
import Bond

class SearchAuthorsViewModel : ComponentViewModel {
   fileprivate var authors: [Author]
    var filteredAuthors: Observable<[Author]>

    lazy var searchFor: RelayCommand<String> = RelayCommand<String>() { [unowned self] in
        self.filterAuthors($0)
    }
   
   init() {
      self.authors = [
         Author("Emile Zola"),
         Author("Maupassant"),
         Author("Victor Hugo")
      ]
    self.filteredAuthors = Observable(self.authors)
   }
   
    fileprivate func filterAuthors(_ str: String?) -> () {
        guard let searchString = str?.lowercased(), searchString.characters.count > 0 else {
            self.filteredAuthors.next(self.authors)
            return
        }
        self.filteredAuthors.next(self.authors.filter() { e in
            return e.name.lowercased().range(of: searchString) != nil
        })
    }
}
