//
//  RandomWord.swift
//  Vocab+
//
//  Created by William Logan on 11/21/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI

struct RandomWord: View {
    
    @State private var currWord = getRandomWordFromApi()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "shuffle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200, alignment: .center)
                    .padding(100)
                
                HStack {
                    Button(action: {
                        currWord = getRandomWordFromApi()
                    }) {
                        VStack {
                            Image(systemName: "arrow.clockwise")
                        }
                        .frame(width: 50, height: 100.0)
                        .foregroundStyle(Color.white)
                        .background(Color.blue.opacity(0.5))
                        .cornerRadius(10)
                    }
                    
                    if let unwrappedWord = currWord {
                        NavigationLink(destination: displayRandomWord(word: unwrappedWord)){
                            VStack {
                                Text("Random Word")
                                    .font(.system(size: 30))
                            }
                            .frame(width: 300.0, height: 100.0)
                            .foregroundStyle(Color.white)
                            .background(Color.blue.opacity(0.5))
                            .cornerRadius(10)
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Random Word")
            .toolbarTitleDisplayMode(.inline)
        }
    }
    
    
    
}

#Preview {
    RandomWord()
}
