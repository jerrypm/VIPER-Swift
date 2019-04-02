import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let mainViewController = WelcomeListBuilder.build()
    let navigationController = UINavigationController(rootViewController: mainViewController)
    
    self.window?.rootViewController = navigationController
    self.window?.makeKeyAndVisible()
    
    return true
  }
}
