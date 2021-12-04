import XCTest
@testable import demo_wiretapp
import WiretappTest

class WireTappUITests: WiretappBaseTestCase {
    
    // This test shows how you can use the response path /default to store responses for endpoints that
    // occur often with simple data such as login phase / configurations that are consistent with most
    // test cases. This is useful for eliminating duplication across the actual test case folders.
    func test_ExampleTestDefaultFolder() {
        app.staticTexts["a great title for the first post"]
            .wait(until: \.exists)

        app.buttons["Users"]
            .wait(until: \.isHittable)
            .tap()

        app.staticTexts["Name: Nick Gorman"]
            .wait(until: \.isHittable)
            .tap()

        app.staticTexts["Street: East Liberty Street"]
            .wait(until: \.exists)
    }

    // To get the most out of Wiretapp, you'll want to have custom responses for each test that exercise the
    // different use cases. When you enable record mode, this is the format in which you can drag into your
    // working test folder to control the exact request / response for your test.
    func test_ExampleTestDynamicFolder() {
        app.staticTexts["the dynamic responses will have priority over default folder responses and can be combined!"]
            .wait(until: \.exists)

        app.buttons["Users"]
            .wait(until: \.isHittable)
            .tap()

        app.staticTexts["Name: FirstName LastName"]
            .wait(until: \.isHittable)
            .tap()

        app.staticTexts["Street: Kulas Light"]
            .wait(until: \.exists)
    }

    // There will always be cases where you need to hit the same endpoint multiple times in order to get the `latest`
    // data from the server and run your logic state in a loop. Each time you hit the same api endpoint the record
    // mode will dump a new response in sequential order into your record folder. These can be used to simulate
    // pulling of new data and state changes. As you can see below we're testing what happens when new posts are made.
    func test_ExampleTestMultipleResponses() {
        app.staticTexts["the dynamic responses will have priority over default folder responses and can be combined!"]
            .wait(until: \.exists)

        app.buttons["reload"]
            .wait(until: \.isHittable)
            .tap()

        app.staticTexts["since we've reloaded the data, there is a new post available now!"]
            .wait(until: \.exists)

        app.buttons["reload"]
            .wait(until: \.isHittable)
            .tap()

        app.staticTexts["newest post, number 3!"]
            .wait(until: \.exists)
    }
}
