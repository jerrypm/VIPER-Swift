import Foundation
import Dispatch

protocol GameDetailRequestHandler: class {
  
  func getGameRunRequest(game: Game)
}

class GameDetailInteractor: GameDetailRequestHandler {
  
//MARK: Relationships
  
  weak var presenter: GameDetailResponseHandler?
  
//MARK: - RequestHandler Protocol
  
  func getGameRunRequest(game: Game) {
    
    DispatchQueue.global(qos: .userInitiated).async {
    
      if SPReachability.isConnected() {
        
        let headers = Constants.kNetworkHeaderApplicationJSON
        
        let group = DispatchGroup()
        
        group.enter()
        
        APIservice.requestGetData(Constants.kNetworkURLAPI + Constants.kNetworkURLGameRunRequest + game.id, headers: headers, success: {
          (JSONResponse) -> Void in
          if JSONResponse["code"].stringValue == "400" {
            self.presenter?.GameRunRequestDidFinish(response: .error)
          } else if JSONResponse["code"].stringValue == "401" {
            self.presenter?.GameRunRequestDidFinish(response: .error)
          } else {
            
            let gameRun: GameRun = GameRun()
            gameRun.parseRun(json: JSONResponse["data"][0])
            game.gameRun = gameRun
            
            group.leave()
            
          }
        }) {
          (error, statusCode) -> Void in
          self.presenter?.GameRunRequestDidFinish(response: .error)
          #if DEBUG
          print(error)
          #endif
        }
        
        group.wait()
        
        if (game.gameRun?.playerName)! == "" {
          APIservice.requestGetData(Constants.kNetworkURLAPI + Constants.kNetworkURLGameRunUserRequest + (game.gameRun?.playerID)!, headers: headers, success: {
            (JSONResponse) -> Void in
            if JSONResponse["code"].stringValue == "400" {
              self.presenter?.GameRunRequestDidFinish(response: .error)
            } else if JSONResponse["code"].stringValue == "401" {
              self.presenter?.GameRunRequestDidFinish(response: .error)
            } else {
              
              game.gameRun?.playerName = JSONResponse["data"]["names"]["international"].stringValue
              self.presenter?.GameRunRequestDidFinish(response: .success)
              self.presenter?.GameRunRequestData(responseObject: game)
            }
          }) {
            (error, statusCode) -> Void in
            self.presenter?.GameRunRequestDidFinish(response: .error)
            #if DEBUG
            print(error)
            #endif
          }
        } else {
          DispatchQueue.main.async {
            self.presenter?.GameRunRequestDidFinish(response: .success)
            self.presenter?.GameRunRequestData(responseObject: game)
          }
        }
        
      } else {
        self.presenter?.GameRunRequestDidFinish(response: .noInternet)
      }
    } 
  }
}
