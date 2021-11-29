import Foundation

public extension String {
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
