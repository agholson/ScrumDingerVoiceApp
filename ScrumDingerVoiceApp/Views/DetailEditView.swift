//
//  DetailEditView.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 12/26/22.
//

import SwiftUI

struct DetailEditView: View {
    @Binding var data: DailyScrum.Data
    
    @State private var newAttendeeName = ""
    
    var body: some View {
        Form {
            // MARK: Meeting Title
            Section {
                
                    TextField("Title", text: $data.title)
                    
                    HStack {
                        Slider(value: $data.lengthInMinutes, in: 5...30, step: 1) {
                            Text("Length") // VoiceOver uses it for accessibility purposes
                        }
                        .accessibilityValue("\(Int(data.lengthInMinutes))")
                        
                        Text("\(Int(data.lengthInMinutes)) minutes")
                    }
                
                // MARK: Theme Picker
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(data.theme.mainColor)
                    ThemePicker(selection: $data.theme)
                }
                
            } header: {
                Text("Meeting Info")
            }
            
            // MARK: Edit Attendees
            Section {
                // Loop through the list of attendees
                ForEach(data.attendees, id: \.id) { attendee in
                    Text(attendee.name)
                } // Deletes the attendee, when swiped left
                .onDelete { indices in
                    data.attendees.remove(atOffsets: indices)
                }
                
            } header: {
                Text("Attendees")
            }
            
            // MARK: New Attendee
            HStack {
                TextField("New Attendee", text: $newAttendeeName)
                Button {
                    // Animates the action to more smoothly
                    withAnimation {
                        let attendee = DailyScrum.Attendee(name: newAttendeeName)
                        data.attendees.append(attendee)
                        newAttendeeName = ""
                    }
                } label: {
                    //  Makes plus sign on the right
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(newAttendeeName.isEmpty) // Disable the button, if nothing is there
            }
        }
    }
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(data: .constant(DailyScrum.sampleData[0].data))
    }
}
