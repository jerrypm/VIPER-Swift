import XCTest
@testable import speedrun
@testable import Alamofire

class speedrunTests: XCTestCase {
  
  var gameArray: Array<Game> = []
  let game = Game()
  let gameRun = GameRun()
  
  override func setUp() {
  }
  
  override func tearDown() {
  }
  
  func testPerformanceExample() {
    self.measure {
    }
  }
  
  func testGameListAndRunGame() {
    
    let first = expectation(description: "GameList")
    
    if SPReachability.isConnected() {
      
      let headers = Constants.kNetworkHeaderApplicationJSON
      
      APIservice.requestGetData(Constants.kNetworkURLAPI + Constants.kNetworkURLGamesRequest, headers: headers, success: {
        (JSONResponse) -> Void in
        if JSONResponse["code"].stringValue == "400" {
          XCTAssert(true, "Game List API Service error 400")
        } else if JSONResponse["code"].stringValue == "401" {
          XCTAssert(true, "Game List API Service error 401")
        } else {
          
          for shareObject in JSONResponse["data"].arrayValue {
            
            self.game.parseGame(json: shareObject)
            XCTAssertNotNil(self.game.id, "ID is empty")
            XCTAssertNotNil(self.game.name, "Name is empty")
            XCTAssertNotNil(self.game.image, "Title is empty")
            self.gameArray.append(self.game)
          }
          
          XCTAssertNotNil(self.gameArray, "No Game Data data from API")
          first.fulfill()
        }
      }) {
        (error, statusCode) -> Void in
          XCTAssert(true, "Game List API Service error")
      }
    } else {
      XCTAssert(true, "Internet connection error")
    }
    
    waitForExpectations(timeout: 5.0) { error in
      
      let second = self.expectation(description: "GameDetail")
      
      DispatchQueue.global(qos: .userInitiated).async {
        
        let headers = Constants.kNetworkHeaderApplicationJSON
        
        let firstGame = self.gameArray[0]
        
        let group = DispatchGroup()
        
        group.enter()
        
        APIservice.requestGetData(Constants.kNetworkURLAPI + Constants.kNetworkURLGameRunRequest + firstGame.id, headers: headers, success: {
          (JSONResponse) -> Void in
          if JSONResponse["code"].stringValue == "400" {
            XCTAssert(true, "Game Detail API Service error 400")
          } else if JSONResponse["code"].stringValue == "401" {
            XCTAssert(true, "Game Detail API Service error 401")
          } else {
            
            let gameRun: GameRun = GameRun()
            gameRun.parseRun(json: JSONResponse["data"][0])
            firstGame.gameRun = gameRun
            XCTAssertNotNil(firstGame.gameRun, "No Game Detail Data data from API")
            group.leave()
            
          }
        }) {
          (error, statusCode) -> Void in
          XCTAssert(true, "Game Detail API Service error")
        }
        
        group.wait()
        
        if (firstGame.gameRun?.playerName)! == "" {
          APIservice.requestGetData(Constants.kNetworkURLAPI + Constants.kNetworkURLGameRunUserRequest + (firstGame.gameRun?.playerID)!, headers: headers, success: {
            (JSONResponse) -> Void in
            if JSONResponse["code"].stringValue == "400" {
              XCTAssert(true, "Game Detail API Service error 400")
            } else if JSONResponse["code"].stringValue == "401" {
              XCTAssert(true, "Game Detail API Service error 401")
            } else {
              
              firstGame.gameRun?.playerName = JSONResponse["data"]["names"]["international"].stringValue
              XCTAssertNotNil(firstGame.gameRun?.playerName, "No Game Detail Data data from API")
              second.fulfill()
            }
          }) {
            (error, statusCode) -> Void in
            XCTAssert(true, "Game Detail API Service error")
          }
        } else {
          DispatchQueue.main.async {
          }
        }
      }
    
      self.waitForExpectations(timeout: 5.0) { error in
      
      }
    }
  }
}
