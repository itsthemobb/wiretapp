import Foundation

public enum WiretappError: Error {
    case unableToLocationResponsePath
    case unableToLocateResponse(String)
    case unableToParseResponse
    case noURL
}

extension WiretappError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unableToLocationResponsePath:
            return "Unable to locate the '\(Wiretapp.responsePath)' variable in environment variables"

        case .unableToLocateResponse(let path):
            return "Unable to find mock response at path \(path)"

        case .unableToParseResponse:
            return "Unable to parse mock response"

        case .noURL:
            return "Invalid URL in request"
        }
    }
}
