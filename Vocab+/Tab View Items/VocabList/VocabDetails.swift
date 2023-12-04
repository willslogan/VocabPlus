//
//  VocabDetails.swift
//  Vocab+
//
//  Created by Anthony Laraway on 11/26/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI


struct VocabDetails: View {
    // Input Parameter
    let word: Word
    
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
                            Text(definitionToString(definition: definition))
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
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle(word.word)
            .toolbarTitleDisplayMode(.inline)
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
        return toReturn
    }
}

