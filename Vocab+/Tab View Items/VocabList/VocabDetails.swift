//
//  VocabDetails.swift
//  Vocab+
//
//  Created by Anthony Laraway on 11/26/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI
import AVFoundation


struct VocabDetails: View {
    // Input Parameter
    let word: Word
    let audioPlayer: AVPlayer
    
    @State private var audioRate: Float = 0.0
    @State private var pexelsPhoto: PexelsPhoto?
    @State private var showingAuthorAlert = false
    @State private var timerRate = Timer.publish(every: .infinity, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Word")) {
                    Text(word.word)
                }
                if let unwrappedDefinitions = word.definitions {
                    ForEach(unwrappedDefinitions, id: \.self) { definition in
                        Section(header: Text("Definition")) {
                            Text(definitionToString(definition: definition))
                        }
                    }
                }
                Section(header: Text("Image")) {
                    if !word.imageUrl.isEmpty {
                        GetImageFromUrl(stringUrl: word.imageUrl, maxWidth: 300)
                        
                        Button(action: { showingAuthorAlert.toggle() }) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 20))
                                .padding(10)
                        }
                        .alert(isPresented: $showingAuthorAlert) {
                            authorAlert
                        }
                    } else {
                        Text("Sorry!\nNo image associated with\n\(word.word)")
                            .multilineTextAlignment(.center)
                            .frame(width: 300, height: 100, alignment: .center)
                            .background(Color.white)
                            .border(Color.black, width: 2)
                    }
                }
                Section(header: Text("Pronounciation")) {
                    HStack {
                        if urlOfCurrentlyPlayingInPlayer(player: audioPlayer) != nil {
                            Button(action: {
                                startTimer()
                                if audioRate > 0 {
                                    audioPlayer.pause()
                                } else {
                                    audioPlayer.seek(to: CMTime.zero)
                                    audioPlayer.play()
                                }
                            }) {
                                Image(systemName: audioRate > 0 ? "pause.fill" : "play.fill")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                    .foregroundColor(.blue)
                                    .onReceive(timerRate) { _ in
                                        audioRate = audioPlayer.rate
                                    }
                            }
                            
                            Text("How to pronounce: \(word.word)")
                        } else {
                            Text("Sorry no audio to play")
                        }
                    }
                }
                Section(header: Text("Synonyms")) {
                    Text(synonymsArrayToString(synonyms: word.synonyms))
                }
                
                Section(header: Text("Points Until Learned")) {
                    Text("\(word.pointsUntilLearned)")
                }
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle(word.word)
            .toolbarTitleDisplayMode(.inline)
            
            .onDisappear() {
                audioPlayer.pause()
                audioPlayer.seek(to: CMTime.zero)
                stopTimer()
            }
        } // End of navigation stack
    }   // End of body var
    
    var authorAlert: Alert {
        Alert(
            title: Text("Photo Author"),
            message: Text(word.imageAuthor),
            primaryButton: .default(Text("Author Website"), action: {
                if let url = URL(string: word.imageAuthorUrl) {
                    UIApplication.shared.open(url)
                }
            }),
            secondaryButton: .cancel()
        )
    }
    
    func definitionToString(definition: Definition) -> String {
        var toReturn = "Definition: \(definition.definition)"
        if !definition.example.isEmpty {
            toReturn += "\n\nExample: \(definition.example)"
        }
        if !definition.partOfSpeech.isEmpty {
            toReturn += "\n\nPart of Speech: \(definition.partOfSpeech)"
        }
        toReturn = toReturn.replacingOccurrences(of: "<er>", with: "")
        toReturn = toReturn.replacingOccurrences(of: "</er>", with: "")
        return toReturn
    }
    
    func startTimer() {
        timerRate = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timerRate.upstream.connect().cancel()
    }
    
    //This Code was found online here:
    //https://stackoverflow.com/questions/1605846/avaudioplayer-with-external-url-to-m4p
    
    func urlOfCurrentlyPlayingInPlayer(player : AVPlayer) -> URL? {
        return ((player.currentItem?.asset) as? AVURLAsset)?.url
    }
    
}



