import XCTest
@testable import demo_wiretapp
@testable import wiretapp

class WireTappUITests: XCTestCase {
    override func setUp() {
        let app = XCUIApplication()
        app.launchEnvironment = ["testCaseName": self.name]
        app.launch()
    }

    func test_ExampleTest() {
        sleep(100)
//        app.staticTexts["Hello, world!"]
//            .wait(until: \.isHittable)
//            .tap()
//
//        app.staticTexts["delectus aut autem"]
//            .wait(until: \.exists)
//
//        app.staticTexts["Hello, world!"]
//            .wait(until: \.isHittable)
//            .tap()
//
//        app.staticTexts["Nick Gorman"]
//            .wait(until: \.exists)
    }
}
