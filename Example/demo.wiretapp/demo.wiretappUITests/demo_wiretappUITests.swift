import XCTest
@testable import demo_wiretapp
import WiretappTest

class WireTappUITests: WiretappBaseTestCase {
    func test_ExampleTest() {
        app.staticTexts["a great title for the first post"]
            .wait(until: \.exists)

        app.staticTexts["Users"]
            .tap()

        app.staticTexts["East Liberty Street"]
            .wait(until: \.exists)
        sleep(100)
    }
}
