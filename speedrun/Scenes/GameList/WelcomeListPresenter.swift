import Foundation

protocol WelcomeListEventHandler: class {
  
  var viewModel: WelcomeListViewModel { get }
  
  func handleLoadGameList()
  func handleItemSelected(at: Int)
}

protocol WelcomeListResponseHandler: class {
  
  func GameListRequestDidFinish(response: Response)
  func GameListRequestData(responseObject: Array<Game>)
}

class WelcomeListPresenter: WelcomeListEventHandler, WelcomeListResponseHandler {
  
//MARK: Relationships
  
  weak var viewController: WelcomeListViewUpdatesHandler?
  var interactor: WelcomeListRequestHandler!
  var wireframe: WelcomeListNavigationHandler!
  
  var viewModel = WelcomeListViewModel()
  
//MARK: - EventHandler Protocol
  
  func handleLoadGameList() {
    viewModel.showActivityIndicator.value = true
    interactor.getGameListRequest()
  }
  
  func handleItemSelected(at: Int) {
    wireframe.pushGameDetail(game: viewModel.gameArray.value[at])
  }
  
//MARK: - ResponseHandler Protocol
  
  func GameListRequestDidFinish(response: Response) {
    
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
  
  func GameListRequestData(responseObject: Array<Game>) {
    viewModel.gameArray.value = responseObject
    viewController?.updateWelcomeListView()
  }
}
