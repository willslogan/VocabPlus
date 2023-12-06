//
//  SearchVocab.swift
//  Vocab+
//
//  Created by William Logan on 11/21/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI
import SwiftData

fileprivate let currentUser = obtainUser()

struct SearchVocab: View {
    
    
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Word>(sortBy: [SortDescriptor(\Word.word, order: .forward)])) private var wordList: [Word]
    
    @State private var wordAddedToDatabase = false // To track whether the word was added to the database
    @State private var searchTerm = ""
    @State private var searchCompleted = false
    
    //Alert
    @State private var showAlertMessage = false
    @State private var showingAuthorAlert = false
        @State private var alertTitle = ""
        @State private var alertMessage = ""
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
                            Button(wordAddedToDatabase ? "Word Added to Database" : "Add to Database") {
                                if inputDataValidated() {
                                    addWordToDatabase()
                                } else {
                                    showAlertMessage = true
                                    alertTitle = "Missing Input Data!"
                                    alertMessage = "Please enter a search query"
                                }
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)

                        }
                        
                        ForEach(foundWord.definitions, id: \.self) { definition in
                            Section(header: Text("Definition")) {
                                Text(definitionToString(definition: definition))
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
                    } // end of group
                }
            } // End of form
            .font(.system(size: 14))
            .navigationTitle("Search Word")
            .toolbarTitleDisplayMode(.inline)
            .alert(isPresented: $showAlertMessage) {
                                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                            }
        }
    }
    
    private func addWordToDatabase() {
        
        if wordList.contains(where: { existingWord in
            existingWord.word == foundWord.word
        }) {
            alertTitle = "Error!"
            alertMessage = "Selected word already exists in the database as a favorite"
            showAlertMessage = true
            return
        }
        // Convert each DefinitionStruct to your Definition class
        let definitionsArray = foundWord.definitions.map { definitionStruct -> Definition in
            return Definition(definition: definitionStruct.definition,
                              partOfSpeech: definitionStruct.partOfSpeech,
                              example: definitionStruct.example)
        }
        
        // Initialize the new Word object with definitions
        let newWord = Word(word: foundWord.word,
                           audioUrl: foundWord.audioUrl,
                           imageUrl: foundWord.imageUrl,
                           imageAuthor: foundWord.imageAuthor,
                           imageAuthorUrl: foundWord.imageAuthorUrl,
                           synonyms: foundWord.synonyms,
                           pointsUntilLearned: foundWord.pointsUntilLearned,
                           definitions: definitionsArray)
        // Save changes to the database
        modelContext.insert(newWord)
        print(wordList)
//        if currentUser.learnedWords!.contains(newWord) {
//            currentUser.learnedWords!.append(newWord)
//            alertTitle = "Error!"
//            alertMessage = "Selected word already exists in your favorite list"
//            showAlertMessage = true
//        }
//        else {
//            // Update UI
//            alertTitle = "Word Added!"
//            alertMessage = "Selected word is added to the favorite list"
//            showAlertMessage = true
//        }
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
        searchCompleted = true
        print("Found Word: \(foundWord.word)")
        print("Found Word's audio: \(foundWord.audioUrl)")
        print("Found Word's image url: \(foundWord.imageUrl)")
        print("Found Word's image author: \(foundWord.imageAuthor)")
        print("Found Word's image author url: \(foundWord.imageAuthorUrl)")
        print("Found Word's synonms: \(foundWord.synonyms)")
        print("Found Word's pointsUntilLearned: \(foundWord.pointsUntilLearned)")
        print("Found Word's definitions: \(foundWord.definitions)")
    }

    
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
    
    func definitionToString(definition: DefinitionStruct) -> String {
        var toReturn = "Definition: \(definition.definition)"
        if !definition.example.isEmpty {
            toReturn += "\n\nExample: \(definition.example)"
        }
        if !definition.partOfSpeech.isEmpty {
            toReturn += "\n\nPart of Speech: \(definition.partOfSpeech)"
        }
        toReturn = toReturn.replacingOccurrences(of: "<er>", with: "")
        toReturn = toReturn.replacingOccurrences(of: "</er>", with: "")
        return toReturn
    }
} // End of SearchVocab
