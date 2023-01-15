//
//  History.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 1/15/23.
//

import Foundation

/// Keeps track of the history of Scrum meetings
struct History: Identifiable {
    let id: UUID = UUID()
    let date: Date = Date()
    let attendees: [DailyScrum.Attendee]
    var lengthInMinutes: Int = 5
    
    // Provides default values for each property
//    init(id: UUID = UUID(), date: Date = Date(), attendees: [DailyScrum.Attendee], lengthInMinutes: Int = 5) {
//        self.id = id
//        self.date = date
//        self.attendees = attendees
//        self.lengthInMinutes = lengthInMinutes
//    }
    
}

