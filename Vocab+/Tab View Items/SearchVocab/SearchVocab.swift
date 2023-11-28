//
//  SearchVocab.swift
//  Vocab+
//
//  Created by William Logan on 11/21/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI

struct SearchVocab: View {
    
    @State private var searchTerm = ""
    @State private var searchCompleted = false
    
    //Alert
    @State private var showAlertMessage = false
    
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 60, alignment: .center)
                    Spacer()
                }
                
                Section(header: Text("Search for a word")) {
                    HStack {
                        TextField("Enter Word Here", text: $searchTerm)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                        
                        // Button to clear the text field
                        Button(action: {
                            searchTerm = ""
                            searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                        
                    }   // End of HStack
                }
                
                Section() {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                formatAndSearchAPI()
                                searchCompleted = true
                            } else {
                                showAlertMessage = true
                                alertTitle = "Missing Input Data!"
                                alertMessage = "Please enter a search query"
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                        
                    }   // End of HStack
                }
                
                if searchCompleted {
                    Section(header: Text("Word")) {
                        Text(foundWord.word)
                    }
                    
//                    if let unwrappedDefinitions = foundWord.definitions {
//                        if unwrappedDefinitions.count > 0 {
//                            Section(header: Text("Definition")) {
//                                Text(unwrappedDefinitions[0].definition)
//                            }
//                        }
//                    }
                    
                    Section(header: Text("Image")) {
                        GetImageFromUrl(stringUrl: foundWord.imageUrl, maxWidth: 300)
                    }
                }
            } // End of form
            .font(.system(size: 14))
            .navigationTitle("Search Word")
            .toolbarTitleDisplayMode(.inline)
        }
    }
    
    func inputDataValidated() -> Bool {
        
        let searchTermTrimmed = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if searchTermTrimmed.isEmpty {
            return false
        }
        
        return true
    } // end of inputDataValidated

    func formatAndSearchAPI() {
        let searchTermTrimmed = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        getFoundWordFromApi(searchTerm: searchTermTrimmed)
        print(foundWord.word)
        
    } // end of formatAndSearchAPI
} // End of SearchVocab

#Preview {
    SearchVocab()
}
