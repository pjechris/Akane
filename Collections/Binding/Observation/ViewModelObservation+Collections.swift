//
//  ViewModelObservation.swift
//  AkaneCollections
//
//  Created by Simone Civetta on 21/11/16.
//  Copyright © 2016 Akane. All rights reserved.
//

import Foundation

extension ViewModelObservation {
    func bindTo(_ cell: UIView, template: Template) {
        template.bind(cell, wrapper: self)
    }
}
