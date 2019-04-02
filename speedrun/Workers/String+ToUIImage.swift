import UIKit

extension String {
  
  func stringURLtoUIImage() -> UIImage {
    
    guard let url = URL(string: self) else {
      return UIImage()
    }
    
    guard let data = try? Data(contentsOf: url) else {
      return UIImage()
    }
    
    guard let image = UIImage(data: data) else {
      return UIImage()
    }
    
    return image
  }
}
