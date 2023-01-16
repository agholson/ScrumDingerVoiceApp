#  Scrum Dinger Voice App  
App keeps track of daily scrums, based on the tutorial by Apple: https://developer.apple.com/tutorials/app-dev-training/getting-started-with-scrumdinger

Here as of 1/15/23: https://developer.apple.com/tutorials/app-dev-training/persisting-data


# Play Custom Audio in App 
First, load the audio file in AVPlayer+Ding.swift as a custom AVPlayer:
```
import Foundation
import AVFoundation

extension AVPlayer {
    /// Initializes an AVPlayer with the ding.wav recording
    static let sharedDingPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "ding", withExtension: "wav") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
}

```
Next, call the audio in a custom closure in the SwiftUI app:
```
    /// Used for the next person's sound
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
```

Create a custom closure in your view model:
```
/// A closure that is executed when a new attendee begins speaking.
var speakerChangedAction: (() -> Void)?

// Calls the closure in this section of code
if secondsElapsedForSpeaker >= secondsPerSpeaker {
    changeToSpeaker(at: speakerIndex + 1)
    speakerChangedAction?()
}
```

Perform these actions in the closure here.
```
// Call this action as someone's time changes
scrumTimer.speakerChangedAction = {
    // In the closure, seek to time .zero in the audio file, which ensures it plays
    player.seek(to: .zero)
    // Then play the audio file
    player.play()
}         
```
