import SnapKit

protocol NoInternetAlertDelegate: class {
  func noInternetAlertReloadConnection()
}

class NoInternetAlert: UIView, Modal {
  
  var backgroundView = UIView()
  var dialogView = UIView()
  var logo = UIImageView()
  var title = UILabel()
  var subTitle = UILabel()
  var noInternetImage = UIImageView()
  var reloadButton = UIButton()
  var scrollView = UIScrollView()
  
  weak var delegate: NoInternetAlertDelegate?
  
  convenience init() {
    self.init(frame: UIScreen.main.bounds)
    initialize()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func initialize(){
    
    dialogView.clipsToBounds = true
    
    scrollView.frame = frame
    
    scrollView.isScrollEnabled = true
    let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    self.scrollView.contentInset = contentInsets
    self.scrollView.scrollIndicatorInsets = contentInsets
    
    addSubview(scrollView)
    
    backgroundView.frame = frame
    backgroundView.backgroundColor = ThemeColor.white.SPColor
    backgroundView.alpha = 1.0
    scrollView.addSubview(backgroundView)
    
    title.frame.origin = CGPoint(x: 24, y: 224)
    title.frame.size = CGSize(width: 327 , height: 21)
    title.text = NSLocalizedString("error", comment: "Error message")
    title.textAlignment = .center
    backgroundView.addSubview(title)
    
    subTitle.frame.origin = CGPoint(x: 24, y: 250)
    subTitle.frame.size = CGSize(width: 327 , height: 48)
    subTitle.numberOfLines = 0
    subTitle.font = UIFont.systemFont(ofSize: 16)
    subTitle.text = NSLocalizedString("noInternet", comment: "No internet message")
    subTitle.textAlignment = .center
    backgroundView.addSubview(subTitle)
    
    reloadButton.frame.origin = CGPoint(x: 113, y: 553)
    reloadButton.frame.size = CGSize(width: 149 , height: 45)
    reloadButton.setTitle(NSLocalizedString("retry", comment: "Retry message").uppercased(), for: .normal)
    reloadButton.setTitleColor(ThemeColor.white.SPColor, for: .normal)
    reloadButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    reloadButton.setTitleColor(ThemeColor.white.SPColor.withAlphaComponent(0.6), for: .highlighted)
    reloadButton.layer.cornerRadius = 7
    reloadButton.backgroundColor = ThemeColor.black.SPColor
    reloadButton.addTarget(self, action: #selector(pressedAction(_:)), for: .touchUpInside)
    backgroundView.addSubview(reloadButton)
    
    scrollView.snp.makeConstraints { (make) in
      make.edges.equalTo(self)
    }
    
    backgroundView.snp.makeConstraints { (make) in
      make.edges.equalTo(scrollView.snp.edges)
      make.width.equalTo(self)
      make.height.equalTo(self)
    }
    
    title.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top).offset(81)
      make.left.equalTo(self.snp.left).offset(24)
      make.right.equalTo(self.snp.right).offset(-24)
    }
    
    subTitle.snp.makeConstraints { (make) in
      make.top.equalTo(title.snp.bottom).offset(5)
      make.left.equalTo(self.snp.left).offset(24)
      make.right.equalTo(self.snp.right).offset(-24)
    }
    
    reloadButton.snp.makeConstraints { (make) in
      make.top.equalTo(subTitle.snp.bottom).offset(32)
      make.centerX.equalToSuperview()
      make.height.equalTo(45)
      make.width.equalTo(149)
    }
  }
  
  @objc func pressedAction(_ sender: UIButton) {
    let delayInSeconds = 3.0
    SPLoaderSpinner.sharedInstance.showActivityIndicator(title: NSLocalizedString("loading", comment: "Loading spinner message"))
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
      SPLoaderSpinner.sharedInstance.hideActivityIndicator()
      if SPReachability.isConnected() {
        self.delegate?.noInternetAlertReloadConnection()
        self.dismiss(animated: true)
      }
    }
  }
}
