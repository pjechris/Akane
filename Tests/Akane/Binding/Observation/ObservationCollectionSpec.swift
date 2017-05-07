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

class ObservationCollectionSpec : QuickSpec {
    override func spec() {
        var observations: ObservationCollection!

        beforeEach {
            observations = ObservationCollection()
        }

        describe("append") {
            it("adds 1 to count") {
                let count = observations.count

                observations.append(AnyObservation(value: "hello world"))

                expect(observations.count) == count + 1
            }
        }

        describe("unobserve") {
            context("when non empty") {
                beforeEach {
                    observations.append(AnyObservation(value: 1))
                    observations.append(AnyObservation(value: 2))
                }

                it("reduces count to 0") {
                    observations.unobserve()

                    expect(observations.count) == 0
                }
            }


            it("calls callback") {
                var removed = false

                observations.append(AnyObservation(value: "hello")) { removed = true }
                observations.unobserve()

                expect(removed) == true
            }
        }
    }
}