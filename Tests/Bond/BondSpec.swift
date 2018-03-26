//
// This file is part of Akane
//
// Created by JC on 23/05/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond
import ReactiveKit
import Nimble
import Quick
import Akane
@testable import AkaneBond

class BondSpec : QuickSpec {
    override func spec() {
        var observation: AnyObservation<String?>!
        var binding: UILabel!

        beforeEach {
            binding = UILabel()
            observation = AnyObservation(value: "Hello Bond")
        }

        describe("bind") {
            context("when biding to a signal") {
                it("updates signal value") {
                    observation.bind(to: binding.reactive.text)

                    expect(binding.text) == "Hello Bond"
                }
            }
        }

        describe("unbind") {
            var bindedItem: UILabel!

            beforeEach {
                bindedItem = UILabel()
                observation.bind(to: bindedItem.reactive.text)
            }

            it("should stop update the binding") {
                observation.unobserve()
                observation.put("the world is mine")
                expect(bindedItem.text) == "Hello Bond"
            }
        }
    }
}
