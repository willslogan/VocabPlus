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
    @State private var showingAuthorAlert = false
    
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
                    Group {
                        Section(header: Text("Word")) {
                            Text(foundWord.word)
                        }
                        
                        if let unwrappedDefinitions = foundWord.definitions {
                            ForEach(unwrappedDefinitions, id: \.self) { definition in
                                Section(header: Text("Definition")) {
                                    Text(definitionToString(definition: definition))
                                }
                            }
                        }
                        
                        Section(header: Text("Image")) {
                            if foundWord.imageUrl != "" {
                                GetImageFromUrl(stringUrl: foundWord.imageUrl, maxWidth: 300)
                                
                                Button(action: { showingAuthorAlert.toggle() }) {
                                    Image(systemName: "info.circle")
                                        .font(.system(size: 20))
                                        .padding(10)
                                }
                                .alert(isPresented: $showingAuthorAlert) {
                                    authorAlert
                                }
                            }
                            else {
                                Text("Sorry!\nNo image associated with\n\(foundWord.word)")
                                    .multilineTextAlignment(.center)
                                    .frame(width: 300, height: 100, alignment: .center)
                                    .background(Color.white)
                                    .border(Color.black, width: 2)
                            }
                        }
                        
                        Section(header: Text("Synonyms")) {
                            Text(synonymsArrayToString(synonyms: foundWord.synonyms))
                        }
                                
                        Section(header: Text("Points Until Learned")) {
                            Text("\(foundWord.pointsUntilLearned)")
                        }
                    } // end of group
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
    var authorAlert: Alert {
        Alert(
            title: Text("Photo Author"),
            message: Text(foundWord.imageAuthor),
            primaryButton: .default(Text("Author Website"), action: {
                if let url = URL(string: foundWord.imageAuthorUrl) {
                    UIApplication.shared.open(url)
                }
            }),
            secondaryButton: .cancel()
        )
    }
    
    func definitionToString(definition: Definition) -> String {
        var toReturn = "Definition: \(definition.definition)"
        if !definition.example.isEmpty {
            toReturn += "\n\nExample: \(definition.example)"
        }
        if !definition.partOfSpeech.isEmpty {
            toReturn += "\n\nPart of Speech: \(definition.partOfSpeech)"
        }
        return toReturn
    }
} // End of SearchVocab
