//
// This file is part of Akane
//
// Created by JC on 18/05/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Nimble
import Quick
@testable import Akane

class ComponentViewControllerSpec : QuickSpec {
    override func spec() {
        var viewController: ComponentViewControllerMock!

        beforeEach {
            viewController = ComponentViewControllerMock(nibName: nil, bundle: nil)
        }

        describe("set view") {
            beforeEach {
                viewController.view = ViewMock()
            }

            it("sets componentView") {
                expect(viewController.componentView).toNot(beNil())
            }
        }

        describe("bindings(params:)") {
            beforeEach {

            }

            it("calls didLoadComponent") {
                let observer = ViewObserver(container: viewController, context: ContextMock())

                viewController.bindings(observer, params: ViewModelMock())

                expect(viewController.receivedDidLoadComponent) == true
            }
        }
    }
}

extension ComponentViewControllerSpec {
    class ComponentViewControllerMock : UIViewController, ComponentController {
        typealias ViewType = ViewMock

        var receivedDidLoadComponent: Bool = false
        var stubIsViewLoaded: Bool? = nil

        func didLoadComponent() {
            self.receivedDidLoadComponent = true
        }

        override var isViewLoaded: Bool {
            return self.stubIsViewLoaded ?? super.isViewLoaded
        }
    }

    class ViewMock : UIView, ComponentDisplayable {
        typealias ViewModelType = ViewModelMock

        func bindings(_ observer: ViewObserver, params viewModel: ViewModelMock) {
            
        }
    }

    class ViewModelMock : ComponentViewModel {

    }

    class ContextMock : Context {

    }
}
