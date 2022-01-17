//
//  Test_login_iOS_Firebase_RxSwiftUITestsLaunchTests.swift
//  Test login iOS Firebase RxSwiftUITests
//
//  Created by Koussaïla Ben Mamar on 18/12/2021.
//

import XCTest

class Test_login_iOS_Firebase_RxSwiftUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
