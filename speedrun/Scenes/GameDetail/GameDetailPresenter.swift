import Foundation

protocol GameDetailEventHandler: class {
  
  var viewModel: GameDetailViewModel { get }
  
  func handleLoadGameRun()
  func handleViewWillDisappear()
}

protocol GameDetailResponseHandler: class {
  
  func GameRunRequestDidFinish(response: Response)
  func GameRunRequestData(responseObject: Game)
}

class GameDetailPresenter: GameDetailEventHandler, GameDetailResponseHandler {  
  
  //MARK: Relationships
  
  weak var viewController: GameDetailViewUpdatesHandler?
  var interactor: GameDetailRequestHandler!
  var wireframe: GameDetailNavigationHandler!
  
  var viewModel = GameDetailViewModel()
  var game: Game?
  
  //MARK: - EventHandler Protocol
  
  func handleLoadGameRun() {
    viewModel.showActivityIndicator.value = true
    if let gameObject = game  {
      interactor.getGameRunRequest(game: gameObject)
    } else {
      Alert.showAlertWithOk(type: .error)
    }
  }
  
  func handleViewWillDisappear() {
  }
  
  //MARK: - ResponseHandler Protocol
  
  func GameRunRequestDidFinish(response: Response) {
    
    viewModel.showActivityIndicator.value = false
    
    switch response {
    case .success:
      break
    case .error:
      Alert.showAlertWithOk(type: .error)
    case .noInternet:
      viewModel.showNoInternetAlert.value = true
    }
  }
  
  func GameRunRequestData(responseObject: Game) {
    viewModel.game.value = responseObject
    viewController?.updateGameDetailView()
  }
}
