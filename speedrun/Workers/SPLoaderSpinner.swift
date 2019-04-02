import UIKit

class SPLoaderSpinner {
  
  var container: UIView = UIView()
  var loadingView: UIView = UIView()
  let loadingTextLabel = UILabel()
  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
  let loadingViewWidth = 90.0
  let loadingViewHeight = 90.0
  let activitiIndicatorWidth = 40.0
  let activitiIndicatorHeight = 40.0
  
  let activityIndicatorCenterOffset: CGFloat = 8
  
  static let sharedInstance = SPLoaderSpinner()

  func showActivityIndicator(title: String) {
    container.frame = CGRect(x: 0.0, y: 0.0, width: (UIApplication.shared.keyWindow?.frame.width)!, height: (UIApplication.shared.keyWindow?.frame.height)!)
    container.backgroundColor = .clear
    
    loadingView.frame = CGRect(x: 0.0, y: 0.0, width: loadingViewWidth, height: loadingViewHeight)
    loadingView.center = container.center
    loadingView.backgroundColor = ThemeColor.gray.SPColor
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    
    activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: activitiIndicatorWidth, height: activitiIndicatorHeight)
    activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
    activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: (loadingView.frame.size.height / 2) - activityIndicatorCenterOffset)
    
    loadingTextLabel.textColor = UIColor.black
    loadingTextLabel.text = title
    loadingTextLabel.font = UIFont.systemFont(ofSize: 12)
    loadingTextLabel.sizeToFit()
    loadingTextLabel.textColor = ThemeColor.white.SPColor
    loadingTextLabel.alpha = 0.7
    loadingTextLabel.center = CGPoint(x: activityIndicator.center.x, y: activityIndicator.center.y + 35)
    loadingView.addSubview(loadingTextLabel)
    
    loadingView.addSubview(activityIndicator)
    container.addSubview(loadingView)
    UIApplication.shared.keyWindow?.addSubview(container)
    activityIndicator.startAnimating()
  }
  
  func hideActivityIndicator() {
    activityIndicator.stopAnimating()
    container.removeFromSuperview()
  }
  
  init() {
  }
}
