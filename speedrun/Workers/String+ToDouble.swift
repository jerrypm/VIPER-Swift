import Foundation

extension String {
  func stringToDouble() -> Double? {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = Locale(identifier: "en_US_POSIX")
    return numberFormatter.number(from: self)?.doubleValue
  }
}
