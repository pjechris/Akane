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
   
   func bindings(_ observer: ViewObserver, viewModel: AnyObject) {
      let viewModel = viewModel as! AuthorViewModel
      observer.observe(viewModel.author)
        .convert { AuthorConverter().convert($0) }
        .bind(to: self.title.bnd_text)
   }
}

struct AuthorConverter {
   typealias ValueType = Author
   typealias ConvertValueType = String
   
   func convert(_ author: ValueType) -> ConvertValueType {
      return author.name
   }
}
