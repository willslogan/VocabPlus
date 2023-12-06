//
//  VocabList.swift
//  Vocab+
//
//  Created by William Logan on 11/21/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI
import SwiftData

struct VocabList: View {
    
    @Environment(\.modelContext) private var modelContext
    private var currentUser = obtainUser()
    @State private var selectedListType = 0  // 0 for learnedWords, 1 for favoriteWords
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
    @State private var pexelsPhoto: PexelsPhoto?
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Select List", selection: $selectedListType) {
                    Text("Learned Words").tag(0)
                    Text("Favorite Words").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedListType == 0 && (currentUser.learnedWords?.isEmpty ?? true) {
                    Form {Section {
                        Text("You currently do not have any learned words! Visit the Vocab Quiz tab to learn new words.")
                            .font(.system(size: 14))
                            .padding()
                    }
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(currentWords, id: \.self) { word in
                            NavigationLink(destination: VocabDetails(word: word)) {
                                VocabItem(word: word)
                                    .alert(isPresented: $showConfirmation) {
                                        Alert(title: Text("Delete Confirmation"),
                                              message: Text("Are you sure to permanently remove this word from your favorites?"),
                                              primaryButton: .destructive(Text("Delete")) {
                                            deleteWord(word)
                                        }, secondaryButton: .cancel()
                                        )
                                    }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .font(.system(size: 14))
            .navigationTitle("Vocab List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
    }
    
    private var currentWords: [Word] {
        selectedListType == 0 ? (currentUser.learnedWords ?? []) : (currentUser.favoriteWords ?? [])
    }
    
    private func deleteWord(_ word: Word) {
        if selectedListType == 0 {
            currentUser.learnedWords?.removeAll(where: { $0 == word })
        } else {
            currentUser.favoriteWords?.removeAll(where: { $0 == word })
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            if index < currentWords.count {
                let wordToDelete = currentWords[index]
                deleteWord(wordToDelete)
            }
        }
    }
}
