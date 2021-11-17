import Foundation
public enum WiretappSessionError: Error {
    case unableToLocateResponse(String)
    case unableToParseResponse
    case noURL
}
