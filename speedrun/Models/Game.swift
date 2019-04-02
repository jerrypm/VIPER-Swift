import Foundation
import SwiftyJSON
import RealmSwift

class Game: Object {
  
  @objc dynamic var id: String = ""
  @objc dynamic var name: String = ""
  @objc dynamic var image: String = ""
  @objc dynamic var gameRun: GameRun?
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  func parseGame(json: JSON) {
    
    if json["id"].exists() {
      self.id = json["id"].stringValue
    }
    
    if json["names"]["international"].exists() {
      self.name = json["names"]["international"].stringValue
    }
    
    if json["assets"]["cover-medium"]["uri"].exists() {
      self.image = json["assets"]["cover-medium"]["uri"].stringValue
    }
    
  }
}
