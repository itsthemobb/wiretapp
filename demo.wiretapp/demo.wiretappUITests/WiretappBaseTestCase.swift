import Foundation
import XCTest

class WiretappBaseTestCase: XCTestCase {
    let timeOut: TimeInterval = 30
    var app = XCUIApplication()
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        if let mockResponses = getRootPath() {
            app.launchEnvironment = [
                Wiretapp.testCasePath: mockResponses + "/MockResponses/" + name.createDirectoryPath()
            ]
            print(mockResponses + name.createDirectoryPath())
        }
        app.launch()
    }
    
    func getRootPath() -> String? {
        let pathArray: [String] = #file.split(separator: "/")
            .dropLast(2)
            .map { String($0) }

        let path = "file:///" + pathArray.joined(separator: "/")
        return path
    }
}

extension String {
    func groups(for regexPattern: String) -> [String] {
        do {
            let text = self
            let regex = try NSRegularExpression(pattern: regexPattern)
            guard
                let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
                match.numberOfRanges > 0
            else {
                return []
            }

            return (1..<match.numberOfRanges).map {
                let rangeBounds = match.range(at: $0)
                guard let range = Range(rangeBounds, in: text) else { return "" }
                return String(text[range])
            }
        } catch {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    func createDirectoryPath() -> String {
        groups(for: "^\\-\\[(\\w+)\\stest_(\\w+)\\]$").joined(separator: "/")
    }
}

extension XCUIElement {
    func waitForNonExistence(timeout: TimeInterval) -> Bool {
        let timeStart = Date().timeIntervalSince1970
        while Date().timeIntervalSince1970 <= timeStart + timeout {
            if !exists { return true }
        }
        return false
    }
}

// Source: https://sourcediving.com/clean-waiting-in-xcuitest-43bab495230f
extension XCUIElement {
    /// The period of time in seconds to wait explicitly for expectations.
    static let waitTimeout: TimeInterval = 15

    /// Explicitly wait until either `expression` evaluates to `true` or the `timeout` expires.
    ///
    /// If the condition fails to evaluate before the timeout expires, a failure will be recorded.
    ///
    /// **Example Usage:**
    ///
    /// ```
    /// element.wait(until: { !$0.exists })
    /// element.wait(until: { _ in otherElement.isEnabled }, timeout: 5)
    /// ```
    ///
    /// - Parameters:
    ///   - expression: The expression that should be evaluated before the timeout expires.
    ///   - timeout: The specificied amount of time to check for the given condition to match the expected value.
    ///   - message: An optional description of a failure.
    /// - Returns: The XCUIElement.
    @discardableResult
    func wait(
        until expression: @escaping (XCUIElement) -> Bool,
        timeout: TimeInterval = waitTimeout,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        if expression(self) {
            return self
        }

        let predicate = NSPredicate { _, _ in
            expression(self)
        }

        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: nil)

        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)

        if result != .completed {
            XCTFail(
                message().isEmpty ? "expectation not matched after waiting" : message(),
                file: file,
                line: line
            )
        }

        return self
    }

    /// Explicitly wait until the value of the given `keyPath` equates to `match`.
    ///
    /// If the `keyPath` fails to match before the timeout expires, a failure will be recorded.
    ///
    /// **Example Usage:**
    ///
    /// ```
    /// element.wait(until: \.isEnabled, matches: false)
    /// element.wait(until: \.label, matches: "Downloading...", timeout: 5)
    /// ```
    ///
    /// - Parameters:
    ///   - keyPath: A key path to the property of the receiver that should be evaluated.
    ///   - match: The value that the receivers key path should equal.
    ///   - timeout: The specificied amount of time to check for the given condition to match the expected value.
    ///   - message: An optional description of a failure.
    /// - Returns: The XCUIElement.
    @discardableResult
    func wait<Value: Equatable>(
        until keyPath: KeyPath<XCUIElement, Value>,
        is match: Value,
        timeout: TimeInterval = waitTimeout,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        wait(
            until: { $0[keyPath: keyPath] == match },
            timeout: timeout,
            message: message(),
            file: file,
            line: line
        )
    }

    /// Explicitly wait until the value of the value of the given `keyPath` equals `true`.
    ///
    /// If the `keyPath` fails to match before the timeout expires, a failure will be recorded.
    ///
    /// **Example Usage:**
    ///
    /// ```
    /// element.wait(until: \.exists)
    /// element.wait(until: \.exists, timeout: 5)
    /// ```
    ///
    /// - Parameters:
    ///   - keyPath: The KeyPath that represents which property of the receiver should be evaluated.
    ///   - timeout: The specificied amount of time to check for the given condition to match the expected value.
    ///   - message: An optional description of a failure.
    /// - Returns: The XCUIElement.
    @discardableResult
    func wait(
        until keyPath: KeyPath<XCUIElement, Bool>,
        timeout: TimeInterval = waitTimeout,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        wait(
            until: keyPath,
            is: true,
            timeout: timeout,
            message: message(),
            file: file,
            line: line
        )
    }

    /// Explicitly wait until the value of the given `keyPath` does not equate to `match`.
    ///
    /// If the `keyPath` fails to not match before the timeout expires, a failure will be recorded.
    ///
    /// **Example Usage:**
    ///
    /// ```
    /// element.wait(until: \.isEnabled, doesNotMatch: false)
    /// element.wait(until: \.label, doesNotMatch: "Downloading...", timeout: 5)
    /// ```
    ///
    /// - Parameters:
    ///   - keyPath: A key path to the property of the receiver that should be evaluated.
    ///   - match: The value that the receivers key path should not equal.
    ///   - timeout: The specificied amount of time to check for the given condition to match the expected value.
    ///   - message: An optional description of a failure.
    /// - Returns: The XCUIElement.
    @discardableResult
    func wait<Value: Equatable>(
        until keyPath: KeyPath<XCUIElement, Value>,
        isNot match: Value,
        timeout: TimeInterval = waitTimeout,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        wait(
            until: { $0[keyPath: keyPath] != match },
            timeout: timeout,
            message: message(),
            file: file,
            line: line
        )
    }
}
