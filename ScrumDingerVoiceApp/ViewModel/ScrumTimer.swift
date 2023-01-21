//
//  ScrumTimer.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 1/1/23.
//

import Foundation

/// Keeps time for a daily scrum meeting. Keep track of the total meeting time, the time for each speaker, and the name of the current speaker.
class ScrumTimer: ObservableObject {
    /// A struct to keep track of meeting attendees during a meeting.
    struct Speaker: Identifiable {
        /// The attendee name.
        let name: String
        /// True if the attendee has completed their turn to speak.
        var isCompleted: Bool
        /// Id for Identifiable conformance.
        let id = UUID()
    }
    
    /// The name of the meeting attendee who is speaking.
    @Published var activeSpeaker = ""
    /// The number of seconds since the beginning of the meeting.
    @Published var secondsElapsed = 0
    /// The number of seconds until all attendees have had a turn to speak.
    @Published var secondsRemaining = 0
    /// All meeting attendees, listed in the order they will speak.
    private(set) var speakers: [Speaker] = []
    
    /// The scrum meeting length.
    private(set) var lengthInMinutes: Int
    /// A closure that is executed when a new attendee begins speaking.
    var speakerChangedAction: (() -> Void)?
    
    private var timer: Timer?
    private var timerStopped = false
    private var frequency: TimeInterval { 1.0 / 60.0 }
    private var lengthInSeconds: Int { lengthInMinutes * 60 }
    private var secondsPerSpeaker: Int {
        (lengthInMinutes * 60) / speakers.count
    }
    private var secondsElapsedForSpeaker: Int = 0
    private var speakerIndex: Int = 0
    private var speakerText: String {
        return "Speaker \(speakerIndex + 1): " + speakers[speakerIndex].name
    }
    private var startDate: Date?
    
    /**
     Initialize a new timer. Initializing a time with no arguments creates a ScrumTimer with no attendees and zero length.
     Use `startScrum()` to start the timer.
     
     - Parameters:
     - lengthInMinutes: The meeting length.
     -  attendees: A list of attendees for the meeting.
     */
    init(lengthInMinutes: Int = 0, attendees: [DailyScrum.Attendee] = []) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.speakers
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }
    
    /// Start the timer.
    func startScrum() {
        changeToSpeaker(at: 0)
    }
    
    /// Stop the timer.
    func stopScrum() {
        timer?.invalidate()
        timer = nil
        timerStopped = true
    }
    
    /// Advance the timer to the next speaker.
    func skipSpeaker() {
        changeToSpeaker(at: speakerIndex + 1)
    }
    
    //This function changes the speaker at the given index.
    /// Changes the active speaker to the speaker at the given index. It also updates the seconds elapsed and remaining for the current speaker,
    /// sets the start date for a timer, and schedules the timer to call the update function with the number of seconds elapsed as its argument, at a given frequency. It
    /// also checks if the previous speaker has completed speaking and sets the 'isCompleted' property to true.
    private func changeToSpeaker(at index: Int) {
        //If the index is greater than 0, it sets the previous speaker's 'isCompleted' property to true.
        if index > 0 {
            let previousSpeakerIndex = index - 1
            speakers[previousSpeakerIndex].isCompleted = true
        }
        
        secondsElapsedForSpeaker = 0
        
        //guard statement to check if index is less than the number of speakers. If not, it returns.
        guard index < speakers.count else { return }
        
        //Sets the current speaker index and active speaker
        speakerIndex = index
        activeSpeaker = speakerText
        
        //Calculates the seconds elapsed and remaining for the current speaker
        secondsElapsed = index * secondsPerSpeaker
        secondsRemaining = lengthInSeconds - secondsElapsed
        
        //Sets the start date for the timer
        startDate = Date()
        
        //Schedules a timer that updates the seconds elapsed and calls the update function with the seconds elapsed as its argument
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] timer in
            if let self = self, let startDate = self.startDate {
                let secondsElapsed = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
                self.update(secondsElapsed: Int(secondsElapsed))
            }
        }
    }
    
    private func update(secondsElapsed: Int) {
        secondsElapsedForSpeaker = secondsElapsed
        self.secondsElapsed = secondsPerSpeaker * speakerIndex + secondsElapsedForSpeaker
        guard secondsElapsed <= secondsPerSpeaker else {
            return
        }
        secondsRemaining = max(lengthInSeconds - self.secondsElapsed, 0)
        
        guard !timerStopped else { return }
        
        if secondsElapsedForSpeaker >= secondsPerSpeaker {
            changeToSpeaker(at: speakerIndex + 1)
            speakerChangedAction?()
        }
    }
    
    /**
     Reset the timer with a new meeting length and new attendees.
     
     - Parameters:
     - lengthInMinutes: The meeting length.
     - attendees: The name of each attendee.
     */
    func reset(lengthInMinutes: Int, attendees: [DailyScrum.Attendee]) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.speakers
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }
}

extension DailyScrum {
    /// A new `ScrumTimer` using the meeting length and attendees in the `DailyScrum`.
    var timer: ScrumTimer {
        ScrumTimer(lengthInMinutes: lengthInMinutes, attendees: attendees)
    }
}

/// Create a special computed property for each attendee
extension Array where Element == DailyScrum.Attendee {
    /// Creates a list of Speakers either "Speaker 1," if no speaker is set; else each speaker's name followed by isCompleted being false
    var speakers: [ScrumTimer.Speaker] {
        if isEmpty {
            return [ScrumTimer.Speaker(name: "Speaker 1", isCompleted: false)]
        } else {
            return map { ScrumTimer.Speaker(name: $0.name, isCompleted: false) }
        }
    }
}
