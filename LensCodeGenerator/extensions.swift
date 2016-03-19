import Foundation

extension String {
  func getSubstringWithRange(range: NSRange) -> String {
    let start = startIndex.advancedBy(range.location)
    let end = start.advancedBy(range.length)
    let substring = substringWithRange(Range(start: start, end: end))
    return substring
  }

  var fullRange: NSRange {
    return NSMakeRange(0, characters.count)
  }

  var regex: NSRegularExpression? {
    return try? NSRegularExpression(
      pattern: self,
      options: .CaseInsensitive)
  }
}

extension NSRegularExpression {
  func firstMatch(string: String) -> NSTextCheckingResult? {
    return firstMatchInString(string, options: NSMatchingOptions(rawValue: 0), range: string.fullRange)
  }

  func matches(string: String) -> [NSTextCheckingResult] {
    return matchesInString(string, options: NSMatchingOptions(rawValue: 0), range: string.fullRange)
  }
}
