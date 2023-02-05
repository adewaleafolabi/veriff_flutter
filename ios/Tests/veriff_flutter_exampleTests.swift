//
//  veriff_flutter_exampleTests.swift
//  veriff_flutter_exampleTests
//
//  Created by Mert Celik on 20.04.2021.
//

import XCTest
import veriff_flutter
import Flutter

class veriff_flutter_exampleTests: XCTestCase {
    var plugin: VeriffFlutterPlugin?
    let version: String = "iOS 14.5"

    override func setUp() {
        super.setUp()
        plugin = VeriffFlutterPlugin()
    }

    override func tearDown() {
        super.tearDown()
        plugin = nil
    }

    func test_platformVersion() {
        let call = FlutterMethodCall(methodName: "getPlatformVersion", arguments: nil)
        plugin?.handle(call, result: { result in
            guard let platformVersion = result as? String else {
                XCTFail("Platform version should be returned")
                return
            }
            XCTAssertNotNil(platformVersion)
            XCTAssertEqual(platformVersion,
                           self.version,
                           "Version should be same with the one set in Fastfile.")
        })
    }

    func test_returnNilIfParametersMissing() {
        let call = FlutterMethodCall(methodName: "veriffStart", arguments: nil)
        plugin?.handle(call, result: { result in
            XCTAssertNil(result, "Result should be nil since no arguments are passed.")
        })
    }

}
