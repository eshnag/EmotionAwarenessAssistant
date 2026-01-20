//
//  Emotion_Aware_Writing_AssistantUITestsLaunchTests.swift
//  Emotion Aware Writing AssistantUITests
//
//  Created by Eshna Gupta on 1/19/26.
//

import XCTest

final class Emotion_Aware_Writing_AssistantUITestsLaunchTests: XCTestCase {

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
