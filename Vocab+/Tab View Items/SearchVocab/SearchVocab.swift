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
            }
            .font(.system(size: 14))
            .navigationTitle("Search Word")
            .toolbarTitleDisplayMode(.inline)
        }
    }

}

#Preview {
    SearchVocab()
}
