//
//  FirstTimeUser.swift
//  Vocab+
//
//  Created by William Logan on 11/26/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI

struct FirstTimeUser: View {
    //columns for lazy grid
    let columnsSpec: [GridItem] = [
        GridItem(.fixed(75), spacing: 10, alignment: .center),
        GridItem(.fixed(75), spacing: 10, alignment: .center),
        GridItem(.fixed(75), spacing: 10, alignment: .center),
        GridItem(.fixed(75), spacing: 10, alignment: .center)
    ]
    
    //Default Profile names
    let defaultImages = ["cat", "dog", "lion", "monkey", "snake", "panda", "penguin", "rhino"]
    
    //State Vars
    @State private var firstName = ""
    @State private var lastName = ""
    
    //Image
    @State private var selectedImageIndex = 0
    @State private var showImagePicker = false
    @State private var chosenUIImage: UIImage?
    @State private var chosenImage: Image?
    
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
            
            VStack {
                Text("Choose your profile picture:")

                LazyVGrid(columns: columnsSpec) {
                    ForEach(0..<defaultImages.count) { index in
                        Image(defaultImages[index])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Rectangle()
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(selectedImageIndex == index ? .blue : .black)
                            )
                            .onTapGesture {
                                selectedImageIndex = index
                            }
                    }
                }
                .padding(8)
                
                Button(action: {
                    showImagePicker = true
                    
                }){
                    HStack {
                        Image(systemName: "plus")
                            .imageScale(.small)
                            .font(Font.title.weight(.regular))
                        Text("Upload Custom Image     ")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(.white)
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(5)
                    .padding(5)
                    
                }
                
                if chosenImage != nil {
                    VStack {
                        Text("Current Custom Photo: ")
                        
                        chosenImage?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50.0, height: 50.0)
                            .overlay(
                                Rectangle()
                                    .stroke(lineWidth: 2)
                            )
                    }
                    .padding(10)
                }
                
                VStack {
                    Text("Ready To Begin?")
                        .font(.system(size: 30))
                }
                .frame(width: 300.0, height: 100.0)
                .background(Color.blue.opacity(0.5))
                .cornerRadius(10)
                .padding(40)
                .onTapGesture {
                    
                }
            }
            
            Spacer()
        }
        .onChange(of: chosenUIImage) {
            guard let uiImageChosen = chosenUIImage else { return }
            
            // Convert UIImage to SwiftUI Image
            chosenImage = Image(uiImage: uiImageChosen)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(uiImage: $chosenUIImage,
                        sourceType: .photoLibrary,
                        imageWidth: 500.0,
                        imageHeight: 281.25
            )
        }
        
    }
}

#Preview {
    FirstTimeUser()
}
