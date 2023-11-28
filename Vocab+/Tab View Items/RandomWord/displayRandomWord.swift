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
                Section(header: Text("Word:")) {
                    Text("\(word.word)")
                }
                
                Section(header: Text("Definition:")) {
                    Text("Coming Soon...")
                }
                
                Section(header: Text("Image:")) {
                    Text("Coming Soon...")
                }
                
                Section(header: Text("Example:")) {
                    Text("Coming Soon...")
                }
                
                Section(header: Text("Add Word To Vocab List")) {
                    
                    Button(action: {
                        
                    }){
                        HStack{
                            Image(systemName: "plus")
                            Text("Add Word")
                        }
                    }
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

#Preview {
    displayRandomWord(word: getRandomWordFromApi())
}
