import Foundation
import SwiftyJSON
import RealmSwift

class GameRun: Object {
  
  @objc dynamic var timeRun: String = ""
  @objc dynamic var playerName: String = ""
  @objc dynamic var playerID: String = ""
  @objc dynamic var video: String = ""
  
  func parseRun(json: JSON) {
    
    if json["times"]["primary_t"].exists() {
      self.timeRun = json["times"]["primary_t"].stringValue
    }
    
    if json["players"][0]["name"].exists() {
      self.playerName = json["players"][0]["name"].stringValue
    }
    
    if json["players"][0]["id"].exists() {
      self.playerID = json["players"][0]["id"].stringValue
    }
    
    if json["videos"]["links"][0]["uri"].exists() {
      self.video = json["videos"]["links"][0]["uri"].stringValue
    }
    
  }
}
