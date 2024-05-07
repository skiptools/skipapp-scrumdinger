/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI
import AVKit

struct MeetingView: View {
    @Binding var scrum: DailyScrum
    @StateObject var scrumTimer = ScrumTimer()
    #if !SKIP
    @StateObject var speechRecognizer = SpeechRecognizer()
    #endif
    @State private var isRecording = false
    
    private var player: AVPlayer { sharedDingPlayer }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(scrum.theme.mainColor)
            VStack {
                MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed, secondsRemaining: scrumTimer.secondsRemaining, theme: scrum.theme)
                MeetingTimerView(speakers: scrumTimer.speakers, isRecording: isRecording, theme: scrum.theme)
                MeetingFooterView(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)
            }
        }
        .padding()
        .foregroundColor(scrum.theme.accentColor)
        .onAppear {
            startScrum()
        }
        .onDisappear {
            endScrum()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func startScrum() {
        scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
        scrumTimer.speakerChangedAction = {
            #if !SKIP
            player.seek(to: .zero)
            #endif
            player.play()
        }
        #if !SKIP
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        #endif
        isRecording = true
        scrumTimer.startScrum()
    }
    
    private func endScrum() {
        scrumTimer.stopScrum()
        #if !SKIP
        speechRecognizer.stopTranscribing()
        let transcript = speechRecognizer.transcript
        #else
        let transcript = "no transcript"
        #endif
        isRecording = false
        let newHistory = History(attendees: scrum.attendees,
                                 transcript: transcript)
        scrum.history.insert(newHistory, at: 0)
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
    }
}
