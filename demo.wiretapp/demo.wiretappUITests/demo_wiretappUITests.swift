import XCTest

class WireTappUITests: WiretappBaseTestCase {
    func test_ExampleTest() {
        app.staticTexts["Hello, world!"]
            .wait(until: \.isHittable)
            .tap()
        
        app.staticTexts["delectus aut autem"]
            .wait(until: \.exists)
    }
}
