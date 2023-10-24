//
//  SleepData.swift
//  Sleep
//
//  Created by apple on 24/10/23.
//


import Foundation

struct SleepData: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var sleepTime: Date
    var wakeTime: Date

    var duration: TimeInterval {
        return wakeTime.timeIntervalSince(sleepTime)
    }
}
