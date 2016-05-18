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

class ComponentRouterSpec : QuickSpec {
    override func spec() {
        var router: ComponentRouter!

        describe("route") {
            context("when router is UIViewController") {
                var controllerRouter: ControllerRouterMock!

                beforeEach {
                    controllerRouter = ControllerRouterMock(nibName: nil, bundle: nil)
                    router = controllerRouter
                }

                context("with no name") {
                    it("calls overridden implementation") {
                        controllerRouter.route(RouteContextMock())

                        expect(controllerRouter.receivedRoute) == true
                    }
                }
            }
        }
    }
}

extension ComponentRouterSpec {
    class ControllerRouterMock : UIViewController, ComponentRouter {
        var receivedRoute: Bool = false

        func route(context: ComponentViewModel, named name: String?) {
            self.receivedRoute = true
        }
    }

    class RouteContextMock : ComponentViewModel {

    }
}