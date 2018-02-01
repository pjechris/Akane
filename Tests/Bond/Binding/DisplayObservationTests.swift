//
//  DisplayObservationTests.swift
//  Akane
//
//  Created by pjechris on 29/01/2018.
//  Copyright © 2018 fr.akane. All rights reserved.
//

import Foundation
import Nimble
import Quick
import Bond
@testable import Akane

class DisplayObservationTests : QuickSpec {
    override func spec() {
        describe("to(params:)") {
            var observation: DisplayObservation<ViewMock>!
            var container: ContainerMock! // FIXME Need to retain variable otherwise test crash

            beforeEach {
                container = ContainerMock()
                observation = DisplayObservation(view: ViewMock(frame: .zero),
                                                 container: container,
                                                 observer: ViewObserver(container: container, context: ContextMock()))
            }

            context("params is view model") {
                context("view model is observable") {
                    var viewModel: Observable<ViewModelMock>!

                    beforeEach {
                        viewModel = Observable(ViewModelMock())
                    }

                    it("binds view model") {
                        var checked = false

                        observation.view.bindChecker = { _, params in
                            checked = true
                            expect(params) === viewModel.value
                        }

                        observation.to(params: viewModel)
                        expect(checked).toEventually(beTrue())
                    }
                }
            }
        }
    }
}

extension DisplayObservationTests {
    class DisplayObservationStub : DisplayObservation<ViewMock> {

    }

    class ViewModelMock : ComponentViewModel {
        init() {
        }
    }

    class ViewMock : UIView, ComponentDisplayable {
        var bindCalled = 0
        var bindChecker: ((ViewObserver, ViewModelMock) -> Void)? = nil

        func bindings(_ observer: ViewObserver, params: ViewModelMock) {
        }

        func bind(_ observer: ViewObserver, params: ViewModelMock) {
            self.bindChecker?(observer, params)
            self.bindCalled += 1
        }
    }

    class ContainerMock : UIViewController, ComponentContainer {
    }

    class ContextMock : Context {
    }
}
