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
            context("on bnd attribute") {
                it("updates binding") {
                    observation.bind(to: binding.reactive.text)

                    expect(binding.text) == "Hello Bond"
                }

                context("when converted") {
                    beforeEach {
                        observation
                            .convert { return $0?.uppercased() }
                            .bind(to: binding.reactive.text)
                    }

                    it("updates binding") {
                        observation.put("Hello World")
                        expect(binding.text) == "HELLO WORLD"
                    }
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
