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
    
    var body: some View {
        Form {
            // TODO: fill out Details screen
            Section(header: Text("Word")) {
                Text(word.word)
            }
            Section(header: Text("Definition")) {
                Text(word.definition)
            }
            Section(header: Text("Part of Speech")) {
                Text(word.partOfSpeech)
            }
            Section(header: Text("Source")) {
                Text(word.sourceName)
            }
            Section(header: Text("Audio")) {
                Text("Coming Soon...")
            }
            Section(header: Text("Image")) {
                Text("Coming Soon...")
            }
            Section(header: Text("Synonyms")) {
                Text("Coming Soon...")
            }
            Section(header: Text("Points Until Learned")) {
                Text("\(word.pointsUntilLearned)")
            }
        }   // End of Form
            .font(.system(size: 14))
            .navigationTitle(word.word)
            .toolbarTitleDisplayMode(.inline)
        
    }   // End of body var
}
