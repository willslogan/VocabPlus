//
//  VocabQuiz.swift
//  Vocab+
//
//  Created by William Logan on 11/21/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI
import SwiftData

fileprivate let currentUser = obtainUser()

fileprivate let emptyDefinition = Definition(definition: "",
                                             partOfSpeech: "",
                                             example: "")

fileprivate let emptyWord = Word(word: "",
                                 audioUrl: "",
                                 imageUrl: "",
                                 imageAuthor: "",
                                 imageAuthorUrl: "",
                                 synonyms: [String](),
                                 pointsUntilLearned: 0,
                                 definitions: [emptyDefinition])


struct VocabQuiz: View {
    
    //Alert
    @State private var showAlertMessage = false
    
    //Quiz Set up
    @State private var favoriteWordChosen = emptyWord
    @State private var answerChoices = ["", "", "", ""]
    @State private var beginQuiz = false
    @State private var answerHasBeenChosen = false
    @State private var hints = ["", "", ""]
    
    //Timer Objects
    @State private var timer = Timer.publish(every: .infinity, on: .main, in: .common).autoconnect()
    @State private var timerImages = Timer.publish(every: .infinity, on: .main, in: .common).autoconnect()
    @State private var imageIndex = 20
    @State private var timeLeft = 60
    
    
    let listOfQuizCategories = ["synonyms", "part of speech", "definition", "example"]
    var body: some View {
        VStack (alignment: .center){
            Text("Quiz Type")
                .font(.largeTitle)
                .padding(2)

            if !beginQuiz {
                //Start The Quiz
                Spacer()
                Button(action:
                        {
                    if currentUser.favoriteWords == nil {
                        
                        // I don't expect to get in here but if we do we have problems
                        
                        //Display Alert
                        showAlertMessage = true
                        alertTitle = "Issue With the App"
                        alertMessage = "Favorite Words is Nil"
                        
                    } else if currentUser.favoriteWords!.count == 0 {
                        //This is the case if the user deletes all their favorite words
                        
                        //Display Alert
                        showAlertMessage = true
                        alertTitle = "No Words in Favorite List"
                        alertMessage = "You need to have atleast one word in your favorite list"
                        
                    } else {
                        beginQuiz = true
                        //Choose a favorite word
                        favoriteWordChosen = chooseRandomFavoriteWord()
                        //Obtains 3 random words and a random word from favorite and places it into answerChoices
                        fillWords()
                        
                        //Obtain Hints
                        populateHints()
                        
                        //Start Timer
                        
                        startTimer()
                        
                    }
                    
                }) {
                    Text("Start")
                        .foregroundStyle(.black)
                        .font(.system(size: 50))
                        .padding()
                        .frame(width: 300, height: 200)
                        .background(.yellow)
                        .cornerRadius(5)
                }
                Spacer()
            } else { //The Actual quiz
                //Place Timer On the screen
                VStack {
                    HStack {
                        Image(systemName: "timer")
                            .imageScale(.large)
                            .padding(.trailing, 20)
                        Text(String(timeLeft))
                            .frame(width: 100)
                            .overlay {
                                Rectangle()
                                    .stroke(lineWidth: 2)
                            }
                            .onReceive(timer) { _ in
                                if timeLeft > 0{
                                    timeLeft -= 1
                                }
                            }
                    }
                    
                    Image("ProgressBar\(imageIndex)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350)
                        .onReceive(timerImages) { _ in
                            imageIndex -= 1
                            if imageIndex < 1 {
                                endGame()
                            }
                        }
                }
                //***********************
                //NEEDS TO BE IMPLEMENTED
                //***********************
                
                //Place Definition On the Screen
                
                //***********************
                //NEEDS TO BE IMPLEMENTED
                //***********************
                
                
                //Place Hints on the screen and logic
                
                //***********************
                //NEEDS TO BE IMPLEMENTED
                //***********************
                
                //place answer objects on the screen
                VStack {
                    Spacer()
                    //Button 1
                    Button(action: {
                        // if correct answer change to green otherwise red
                        //***********************
                        //NEEDS TO BE IMPLEMENTED
                        //***********************
                        
                        endGame()
                    }) {
                        Text(answerChoices[0])
                            .frame(width: 300, height: 50)
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .background(.black.opacity(0.1))
                            .padding(2.5)
                            .cornerRadius(15)
                    }
                    //Button 2
                    Button(action: {
                        // if correct answer change to green otherwise red
                        //***********************
                        //NEEDS TO BE IMPLEMENTED
                        //***********************
                        
                        endGame()
                    }) {
                        Text(answerChoices[1])
                            .frame(width: 300, height: 50)
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .background(.black.opacity(0.1))
                            .padding(2.5)
                            .cornerRadius(15)
                    }
                    //Button 3
                    Button(action: {
                        // if correct answer change to green otherwise red
                        //***********************
                        //NEEDS TO BE IMPLEMENTED
                        //***********************
                        
                        endGame()
                    }) {
                        Text(answerChoices[2])
                            .frame(width: 300, height: 50)
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .background(.black.opacity(0.1))
                            .padding(2.5)
                            .cornerRadius(15)
                    }
                    //Button 4
                    Button(action: {
                        // if correct answer change to green otherwise red
                        //***********************
                        //NEEDS TO BE IMPLEMENTED
                        //***********************
                        
                        endGame()
                    }) {
                        Text(answerChoices[3])
                            .frame(width: 300, height: 50)
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .background(.black.opacity(0.1))
                            .padding(2.5)
                            .cornerRadius(15)
                    }
                }
                
                
            }
            Spacer()
        }
        
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {}
        }, message: {
            Text(alertMessage)
        })
    }
    
    
    
    func fillWords() {
        let chosenWordToBeAnswer = Int.random(in: 0..<4)
        
        answerChoices[chosenWordToBeAnswer] = favoriteWordChosen.word
        
        for i in 0..<answerChoices.count {
            if answerChoices[i].isEmpty {
                //answerChoices[i] = getRandomWordFromApiStringOnly()
                answerChoices[i] = "Answer \(i+1)"
            }
        }
        
    }
    
    func populateHints() {
        //***********************
        //NEEDS TO BE IMPLEMENTED
        //***********************
    }
    
    func endGame() {
        // calculate score
        
        // stop timer
        stopTimer()
        // make all the words in chosenAnswers array empty
        // display how many points are left/needed
        //***********************
        //NEEDS TO BE IMPLEMENTED
        //***********************
        imageIndex = 20
        beginQuiz = false
        
    }
    
    func startTimer() {
        timerImages = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timerImages.upstream.connect().cancel()
        timer.upstream.connect().cancel()
    }
    
    
}

func chooseRandomFavoriteWord() -> Word {
    let favoriteWordsList = currentUser.favoriteWords!
    let random = Int.random(in: 0..<favoriteWordsList.count)
    return favoriteWordsList[random]
}

