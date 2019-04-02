import Foundation
import RxSwift

struct WelcomeListViewModel {
  
  let showActivityIndicator = Variable<Bool?>(nil)
  let showNoInternetAlert = Variable<Bool?>(nil)
  let gameArray = Variable<[Game]>([])
}
