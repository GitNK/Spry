//
//  SpyableTest.swift
//  SpryExample
//
//  Created by Brian Radebaugh on 7/2/17.
//  Copyright © 2017 Brian Radebaugh. All rights reserved.
//

import Quick
import Nimble
import SpryExample

class SpryableSpec: QuickSpec {
    override func spec() {

        describe("Spryable") {
            var subject: SpryableTestClass!

            beforeEach {
                subject = SpryableTestClass()
            }

            afterEach {
                SpryableTestClass.resetCallsAndStubs()
            }

            describe("recording calls - instance") {
                beforeEach {
                    subject.stub(.getAString).andReturn("")

                    _ = subject.getAString(string: "")
                }

                it("should have recorded the call using Spyable") {
                    let result = subject.didCall(.getAString)
                    expect(result.success).to(beTrue())
                }
            }

            describe("recording calls - class") {
                beforeEach {
                    SpryableTestClass.stub(.getAStaticString).andReturn("")

                    _ = SpryableTestClass.getAStaticString()
                }

                it("should have recorded the call using Spyable") {
                    let result = SpryableTestClass.didCall(.getAStaticString)
                    expect(result.success).to(beTrue())
                }
            }

            describe("stubbing functions - instance") {
                let expectedString = "stubbed string"

                beforeEach {
                    subject.stub(.getAString).andReturn(expectedString)
                }

                it("should return the stubbed value using Stubbable") {
                    expect(subject.getAString(string: "")).to(equal(expectedString))
                }
            }

            describe("stubbing functions - class") {
                let expectedString = "stubbed string"

                beforeEach {
                    SpryableTestClass.stub(.getAStaticString).andReturn(expectedString)
                }

                it("should return the stubbed value using Stubbable") {
                    expect(SpryableTestClass.getAStaticString()).to(equal(expectedString))
                }
            }

            describe("reseting calls and stubs - instance") {
                beforeEach {
                    print("got here 1")
                    subject.stub(.getAString).andReturn("")
                    print("got here 2")
                    _ = subject.getAString(string: "")
                    print("got here 3")

                    subject.resetCallsAndStubs()
                    print("got here 4")
                }

                xit("should reset the calls and the stubs") {
                    print("got here 5")
                    expect(subject.didCall(.getAString).success).to(beFalse())
                    print("got here 6")
                    expect({ _ = subject.getAString(string: "") }()).to(throwAssertion())
                    print("got here 7")
                }
            }

            describe("reseting calls and stubs - class") {
                beforeEach {
                    SpryableTestClass.stub(.getAStaticString).andReturn("")
                    _ = SpryableTestClass.getAStaticString()

                    SpryableTestClass.resetCallsAndStubs()
                }

                xit("should reset the calls and the stubs") {
                    expect(SpryableTestClass.didCall(.getAStaticString).success).to(beFalse())
                    expect({ _ = SpryableTestClass.getAStaticString() }()).to(throwAssertion())
                }
            }
        }
    }
}
