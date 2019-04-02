import UIKit

class GameDetailBuilder {
  
  static func build(game: Game) -> UIViewController {
    
    let viewController = GameDetailViewController(nibName:String(describing: GameDetailViewController.self), bundle: nil)
    let presenter = GameDetailPresenter()
    let interactor = GameDetailInteractor()
    let wireframe = GameDetailWireframe()
    
    viewController.presenter = presenter
    presenter.viewController = viewController
    presenter.interactor = interactor
    presenter.wireframe = wireframe
    interactor.presenter = presenter
    wireframe.viewController = viewController
    
    presenter.game = game
    
    _ = viewController.view //force loading the view to load the outlets
    return viewController
  }
}
