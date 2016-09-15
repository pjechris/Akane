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
   private var authors: [Author]
   
   let authorsViewModel: AuthorsViewModel
   lazy var searchFor: Command = RelayCommand<UITextField>() { [unowned self] in
      self.filterAuthors($0?.text)
   }
   
   init() {
      self.authors = [
         Author("Emile Zola"),
         Author("Maupassant"),
         Author("Victor Hugo")
      ]
      self.authorsViewModel = AuthorsViewModel(authors: self.authors)
   }
   
   private func filterAuthors(str: String?) -> () {
      guard let searchString = str?.lowercaseString where searchString.characters.count > 0 else { self.authorsViewModel.authors.next(self.authors); return }
      self.authorsViewModel.authors.next(self.authors.filter() { e in
         return e.name.lowercaseString.rangeOfString(searchString) != nil
      })
   }
}