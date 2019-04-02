import UIKit

protocol WelcomeListNavigationHandler: class {
  
  func pushGameDetail(game: Game)
}

class WelcomeListWireframe: WelcomeListNavigationHandler {

  weak var viewController: WelcomeListViewController?
  
  func pushGameDetail(game: Game) {
    let vc = GameDetailBuilder.build(game: game)
    viewController?.navigationController?.pushViewController(vc, animated: true)
  }
}
