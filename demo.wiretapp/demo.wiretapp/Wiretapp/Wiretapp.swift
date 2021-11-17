import Foundation
public class Wiretapp {
    public static let defaultResponsesPath: String = "defaultResponses"
    public static let recordEnabled: String = "wiretappRecording"
    public static let testCasePath: String = "testCasePath"

    public class func configure() {
        if let
            recordingEnabled = ProcessInfo.processInfo.environment[recordEnabled],
            recordingEnabled == "true"
        {
            //URLProtocol.registerClass(RecordURLProtocol.self)
        } else if
            ProcessInfo.processInfo.environment[testCasePath] != nil
        {
            URLProtocol.registerClass(WiretappURLProtocol.self)
        }
    }
}
