import XCTest
import Wiretapp

final class wiretappTests: XCTestCase {
    struct User: Decodable {
        let id: Int
        let name: String
        let username: String
        let email: String
        let phone: String
        let address: Address
        
        struct Address: Decodable {
            let street: String
            let suite: String
            let city: String
            let zipcode: String
        }
    }
    struct Post: Decodable {
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }

    func test_noEnvironmentVarsLoadsNormally() {
        Wiretapp.registerSharedSession()
        setenv(Wiretapp.recordEnabled, "false", 1)
        setenv(Wiretapp.testCaseName, "", 1)
        let expectation = XCTestExpectation(description: "outbound request made to web")

        URLSession.shared.dataTask(
            with: URL(string: "https://jsonplaceholder.typicode.com/users")!
        ) { data, response, error in
            if
                let data = data,
                let decoded = try? JSONDecoder().decode([User].self, from: data),
                decoded.count > 1
            {
                expectation.fulfill()
            }
        }
        .resume()
        wait(for: [expectation], timeout: 10.0)
    }

    func test_usingTestCaseNameInvokesMockResponses() {
        Wiretapp.registerSharedSession()
        setenv(Wiretapp.recordEnabled, "false", 1)
        let packageRootPath = URL(fileURLWithPath: #file)
            .pathComponents
            .prefix(while: { $0 != "Tests" })
            .joined(separator: "/")
            .dropFirst()
        setenv(Wiretapp.testCaseName,
               packageRootPath + "/Example/demo.wiretapp/MockResponses/WireTappUITests/ExampleTestDynamicFolder",
               1
        )
        let expectation = XCTestExpectation(description: "data will load from our test folder instead of web")

        URLSession.shared.dataTask(
            with: URL(string: "https://jsonplaceholder.typicode.com/users")!
        ) { data, response, error in
            if
                let data = data,
                let decoded = try? JSONDecoder().decode([User].self, from: data),
                decoded.first?.name == "FirstName LastName"
            {
                expectation.fulfill()
            }
        }
        .resume()
        wait(for: [expectation], timeout: 10.0)
    }

    func test_loadingMultipleMockResponsesForSameURI() {
        Wiretapp.registerSharedSession()
        setenv(Wiretapp.recordEnabled, "false", 1)
        let packageRootPath = URL(fileURLWithPath: #file)
            .pathComponents
            .prefix(while: { $0 != "Tests" })
            .joined(separator: "/")
            .dropFirst()
        setenv(Wiretapp.testCaseName,
               packageRootPath + "/Example/demo.wiretapp/MockResponses/WireTappUITests/ExampleTestMultipleResponses",
               1
        )
        let expectation = XCTestExpectation(description: "responses from same uri have loaded in sequence")

        func loadPosts(completion: @escaping ([Post]?) -> ()) {
            URLSession.shared.dataTask(
                with: URL(string: "https://jsonplaceholder.typicode.com/posts")!
            ) { data, response, error in
                if
                    let data = data,
                    let decoded = try? JSONDecoder().decode([Post].self, from: data)
                {
                    completion(decoded)
                }
                completion(nil)
            }
            .resume()
        }

        loadPosts { posts in
            if posts?.count == 1 {
                loadPosts { posts in
                    if posts?.count == 2 {
                        loadPosts { posts in
                            if posts?.count == 3 {
                                expectation.fulfill()
                            }
                        }
                    }
                }
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
