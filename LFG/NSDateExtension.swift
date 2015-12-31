//
//  NSDateExtension.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-28.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import Foundation

extension NSDate {
    
    var isOlderThanFiveMinutes: Bool {
        
        // TODO: Change back to five minutes
        let fiveMinutesAgo = NSDate(timeInterval: -300, sinceDate: NSDate())
        
        if self.compare(fiveMinutesAgo) == NSComparisonResult.OrderedAscending {
            return true
        }
        
        print("Time until user can post again: \(self.timeIntervalSinceDate(fiveMinutesAgo))")
        
        return false
    }
}