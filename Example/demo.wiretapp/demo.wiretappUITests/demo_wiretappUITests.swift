import XCTest
@testable import demo_wiretapp
import wiretappTest

class WireTappUITests: WiretappBaseTestCase {
    override func setUp() {
        super.setUp()
        print("ok start")
    }

    func test_ExampleTest() {
        app.staticTexts["Hello, world!"]
            .wait(until: \.isHittable)
            .tap()

        app.staticTexts["delectus aut autem"]
            .wait(until: \.exists)

        app.staticTexts["Hello, world!"]
            .wait(until: \.isHittable)
            .tap()

        app.staticTexts["Nick Gorman"]
            .wait(until: \.exists)
    }
}
