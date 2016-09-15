//
//  AuthorViewCell.swift
//  Example
//
//  Created by Martin MOIZARD-LANVIN on 15/09/16.
//  Copyright © 2016 Akane. All rights reserved.
//

import UIKit
import Akane

class AuthorViewCell: UITableViewCell, ComponentView {
   @IBOutlet var title: UILabel!
   
   func bindings(observer: ViewObserver, viewModel: AnyObject) {
      let viewModel = viewModel as! AuthorViewModel
      observer.observe(viewModel.author)
         .convert { AuthorConverter().convert($0) }
         .bindTo(self.title.bnd_text)
   }
}

struct AuthorConverter {
   typealias ValueType = Author
   typealias ConvertValueType = String
   
   func convert(author: ValueType) -> ConvertValueType {
      return author.name
   }
}
