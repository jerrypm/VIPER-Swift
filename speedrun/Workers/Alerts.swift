import UIKit

enum AlertWithOk {
  case noInternet
  case error
}

public class Alert {
  
  class func showAlertWithOk(type: AlertWithOk) -> Void {
    
    var alertTitle = ""
    var alertMessage = ""
    
    switch type {
    case .noInternet:
      alertTitle = NSLocalizedString("error_title", comment: "Error title")
      alertMessage = NSLocalizedString("noInternet", comment: "Error message description")
    case .error:
      alertTitle = NSLocalizedString("error_title", comment: "Error title")
      alertMessage = NSLocalizedString("error", comment: "Error message description")
    }
    
    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
    let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
    alert.addAction(okAction)
    
    var rootViewController = UIApplication.shared.keyWindow?.rootViewController
    
    if let navigationController = rootViewController as? UINavigationController {
      rootViewController = navigationController.viewControllers.first
    }
    
    rootViewController?.present(alert, animated: true, completion: nil)
  }
}
