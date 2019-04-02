import UIKit
import Alamofire
import SwiftyJSON

class APIservice: NSObject {
  
  class func requestGetData(_ strURL: String, headers: [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error, Int) -> Void) {
    
    Alamofire.request(strURL, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
      
      #if DEBUG
        print(responseObject)
      #endif
      
      if responseObject.result.isSuccess {
        let resJson = JSON(responseObject.result.value!)
        success(resJson)
      }
      
      if responseObject.result.isFailure {
        let error : Error = responseObject.result.error!
        if (responseObject.response?.statusCode == nil) {
          failure(error, 0)
        } else {
          failure(error, (responseObject.response?.statusCode)!)
        }
      }
    }
  }
}
