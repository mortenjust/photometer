//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var isPhoto = false


let start = NSDate(timeIntervalSince1970: 30103)
let end = NSDate(timeIntervalSince1970: 230000303)







func getDifferenceString(start:NSDate, end:NSDate) -> String {
    let calendar: NSCalendar = NSCalendar.currentCalendar()

    let components = calendar.components([.Day, .Hour, .Minute, .Second],
        fromDate: start,
        toDate: end,
        options: [])
    
    let d = components.day
    let h = components.hour
    let m = components.minute
    let s = components.second
    
    let elapsedTimeString = String(format: "%02d:%02d:%02d.%02d", arguments: [d, h, m, s])
    return elapsedTimeString
}

let fl = 43.2/6
round(fl)

getDifferenceString(start, end: end)