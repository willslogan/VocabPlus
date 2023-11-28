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
        NavigationStack {
            Form {
                Section(header: Text("Word")) {
                    Text(word.word)
                }
                
                Section(header: Text("Definition")) {
                    Text("Coming Soon...")
                    
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
            } // End of navigation stack
        }   // End of body var
    }
}
