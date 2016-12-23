//
//  NSDateExtension.swift
//  budget
//
//  Created by Azam Rahmat on 8/5/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import Foundation


extension NSDate {
    
    
    func getDatesOfRange(calendarUnit : NSCalendarUnit ) -> (startDate : NSDate, endDate : NSDate)
    {
        let cal = NSCalendar.currentCalendar()
        var beginning : NSDate?
        var end : NSDate?
        
        let components = NSDateComponents()
        
        if calendarUnit == .WeekOfYear
        {
            
            cal.firstWeekday = 2
        }
        
        if let date = cal.dateByAddingComponents(components, toDate: self, options: NSCalendarOptions(rawValue: 0)) {
            var duration = NSTimeInterval()
            if cal.rangeOfUnit(calendarUnit, startDate: &beginning, interval: &duration, forDate: date) {
                end = beginning?.dateByAddingTimeInterval(duration)
                let seconds = Double(NSTimeZone.localTimeZone().secondsFromGMT)
                beginning = beginning!.dateByAddingTimeInterval(seconds)// Optional(2015-02-15 05:00:00 +0000)
                end = end!.dateByAddingTimeInterval(seconds - 1)// Optional(2015-02-22 05:00:00 +0000)
            }
        }
        
        
        return (beginning!, end!)
    }
    class func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:NSDateComponents = calendar.components([NSCalendarUnit.Minute , NSCalendarUnit.Hour , NSCalendarUnit.Day , NSCalendarUnit.WeekOfYear , NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Second], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
        
        if (components.year >= 2) {
            return "\(components.year) years ago"
        } else if (components.year >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month >= 2) {
            return "\(components.month) months ago"
        } else if (components.month >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear >= 2) {
            return "\(components.weekOfYear) weeks ago"
        } else if (components.weekOfYear >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day >= 2) {
            return "\(components.day) days ago"
        } else if (components.day >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour >= 2) {
            return "\(components.hour) hours ago"
        } else if (components.hour >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute >= 2) {
            return "\(components.minute) minutes ago"
        } else if (components.minute >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second >= 3) {
            return "\(components.second) seconds ago"
        } else {
            return "Just now"
        }
        
    }
}