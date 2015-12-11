//
// This file is part of Akane
//
// Created by JC on 02/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Quick
import Nimble
import Bond
@testable import Akane

class ViewObserverCollectionSpec : QuickSpec {
    override func spec() {
        var collection: ViewObserverCollection!
        var view: ViewMock!
        var lifecycle: LifecycleMock!

        beforeEach {
            view = ViewMock()
            lifecycle = LifecycleMock()
            collection = ViewObserverCollection(view: view, lifecycle: lifecycle)
        }

        describe("observe") {
            context("when observing Observable") {
                it("should save observation") {
                    let observable = Observable("hello")
                    collection.observe(observable)

                    expect(collection.count) == 1
                }
            }

            context("when observing Command") {
                it("should NOT save observation") {
                    collection.observe(RelayCommand() { _ in })

                    expect(collection.count) == 0
                }
            }

            context("when observing observable view model") {
                var viewModel: Observable<ViewModelMock>!

                beforeEach {
                    viewModel = Observable(ViewModelMock())

                    lifecycle.presenterToReturn = AKNPresenterViewController.init(view: view)!
                }

                it("should bind view with viewmodel") {
                    collection.observe(viewModel).bindTo(view.viewToBind)

                    expect(lifecycle.presenterToReturn!.viewModel) === viewModel.value
                }

                it("should NOT save observation") {
                    collection.observe(viewModel)

                    expect(collection.count) == 0
                }
            }
        }

        describe("dispose") {
            beforeEach {
                collection.observe(Observable("Should Be Disposed"))
            }

            it("should dispose bindings") {
                collection.dispose()
                expect(collection.count) == 0
            }

            it("should dispose view model") {
                let firstViewModel = ViewModelMock()
                let secondViewModel = ViewModelMock()
                let observable = Observable(firstViewModel)

                lifecycle.presenterToReturn = AKNPresenterViewController.init(view: view)!
                collection.observe(observable).bindTo(view.viewToBind)

                collection.dispose()
                observable.next(secondViewModel)

                expect(lifecycle.presenterToReturn!.viewModel) !== secondViewModel
            }
        }
    }

    class ViewMock : AKNView {
        var viewToBind: AKNView

        override init(frame: CGRect) {
            self.viewToBind = AKNView()


            super.init(frame: frame)

            self.addSubview(self.viewToBind)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    class LifecycleMock : Lifecycle {
        var presenterToReturn: AKNPresenter? = nil

        func presenterForSubview<T:UIView where T:AKNViewComponent>(subview: T, createIfNeeded: Bool) -> AKNPresenter? {
            return self.presenterToReturn
        }
    }

    class ViewModelMock : NSObject, AKNViewModelProtocol {

    }
}
