//
//  ViewController.swift
//  Example
//
//  Created by Martin MOIZARD-LANVIN on 15/09/16.
//  Copyright © 2016 Akane. All rights reserved.
//

import UIKit
import Akane

class HomeViewController: UIViewController, SceneController {
    typealias ViewType = SearchAuthorsView

    lazy private(set) var navbarItemDisplayer: NavbarItemDisplayer = NavbarItemDisplayer(content: self.navigationItem)

    func didLoadComponent() {
        self.navbarItemDisplayer.bind(self.observer, params: "Search")
    }
}

