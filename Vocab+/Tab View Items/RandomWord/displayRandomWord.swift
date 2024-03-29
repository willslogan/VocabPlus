//
//  displayRandomWord.swift
//  Vocab+
//
//  Created by William Logan on 11/27/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI

struct displayRandomWord: View {
    let word: WordStruct
    
    @State private var wordOfTheDay: String = "Loading..."
    @State private var photo: PexelsPhoto?
    @State private var showingAuthorAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Word")) {
                    Text(word.word)
                }
                
                ForEach(word.definitions, id: \.self) { definition in
                    Section(header: Text("Definition")) {
                        Text(definitionToString(definition: definition))
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
    
    func definitionToString(definition: DefinitionStruct) -> String {
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
}

