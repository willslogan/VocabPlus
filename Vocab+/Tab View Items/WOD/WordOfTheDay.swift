//
//  WordOfTheDay.swift
//  Vocab+
//
//  Created by William Logan on 11/21/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI

struct WordOfTheDay: View {
    
    var firstName: String
    @State private var wordOfTheDay: String = "Loading..."
    @State private var imageUrl: String?
    @State private var authorName: String?
    @State private var authorUrl: String?
    @State private var showingAuthorAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Welcome Back \(firstName),\nReady to improve your vocab?")
                        .multilineTextAlignment(.center)
                        .frame(width: 300, height: 100, alignment: .center)
                        .background(Color.white)
                        .border(Color.black, width: 2)
                    
                    ZStack(alignment: .topTrailing) {
                        if let imageUrl = imageUrl {
                            GetImageFromUrl(stringUrl: imageUrl, maxWidth: 300)
                            
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
                            Text("Unfortunately, we couldn't find an image corresponding to the word: \(wordOfTheDay)")
                                .multilineTextAlignment(.center)
                                .frame(width: 300, height: 100, alignment: .center)
                                .background(Color.white)
                                .border(Color.black, width: 2)
                        }
                    }
                    Text("Word Of the Day")
                        .multilineTextAlignment(.center)
                        .frame(width: 300, height: 50, alignment: .center)
                        .background(Color.white)
                        .border(Color.black, width: 2)
                        .font(.title)
                    Text(wordOfTheDay)
                        .font(.title2)
                        .padding()
                    
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
                    // below are for testing purposes
//                    self.wordOfTheDay = "apple"
//                    fetchImageFromPexels()
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
    
    func fetchImageFromPexels() {
        let query = wordOfTheDay.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.pexels.com/v1/search?query=\(query)&per_page=1"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(pexelsApiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received from Pexels API")
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode(PexelsResponse.self, from: data) {
                if let firstPhoto = decodedResponse.photos.first {
                    DispatchQueue.main.async {
                        self.imageUrl = firstPhoto.src.medium
                        self.authorName = firstPhoto.photographer
                        self.authorUrl = firstPhoto.photographer_url
                    }
                } else {
                    print("No photos found in response")
                }
            } else {
                print("Failed to decode response from Pexels API")
            }
        }.resume()
    }
    
    var authorAlert: Alert {
        Alert(
            title: Text("Photo Info"),
            message: Text(authorName ?? "No author information available"),
            primaryButton: .default(Text("Author Website"), action: {
                if let authorUrl = authorUrl, let url = URL(string: authorUrl) {
                    UIApplication.shared.open(url)
                }
            }),
            secondaryButton: .cancel()
        )
    }
    struct WordOfTheDayResponse: Decodable {
        var word: String
    }
    struct PexelsResponse: Codable {
        var photos: [Photo]
    }
    
    struct Photo: Codable {
        var src: Source
        var photographer: String
        var photographer_url: String
    }
    
    struct Source: Codable {
        var medium: String
    }
}

#Preview {
    WordOfTheDay(firstName: "placeholder")
}
