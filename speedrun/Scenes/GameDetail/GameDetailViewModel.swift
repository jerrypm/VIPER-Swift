import Foundation
import RxSwift

struct GameDetailViewModel {
  
  let showActivityIndicator = Variable<Bool?>(nil)
  let showNoInternetAlert = Variable<Bool?>(nil)
  let game = Variable<Game>(Game())
}
