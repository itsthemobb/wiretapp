import Foundation

public class Wiretapp {
    public static let responsePath: String = "wiretappResponses"
    public static let recordEnabled: String = "wiretappRecording"
    public static let testCaseName: String = "wiretappTestCaseName"

    public class func registerSharedSession() {
        URLProtocol.registerClass(WiretappRecordURLPlugin.self)
        URLProtocol.registerClass(WiretappMockURLPlugin.self)
    }

    public class func register(configuration: URLSessionConfiguration) -> URLSessionConfiguration {
        configuration.protocolClasses = [WiretappRecordURLPlugin.self, WiretappMockURLPlugin.self]
        return configuration
    }

    public class func getResponsePath() throws -> String {
        guard let environmentVariable = ProcessInfo.processInfo.environment[responsePath] else {
            throw WiretappError.unableToLocationResponsePath
        }
        return environmentVariable
    }
}
