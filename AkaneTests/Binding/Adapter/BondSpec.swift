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
@testable import Akane

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
            }
        }
    }
}
