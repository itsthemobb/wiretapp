import Foundation
public class Wiretapp {
    public static let defaultResponsesPath: String = "defaultResponses"
    public static let recordEnabled: String = "wiretappRecording"
    public static let testCasePath: String = "testCasePath"

    public class func configure() {
        // The last registered class gets called first [Muhammad U. Ali]
        // when a request is dispatched using URLSession.shared
        URLProtocol.registerClass(WiretappRecordURLProtocol.self)
        URLProtocol.registerClass(WiretappURLProtocol.self)
    }
}
