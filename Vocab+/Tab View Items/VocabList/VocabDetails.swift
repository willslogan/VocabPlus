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
            Section(header: Text("Example")) {
                Text(word.example)
            }
        }   // End of Form
            .font(.system(size: 14))
            .navigationTitle(word.word)
            .toolbarTitleDisplayMode(.inline)
        
    }   // End of body var
}
