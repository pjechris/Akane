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

        beforeEach {
            collection = ViewObserverCollection()
        }

        describe("observe") {
            context("when observing Observable") {
                it("should save binding") {
                    let observable = Observable("hello")
                    collection.observe(observable)

                    expect(collection.count) == 1
                }
            }

            context("when observing Command") {
                it("should NOT save binding") {
                    collection.observe(RelayCommand() { _ in })

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
        }
    }
}
