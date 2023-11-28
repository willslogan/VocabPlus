//
//  VocabItem.swift
//  Vocab+
//
//  Created by Anthony Laraway on 11/26/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI

struct VocabItem: View {
    
    // Input Parameter
    let word: Word
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(word.word)
                    .font(.system(size: 22))
                Text(word.partOfSpeech)
                    .font(.system(size: 14))
            }
        }
    }
}
