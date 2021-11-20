import Foundation
public class Wiretapp {
    public static let defaultResponsesPath: String = "defaultResponses"
    public static let recordEnabled: String = "wiretappRecording"
    public static let testCasePath: String = "testCasePath"

    public class func register() {
        // The last registered class gets called first [Muhammad U. Ali]
        // when a request is dispatched using URLSession.shared
        URLProtocol.registerClass(WiretappRecordURLProtocol.self)
        URLProtocol.registerClass(WiretappURLProtocol.self)
    }

    public class func register(configuration: URLSessionConfiguration) -> URLSessionConfiguration {
        configuration.protocolClasses = [WiretappRecordURLProtocol.self, WiretappURLProtocol.self]
        return configuration
    }

    public class func getRootPath() -> String {
        let pathArray: [String] = #file.split(separator: "/")
            .dropLast(2)
            .map { String($0) }

        let path = "file:///" + pathArray.joined(separator: "/")
        return path
    }

    public class func getLaunchArgumentsFor(test: String) -> [String: String] {
        [
            Wiretapp.testCasePath: Wiretapp.getRootPath() + "/MockResponses/" + test.createDirectoryPath()
        ]
    }
}
