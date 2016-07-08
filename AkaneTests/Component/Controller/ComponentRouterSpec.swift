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
            context("router is UIViewController") {
                var controllerRouter: ControllerRouterMock!

                beforeEach {
                    controllerRouter = ControllerRouterMock(nibName: nil, bundle: nil)
                    router = controllerRouter
                }

                context("unnamed route") {
                    it("receives route") {
                        router.route(RouteContextMock())

                        expect(controllerRouter.receivedRoute) == true
                    }
                }

                context("named route") {
                    it("forwards to segue") {
                        router.route(RouteContextMock(), named: "foo")

                        expect(controllerRouter.receivedPerformSegueWithIdentifier) == true
                    }
                }
            }
        }
    }
}

extension ComponentRouterSpec {
    class ControllerRouterMock : UIViewController, ComponentRouter {
        var receivedRoute = false
        var receivedPerformSegueWithIdentifier = false

        func route(context: ComponentViewModel) {
            self.receivedRoute = true
        }

        override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
            self.receivedPerformSegueWithIdentifier = true
        }
    }

    class RouteContextMock : ComponentViewModel {

    }
}