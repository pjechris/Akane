//
//  AuthorsView.swift
//  Example
//
//  Created by Martin MOIZARD-LANVIN on 15/09/16.
//  Copyright © 2016 Akane. All rights reserved.
//

import Foundation
import Akane

class AuthorsView : UITableView, ComponentView {
   override func awakeFromNib() {
      self.estimatedRowHeight = 44;
   }
   
   func bindings(observer: ViewObserver, viewModel: AnyObject) {
      let viewModel = viewModel as! AuthorsViewModel
      viewModel.dataSource.observe { _ in
         let delegate = TableViewDelegate(observer: observer, dataSource: viewModel.dataSource.value!)
         delegate.becomeDataSourceAndDelegate(self, reload: true)
      }
   }
}
