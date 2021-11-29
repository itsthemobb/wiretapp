import Foundation
import Wiretapp
import XCTest

open class WiretappBaseTestCase: XCTestCase {
    public var timeOut: TimeInterval = 30
    public var app = XCUIApplication()
    open override func setUp() {
        super.setUp()
        app = XCUIApplication()
        do {
            let mockResponses = try Wiretapp.getResponsePath()
            app.launchEnvironment = [
                Wiretapp.testCaseName: mockResponses + name.createDirectoryPath(),
                Wiretapp.responsePath: mockResponses
            ]
        } catch {
            fatalError(error.localizedDescription)
        }
        app.launch()
    }
}
