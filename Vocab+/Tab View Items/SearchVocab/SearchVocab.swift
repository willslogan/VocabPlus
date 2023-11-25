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
    @State private var imageInfo = [String]()
    
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
                    Section(header: Text("Test: Image Info retrieval")){
                        if imageInfo.count == 3 {
                            Text(imageInfo[0])
                            Text(imageInfo[1])
                            Text(imageInfo[2])
                        } else {
                            Text("Error Occured Retreiving Image Info")
                        }
                    }
                }
            }
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
    }

    func formatAndSearchAPI() {
        let searchTermTrimmed = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        
        imageInfo = getImageInfoFromApi(searchTerm: searchTermTrimmed)
        
        
    }
}

#Preview {
    SearchVocab()
}
