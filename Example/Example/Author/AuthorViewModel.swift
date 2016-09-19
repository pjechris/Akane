//
//  AuthorViewModel.swift
//  Example
//
//  Created by Martin MOIZARD-LANVIN on 15/09/16.
//  Copyright © 2016 Akane. All rights reserved.
//

import Foundation
import Akane
import Bond

class AuthorViewModel : ComponentViewModel {
   let author: Observable<Author>
   
   init(author: Author) {
      self.author = Observable(author)
   }
}