import Foundation

class Constants {
    
  static let kNetworkURLAPI: String = "https://www.speedrun.com/api/v1"
  static let kNetworkURLGamesRequest: String = "/games"
  static let kNetworkURLGameRunRequest: String = "/runs?game="
  static let kNetworkURLGameRunUserRequest: String = "/users/"
  static let kNetworkHeaderApplicationJSON: [String : String] = ["Content-Type" : "application/json"]
  static let kSchemaVersion: UInt64 = 1
}
