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
    @State private var hintRequsted = false
    @State private var hints = ["", "", ""]
    @State private var hintSelectedIndex = 0
    @State private var favoriteWordChosenDefinition = ""
    @State private var pointsToEarn = 50
    @State private var answerChosen = -1
    @State private var isLoading = false

    //Timer Objects
    @State private var timer = Timer.publish(every: .infinity, on: .main, in: .common).autoconnect()
    @State private var timerImages = Timer.publish(every: .infinity, on: .main, in: .common).autoconnect()
    @State private var imageIndex = 20
    @State private var timeLeft = 60
    
    
    let listOfQuizCategories = ["synonyms", "part of speech", "definition", "example"]
    var body: some View {
        VStack (alignment: .center){
            Text("Quiz Me!")
                .font(.largeTitle)
                .padding(2)
            
            if !beginQuiz {
                //Start The Quiz
                Spacer()
                Button(action:
                        {
                    Task {
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
                            
                        } else if checkIfAllWordListDefinitionsNil() {
                            showAlertMessage = true
                            alertTitle = "Definitions Not Found"
                            alertMessage = "You need to have atleast one word in your favorite list with a definition"
                        } else {
                            //Choose a favorite word
                            favoriteWordChosen = chooseRandomFavoriteWord()
                            //Obtains 3 random words and a random word from favorite and places it into answerChoices
                            await fillWords()
                            //Obtain definition and hints
                            chooseRandomDefinitionAndHints()
                            beginQuiz = true
                            
                            //Start Timer
                            
                            startTimer()
                        }
                        }
                    
                    
                }) {
                    if (isLoading) {
                        Text("Loading...")
                            .foregroundStyle(.black)
                            .font(.system(size: 50))
                            .padding()
                            .frame(width: 300, height: 200)
                            .background(.yellow)
                            .cornerRadius(5)
                    }
                    else {
                        Text("Start")
                            .foregroundStyle(.black)
                            .font(.system(size: 50))
                            .padding()
                            .frame(width: 300, height: 200)
                            .background(.yellow)
                            .cornerRadius(5)
                    }
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
                            if pointsToEarn > 3 {
                                pointsToEarn -= 3
                            } else {
                                pointsToEarn = 0
                            }
                        }
                }
                
                //Place definition On ths screen
                Text("Which word has this definition:")
                    .padding()
                Text(favoriteWordChosenDefinition)
                    .padding(.horizontal, 10)
                    .multilineTextAlignment(.leading)
                
                //Place Hints on the screen and logic
                if hintRequsted {
                    Text("HINT")
                        .padding(.top)
                        .font(.headline)
                    Text(hints[hintSelectedIndex])
                        .frame(width: 300)
                        .padding()
                        .overlay {
                            Rectangle()
                                .stroke(lineWidth: 2)
                        }
                }
                
                
                
                //place answer objects on the screen
                VStack {
                    Spacer()
                    //Points left
                    Text("Points: \(pointsToEarn)")
                        .frame(width: 100)
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 30).stroke(Color(red: 0/255, green: 0/255, blue: 139/255), lineWidth: 3)
                        }
                    //Button 1
                    Button(action: {
                        answerChosen = 1
                        stopTimer()
                        //Ends the game after 3 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            endGame()
                        }
                    }) {
                        Text(answerChoices[0])
                            .frame(width: 300, height: 50)
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .background(colorChoice(buttonPressed: 1))
                            .padding(2.5)
                            .cornerRadius(15)
                    }
                    //Button 2
                    Button(action: {
                        answerChosen = 2
                        stopTimer()
                        //Ends the game after 3 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            endGame()
                        }
                    }) {
                        Text(answerChoices[1])
                            .frame(width: 300, height: 50)
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .background(colorChoice(buttonPressed: 2))
                            .padding(2.5)
                            .cornerRadius(15)
                    }
                    //Button 3
                    Button(action: {
                        answerChosen = 3
                        stopTimer()
                        //Ends the game after 3 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            endGame()
                        }
                    }) {
                        Text(answerChoices[2])
                            .frame(width: 300, height: 50)
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .background(colorChoice(buttonPressed: 3))
                            .padding(2.5)
                            .cornerRadius(15)
                    }
                    //Button 4
                    Button(action: {
                        answerChosen = 4
                        stopTimer()
                        //Ends the game after 3 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            endGame()
                        }
                    }) {
                        Text(answerChoices[3])
                            .frame(width: 300, height: 50)
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .background(colorChoice(buttonPressed: 4))
                            .padding(2.5)
                            .cornerRadius(15)
                    }
                }
                
                //Request Hint Button
                HStack {
                    Button(action: {
                        if !hintRequsted {
                            hintRequsted = true
                            if pointsToEarn > 5 {
                                pointsToEarn -= 5
                            } else {
                                pointsToEarn = 0
                            }
                        } else {
                            if hintSelectedIndex < hints.count - 1 {
                                hintSelectedIndex += 1
                                if pointsToEarn > 5 {
                                    pointsToEarn -= 5
                                } else {
                                    pointsToEarn = 0
                                }
                            } else {
                                showAlertMessage = true
                                alertTitle = "No more hints left"
                                alertMessage = "You have no more remaining hints"
                            }
                        }
                        
                        
                    }){
                        Image(systemName: "questionmark.circle")
                            .imageScale(.medium)
                    }
                    if hintRequsted {
                        Text("Hints Remaining: \(2 - hintSelectedIndex)")
                    } else {
                        Text("Hints Remaining: 3")
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
    
    
    
    func fillWords() async {
        isLoading = true
        let chosenWordToBeAnswer = Int.random(in: 0..<4)
        answerChoices[chosenWordToBeAnswer] = favoriteWordChosen.word

        var index = 0
        let timeoutNanoseconds = UInt64(15 * 1_000_000_000) // 15 seconds in nanoseconds
        let startTime = DispatchTime.now()

        while answerChoices.contains("") {
            let currentTime = DispatchTime.now()
            if currentTime.uptimeNanoseconds - startTime.uptimeNanoseconds > timeoutNanoseconds {
                showAlertMessage = true
                alertTitle = "Error"
                alertMessage = "Problem occured in API, please try again later"
                break
            }

            if answerChoices[index].isEmpty {
                let randomWord = await getRandomWordFromApiStringOnly()
                if !randomWord.isEmpty {
                    answerChoices[index] = randomWord
                }
            }

            index = (index + 1) % 4 // Ensure the index stays within the range of 0 to 3
        }

        isLoading = false
    }



    func populateHints(chosenDefinition: Definition) {
        var synonymsInString = ""
        for i in 0..<favoriteWordChosen.synonyms.count {
            synonymsInString.append("\(favoriteWordChosen.synonyms[i]), ")
        }
        
        if !synonymsInString.isEmpty {
            synonymsInString = String(synonymsInString.dropLast(2))
        } else {
            synonymsInString = "Sorry no synonyms found"
        }
        
        hints[0] = "Part of speech:\n\(chosenDefinition.partOfSpeech)"
        hints[1] = "Synonyms:\n\(synonymsInString)"
        hints[2] = "Example:\n\(chosenDefinition.example.replacingOccurrences(of: favoriteWordChosen.word.lowercased(), with: "_____"))"
    }
    
    func endGame() {
        // display how many points are left/needed
        //case 1 no points earned
        if answerChosen == -1 || answerChoices[answerChosen - 1] != favoriteWordChosen.word {
            showAlertMessage = true
            alertTitle = "Oops!"
            alertMessage = "You chose incorrectly but you'll get right next time :)"
        } else if (favoriteWordChosen.pointsUntilLearned  - pointsToEarn) > 0 { //case 2 word earned points
            showAlertMessage = true
            alertTitle = "Nice!"
            alertMessage = "You just earned \(pointsToEarn) points on this word!\nYou have \(favoriteWordChosen.pointsUntilLearned - pointsToEarn) points left to learn this word"
            
            favoriteWordChosen.pointsUntilLearned = favoriteWordChosen.pointsUntilLearned - pointsToEarn
            
        } else { //case 3 word learned
            
            showAlertMessage = true
            alertTitle = "Congrats!"
            alertMessage = "You have officially learned this word!\nIt has now been added to your learned words list"
            if !currentUser.learnedWords!.contains(favoriteWordChosen) {
                currentUser.learnedWords!.append(favoriteWordChosen)
            }
            // Remove word from favorite words list
            if let index = currentUser.favoriteWords?.firstIndex(of: favoriteWordChosen) {
                currentUser.favoriteWords?.remove(at: index)
            }
            favoriteWordChosen.pointsUntilLearned = favoriteWordChosen.pointsUntilLearned - pointsToEarn
            print(currentUser.learnedWords!.count)
        }
        
        //Add stats
        currentUser.quizzesTaken = currentUser.quizzesTaken + 1
        currentUser.quizzesPoints.append(pointsToEarn)
        currentUser.experience = currentUser.experience + pointsToEarn
        if(currentUser.experience >= 100 * currentUser.level) {
            currentUser.level += 1
            currentUser.experience = 0
            print("User Gained 1 level")
        }
        
        //Reset all values
        
        //Quiz Set up
        favoriteWordChosen = emptyWord
        answerChoices = ["", "", "", ""]
        beginQuiz = false
        answerHasBeenChosen = false
        hintRequsted = false
        hints = ["", "", ""]
        hintSelectedIndex = 0
        favoriteWordChosenDefinition = ""
        pointsToEarn = 50
        answerChosen = -1
        
        //Timer Objects
        timer = Timer.publish(every: .infinity, on: .main, in: .common).autoconnect()
        timerImages = Timer.publish(every: .infinity, on: .main, in: .common).autoconnect()
        imageIndex = 20
        timeLeft = 60
        
        
    }
    
    func startTimer() {
        timerImages = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timerImages.upstream.connect().cancel()
        timer.upstream.connect().cancel()
    }
    
    func chooseRandomFavoriteWord() -> Word {
        let favoriteWordsList = currentUser.favoriteWords!
        var random = Int.random(in: 0..<favoriteWordsList.count)
        while favoriteWordsList[random].definitions == nil {
            random = Int.random(in: 0..<favoriteWordsList.count)
        }
        
        return favoriteWordsList[random]
    }
    
    func checkIfAllWordListDefinitionsNil() -> Bool {
        let favoriteWordsList = currentUser.favoriteWords!
        for i in 0..<favoriteWordsList.count {
            if favoriteWordsList[i].definitions != nil {
                return false
            }
        }
        return true
    }
    
    //Determines the color for a button depending one whether and was chosen and whether the answer was right
    func colorChoice(buttonPressed: Int) -> Color {
        if answerChosen != -1 {
            if favoriteWordChosen.word == answerChoices[buttonPressed-1] {
                return Color.green.opacity(0.3)
            } else {
                return Color.red.opacity(0.3)
            }
        }
        return Color.black.opacity(0.1)
    }
    
    func chooseRandomDefinitionAndHints(){
        let random = Int.random(in: 0..<favoriteWordChosen.definitions!.count)
        favoriteWordChosenDefinition = favoriteWordChosen.definitions![random].definition
        populateHints(chosenDefinition: favoriteWordChosen.definitions![random])
    }
}
