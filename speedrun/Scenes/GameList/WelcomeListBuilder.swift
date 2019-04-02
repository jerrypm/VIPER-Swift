import UIKit

class WelcomeListBuilder {
  
  static func build() -> UIViewController {
    
    let viewController = WelcomeListViewController(nibName:String(describing: WelcomeListViewController.self), bundle: nil)
    let presenter = WelcomeListPresenter()
    let interactor = WelcomeListInteractor()
    let wireframe = WelcomeListWireframe()
    
    viewController.presenter = presenter
    presenter.viewController = viewController
    presenter.interactor = interactor
    presenter.wireframe = wireframe
    interactor.presenter = presenter
    wireframe.viewController = viewController
    
    _ = viewController.view //force loading the view to load the outlets
    return viewController
  }
}
