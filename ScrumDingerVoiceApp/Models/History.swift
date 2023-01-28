//
//  History.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 1/15/23.
//

import Foundation

/// Keeps track of the history of Scrum meetings
struct History: Identifiable, Codable {
    let id: UUID
    let date: Date
    let attendees: [DailyScrum.Attendee]
    var lengthInMinutes: Int
    var transcript: String? // Optional transcript property
    
    // Provides default values for each property
    init(id: UUID = UUID(), date: Date = Date(), attendees: [DailyScrum.Attendee], lengthInMinutes: Int = 5, transcript: String? = nil) {
        self.id = id
        self.date = date
        self.attendees = attendees
        self.lengthInMinutes = lengthInMinutes
        self.transcript = transcript // Defaults to nil
    }
    
}

