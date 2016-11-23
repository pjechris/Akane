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
@testable import AkaneCore

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

        describe("set viewModel") {
            beforeEach {

            }

            it("calls didLoadComponent") {
                // To make sure right method is called even if we don't have precie class type
                let unkonwnController = viewController as ComponentController

                unkonwnController.viewModel = ViewModelMock()

                expect(viewController.receivedDidLoadComponent) == true
            }
        }
    }
}

extension ComponentViewControllerSpec {
    class ComponentViewControllerMock : ComponentViewController {
        var receivedDidLoadComponent: Bool = false
        var stubIsViewLoaded: Bool? = nil

        override func didLoadComponent() {
            self.receivedDidLoadComponent = true
        }

        override var isViewLoaded: Bool {
            return self.stubIsViewLoaded ?? super.isViewLoaded
        }
    }

    class ViewMock : UIView, ComponentView {
        func bindings(viewModel: AnyObject) {
            
        }
    }

    class ViewModelMock : ComponentViewModel {

    }
}
