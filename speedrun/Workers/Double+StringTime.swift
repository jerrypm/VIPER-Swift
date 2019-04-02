import Foundation

extension Double {
  
  func stringFromInterval() -> String {
    
    let timeInterval = Int(self)
    
    let secondsInt = timeInterval % 60
    let minutesInt = (timeInterval / 60) % 60
    let hoursInt = (timeInterval / 3600) % 24
    let daysInt = timeInterval / 86400
    
    let seconds = "\(secondsInt)s"
    let minutes = "\(minutesInt)m" + " " + seconds
    let hours = "\(hoursInt)h" + " " + minutes
    let days = "\(daysInt)d" + " " + hours
    
    if daysInt          > 0 { return days }
    if hoursInt         > 0 { return hours }
    if minutesInt       > 0 { return minutes }
    if secondsInt       > 0 { return seconds }
    return ""
  }
}
