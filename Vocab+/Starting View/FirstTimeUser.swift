//
//  FirstTimeUser.swift
//  Vocab+
//
//  Created by William Logan on 11/26/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI

struct FirstTimeUser: View {
    //State Vars
    @State private var firstName = ""
    @State private var lastName = ""
    
    //Alert
    @State private var showAlertMessage = false
    var body: some View {
        VStack(alignment: .center) {
            Text("Welcome To Vocab+")
            
            VStack(spacing: 10) {
                Text("Please enter your name:")
                    .padding(20)
                
                HStack {
                    TextField("First Name", text: $firstName)
                        .frame(width: 200.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                    
                }   // End of HStack
                
                HStack {
                    TextField("Last Name", text: $lastName)
                        .frame(width: 200.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                    
                }   // End of HStack
            }
            .padding(30)
            Text("Choose your profile picture:")
            
            Spacer()
        }
        
    }
}

#Preview {
    FirstTimeUser()
}
