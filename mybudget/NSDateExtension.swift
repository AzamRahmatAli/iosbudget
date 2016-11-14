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
}