//
//  UTCDateFormatter.swift
//  CTest3
//
//  Created by Markim Shaw on 3/1/21.
//

import Foundation

fileprivate let dateFormatterFromUTC: DateFormatter = {
  let dateFormatterFromUTC = DateFormatter()
  dateFormatterFromUTC.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
  dateFormatterFromUTC.timeZone = NSTimeZone(name: "UTC") as TimeZone?
  return dateFormatterFromUTC
}()


fileprivate let dateFormatterReadable: DateFormatter = {
  let dateFormatterReadable = DateFormatter()
  dateFormatterReadable.dateFormat = "EEE, MMM d, yyyy - h:mm a"
  dateFormatterReadable.timeZone = NSTimeZone.local
  return dateFormatterReadable
}()

class UTCFormatter: Formatter {
  func convertToDate(from dateString: String?) -> Date? {
    guard let dateString = dateString else { return nil }
    
    let date = dateFormatterFromUTC.date(from: dateString)
    
    return date
  }
  
  func convertToString(from date: Date?) -> String? {
    guard let date = date else { return nil }
    
    let readableDate = dateFormatterReadable.string(from: date)
    
    return readableDate
  }
}
