//
//  SearchAutorsViewModel.swift
//  Example
//
//  Created by Martin MOIZARD-LANVIN on 15/09/16.
//  Copyright © 2016 Akane. All rights reserved.
//

import Foundation
import Akane

class SearchAuthorsViewModel : ComponentViewModel {
   fileprivate var authors: [Author]
   
   let authorsViewModel: AuthorsViewModel
   lazy var searchFor: Command = RelayCommand<String>() { [unowned self] in
      self.filterAuthors($0)
   }
   
   init() {
      self.authors = [
         Author("Emile Zola"),
         Author("Maupassant"),
         Author("Victor Hugo")
      ]
      self.authorsViewModel = AuthorsViewModel(authors: self.authors)
   }
   
   fileprivate func filterAuthors(_ str: String?) -> () {
      guard let searchString = str?.lowercased(), searchString.characters.count > 0 else { self.authorsViewModel.authors.next(self.authors); return }
      self.authorsViewModel.authors.next(self.authors.filter() { e in
        return e.name.lowercased().range(of: searchString) != nil
      })
   }
}
