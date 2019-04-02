import Foundation

protocol WelcomeListRequestHandler: class {
  
  func getGameListRequest()
}

class WelcomeListInteractor: WelcomeListRequestHandler {
  
//MARK: Relationships
  
  weak var presenter: WelcomeListResponseHandler?
  
//MARK: - RequestHandler Protocol
  
  func getGameListRequest() {
    
    if SPReachability.isConnected() {
      
      let headers = Constants.kNetworkHeaderApplicationJSON
      
      APIservice.requestGetData(Constants.kNetworkURLAPI + Constants.kNetworkURLGamesRequest, headers: headers, success: {
        (JSONResponse) -> Void in
        if JSONResponse["code"].stringValue == "400" {
          self.presenter?.GameListRequestDidFinish(response: .error)
        } else if JSONResponse["code"].stringValue == "401" {
          self.presenter?.GameListRequestDidFinish(response: .error)
        } else {
          
          var gameArray: Array<Game> = []
          
          for gameObject in JSONResponse["data"].arrayValue {
            let game = Game()
            game.parseGame(json: gameObject)
            gameArray.append(game)
          }
          
          self.presenter?.GameListRequestDidFinish(response: .success)
          self.presenter?.GameListRequestData(responseObject: gameArray)
        }
      }) {
        (error, statusCode) -> Void in
        self.presenter?.GameListRequestDidFinish(response: .error)
        #if DEBUG
          print(error)
        #endif
      }
    } else {
      presenter?.GameListRequestDidFinish(response: .noInternet)
    }
  }
}
