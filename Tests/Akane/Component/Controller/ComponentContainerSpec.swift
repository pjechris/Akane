//
//  ComponentContainerSpec.swift
//  Akane
//
//  Created by pjechris on 21/06/2017.
//  Copyright © 2017 fr.akane. All rights reserved.
//

import Foundation
import Nimble
import Quick
@testable import Akane

class ComponentContainerSpec : QuickSpec {
    override func spec() {
        var container: ComponentControllerStub!

        beforeEach {
            container = ComponentControllerStub(nibName: nil, bundle: nil)
        }

        describe("component(for:createIfNeeded:)") {
            var view: ComponentViewMock!

            beforeEach {
                view = ComponentViewMock()
            }

            context("when controller does not exist") {
                it("asks view for custom controller") {
                    let component = container.component(for: view, createIfNeeded: true)!

                    expect(type(of: component) == ComponentViewMock.componentControllerClass()).to(beTrue())
                }
            }
        }
    }
}

class ComponentControllerStub : UIViewController, ComponentController {
    typealias ViewType = ComponentViewMock
}

class ComponentViewMock : UIView, ComponentView {
    typealias ViewModelType = ComponentViewModelMock

    func bindings(_ observer: ViewObserver, viewModel: ComponentViewModelMock) {

    }

    static func componentControllerClass() -> AnyComponentController.Type {
        return ComponentControllerStub.self
    }
}

class ComponentViewModelMock : ComponentViewModel {
    init() {

    }
}
