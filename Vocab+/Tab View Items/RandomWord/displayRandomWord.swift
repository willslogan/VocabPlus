//
//  displayRandomWord.swift
//  Vocab+
//
//  Created by William Logan on 11/27/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI

struct displayRandomWord: View {
    let word: Word
    
    @State private var wordOfTheDay: String = "Loading..."
    @State private var photo: PexelsPhoto?
    @State private var showingAuthorAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Word")) {
                    Text(word.word)
                }
                
                if let unwrappedDefinitions = word.definitions {
                    ForEach(unwrappedDefinitions, id: \.self) { definition in
                        Section(header: Text("Definition")) {
                            Text("Definition: \(definition.definition)\n\nExample: \(definition.example)\n\nPart of Speech: \(definition.partOfSpeech)")
                        }
                    }
                }
                
                Section(header: Text("Image")) {
                    if word.imageUrl != "" {
                        GetImageFromUrl(stringUrl: word.imageUrl, maxWidth: 300)
                        
                        Button(action: { showingAuthorAlert.toggle() }) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 20))
                                .padding(10)
                        }
                        .alert(isPresented: $showingAuthorAlert) {
                            authorAlert
                        }
                    }
                    else {
                        Text("Sorry!\nNo image associated with\n\(word.word)")
                            .multilineTextAlignment(.center)
                            .frame(width: 300, height: 100, alignment: .center)
                            .background(Color.white)
                            .border(Color.black, width: 2)
                    }
                }
                
                Section(header: Text("Synonyms")) {
                    Text(synonymsArrayToString(synonyms: word.synonyms))
                }
                        
                Section(header: Text("Points Until Learned")) {
                    Text("\(word.pointsUntilLearned)")
                }
            }
            .navigationTitle("\(word.word)")
            .toolbarTitleDisplayMode(.inline)
        }
        
    }
    
    var authorAlert: Alert {
        Alert(
            title: Text("Photo Author"),
            message: Text(photo?.authorName ?? "No author information available"),
            primaryButton: .default(Text("Author Website"), action: {
                if let authorUrl = photo?.authorUrl, let url = URL(string: authorUrl) {
                    UIApplication.shared.open(url)
                }
            }),
            secondaryButton: .cancel()
        )
    }
}

