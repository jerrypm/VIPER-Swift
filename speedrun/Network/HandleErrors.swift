import Foundation
import UIKit

public class HandleErrors {
  
  class func showAlertMessageWithCustomButton(viewController: UIViewController, titleStr: String, messageStr: String, customButton: UIAlertAction) -> Void {
    let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(customButton)
    viewController.present(alert, animated: true, completion: nil)
  }
}
