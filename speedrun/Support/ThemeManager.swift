
import UIKit

enum ThemeColor: Int {
  
  case `default`, white, gray, black
  
  //MARK: - Colors
  
  //Example of centralized colors and icons
  //colorLiteral(red: 0.99607843, green: 0.34901961, blue: 0.23137255, alpha: 1)
  
  var SPColor: UIColor {
    switch self {
    case .default:
      return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    case .white:
      return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    case .gray:
      return #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
    case .black:
      return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
  }
}

enum ThemeImage: String {
  
  case `default`, example_icon_or_image
  
  //MARK: - Colors
  
  var SPImage: String {
    switch self {
    case .default:
      return "default"
    case .example_icon_or_image:
      return "icon_from_assets"
      
    }
  }
}
