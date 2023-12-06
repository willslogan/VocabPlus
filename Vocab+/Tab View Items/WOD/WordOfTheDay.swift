//
//  WordOfTheDay.swift
//  Vocab+
//
//  Created by William Logan on 11/21/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI

fileprivate let currentUser = obtainUser()

struct WordOfTheDay: View {
    
    var firstName: String
    @State private var wordOfTheDay: String = "Loading..."
    @State private var photo: PexelsPhoto?
    @State private var showingAuthorAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                //Profile View
                VStack(alignment: .leading) {
                    NavigationLink(destination: Profile()) {
                        HStack {
                            let fileName = currentUser.profileImageName.components(separatedBy: ".")[0]
                            let fileExtension = currentUser.profileImageName.components(separatedBy: ".")[1]
                            getImageFromDocumentDirectory(filename: fileName, fileExtension: fileExtension, defaultFilename: "ImageUnavailable")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                            
                            VStack (alignment: .leading) {
                                Text("\(currentUser.firstName) \(currentUser.lastName)")
                                HStack {
                                    Text("Level: ")
                                    Text("\(currentUser.level)")
                                        .font(.system(size: 9))
                                        .bold()
                                        .frame(width: 20, height: 20)
                                        .overlay {
                                            Circle()
                                                .stroke(lineWidth: 1.2)
                                                .foregroundColor(Color(red: 0/255, green: 0/255, blue: 139/255))
                                        }
                                    
                                }
                            }
                            Spacer()
                        }
                        .frame(width: 200, height: 75)
                        .background(.black.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .foregroundStyle(.black)
                }
                VStack {
                    Text("Welcome \(firstName),\nReady to improve your vocab?")
                        .multilineTextAlignment(.center)
                        .frame(width: 300, height: 100, alignment: .center)
                        .background(Color.white)
                        .border(Color.black, width: 2)
                    
                    ZStack(alignment: .topTrailing) {
                        if let photo = photo {
                            GetImageFromUrl(stringUrl: photo.imageUrl, maxWidth: 300)
                            
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
                            Text("Sorry!\nNo image associated with\n\(wordOfTheDay)")
                                .multilineTextAlignment(.center)
                                .frame(width: 300, height: 100, alignment: .center)
                                .background(Color.white)
                                .border(Color.black, width: 2)
                        }
                    }
                    Text("Word Of the Day\n\(wordOfTheDay)")
                        .multilineTextAlignment(.center)
                        .frame(width: 300, height: 100, alignment: .center)
                        .background(Color.white)
                        .border(Color.black, width: 2)
                        .font(.title)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Text("Powered By")
                    if let url = URL(string: "https://developer.wordnik.com") {
                        Link(destination: url) {
                            HStack {
                                Image("wordnik")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                Text("Wordnik API")
                            }
                        }
                        .padding()
                    }
                    if let url = URL(string: "https://www.pexels.com/api/documentation/") {
                        Link(destination: url) {
                            HStack {
                                Image("pexels")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                Text("Pexels API")
                            }
                        }
                        .padding(.bottom, 100)
                    }
                }
                .padding()
                .navigationTitle("Vocab+")
                .toolbarTitleDisplayMode(.inline)
                .onAppear {
                    fetchWordOfTheDay()
//                    // Note: image already displays a not found message without this feature
//                    if let pexelsPhoto = fetchImageFromPexels(word: wordOfTheDay) {
//                        // Use the fetched PexelsPhoto
//                        self.photo = pexelsPhoto
//                    } else {
//                        // Handle the failure case
//                        print("Failed to fetch image from Pexels")
//                    }
                }
            }
        }
    }
    
    func fetchWordOfTheDay() {
        let url = URL(string: "https://api.wordnik.com/v4/words.json/wordOfTheDay?api_key=\(wordnikApiKey)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let wordOfDay = try? JSONDecoder().decode(WordOfTheDayResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.wordOfTheDay = wordOfDay.word
                }
            }
        }.resume()
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

    
    struct WordOfTheDayResponse: Decodable {
        var word: String
    }
}

#Preview {
    WordOfTheDay(firstName: "placeholder")
}
