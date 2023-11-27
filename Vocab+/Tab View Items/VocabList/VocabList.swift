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
    // Sort alphabetically
    @Query(FetchDescriptor<Word>(sortBy: [SortDescriptor(\Word.word, order: .forward)])) private var listOfAllWordsInDatabase: [Word]
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listOfAllWordsInDatabase) { aWord in
                    NavigationLink(destination: VocabDetails(word: aWord)) {
                        VocabItem(word: aWord)
                            .alert(isPresented: $showConfirmation) {
                                Alert(title: Text("Delete Confirmation"),
                                      message: Text("Are you sure to permanently remove this word from your favorites?"),
                                      primaryButton: .destructive(Text("Delete")) {
                                    /*
                                     'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                                      element to be deleted. It is nil if the array is empty. Process it as an optional.
                                     */
                                     if let index = toBeDeleted?.first {
                                         let wordToDelete = listOfAllWordsInDatabase[index]
                                         modelContext.delete(wordToDelete)
                                     }
                                     toBeDeleted = nil
                                 }, secondaryButton: .cancel() {
                                     toBeDeleted = nil
                                 }
                             )
                        }   // End of alert
                    }
                }
                .onDelete(perform: delete)
                
            }   // End of List
            .font(.system(size: 14))
            .navigationTitle("Vocab List")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                // Place the Edit button on left side of the toolbar
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }   // End of toolbar
            
        }   // End of NavigationStack
    }   // End of body var
    
    /*
     ----------------------------
     MARK: Delete Selected Recipe
     ----------------------------
     */
    func delete(at offsets: IndexSet) {
        
        toBeDeleted = offsets
        showConfirmation = true
    }
    
}   // End of struct
