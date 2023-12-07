//
//  Profile.swift
//  Vocab+
//
//  Created by William Logan on 11/28/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI
import Charts

fileprivate let currentUser = obtainUser()

struct Profile: View {
    
    @State var quizList = populateQuizList(currUser: currentUser)
    @State var pieGraphPoints = populatePieGraph(currUser: currentUser)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center) {
                    Text("Your Profile")
                    
                    HStack {
                        let fileName = currentUser.profileImageName.components(separatedBy: ".")[0]
                        let fileExtension = currentUser.profileImageName.components(separatedBy: ".")[1]
                        getImageFromDocumentDirectory(filename: fileName, fileExtension: fileExtension, defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 75, height: 75)
                        
                            
                        
                        Text("\(currentUser.firstName) \(currentUser.lastName)")
                            .font(.system(size: 30))
                        
                        Text("\(currentUser.level)")
                            .font(.system(size: 30))
                            .bold()
                            .frame(width: 50, height: 50)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 2.5)
                                    .foregroundColor(Color(red: 0/255, green: 0/255, blue: 139/255))
                            }
                    }
                    
                    VStack {
                        Text("Words Learned")
                        Text("\(    currentUser.learnedWords!.count     )")
                            .font(.system(size: 14))
                            .frame(width: 50, height:20)
                            .overlay {
                                Rectangle()
                                    .stroke(lineWidth: 2.0)
                            }
                    }
                    .padding(20)
                    
                    HStack {
                        
                        //Quizzes
                        VStack {
                            Text("Quizzes")
                                .padding(8)
                            Text(quizzes)
                                .frame(width: 150)
                                .overlay {
                                    Rectangle()
                                        .stroke(lineWidth: 2.0)
                                    
                                }
                        }
                        
                        //Average Quiz Score
                        VStack {
                            Text("Average Quiz Score")
                            Text("All Time")
                                .font(.system(size: 12))
                            Text(averageQuiz)
                                .frame(width: 150)
                                .overlay {
                                    Rectangle()
                                        .stroke(lineWidth: 2.0)
                                    
                                }
                                .padding(1)
                        }
                    }
                    
                    //Refresh Displays
                    VStack {
                        Button(action: {
                            quizList = populateQuizList(currUser: currentUser)
                            pieGraphPoints = populatePieGraph(currUser: currentUser)
                        }) {
                            Text("Refresh Graphs")
                                .frame(width: 200, height: 75)
                                .foregroundStyle(.white)
                                .background(.blue.opacity(0.7))
                                .cornerRadius(30)
                        }
                    }
                    
                    //BAR GRAPH
                    VStack (alignment: .center) {
                        Chart {
                            ForEach(quizList) { quiz in
                                BarMark(
                                    x: .value("Quiz Number", quiz.quizNumber),
                                    y: .value("Quiz Results", quiz.quizResult ))
                            }
                        }
                        
                        
                    }
                    .frame(height: 200)
                    .padding()
                    
                    //PIE GRAPH
                    VStack(alignment: .center) {
                        Text("Learned Words in Vocab List")
                        
                        Chart {
                            ForEach(pieGraphPoints) { data in
                                SectorMark(angle: .value("Words", data.data),
                                           innerRadius: .ratio(0.12),
                                           angularInset: 1
                                )
                                    .foregroundStyle(by: .value("Category", data.category))
                                    .cornerRadius(3)
                            }
                        }
                        .chartLegend(alignment: .center)
                        .frame(height: 200)
                        .padding(8)
                    }
                }
            }
        }
    }
    
    var quizzes: String {
        return String(currentUser.quizzesTaken)
    }
    
    var averageQuiz: String {
        var sum = 0
        for i in 0..<currentUser.quizzesPoints.count {
            sum += currentUser.quizzesPoints[i]
        }
        var average = 0.0
        if currentUser.quizzesTaken != 0 {
            average = Double(sum) / Double(currentUser.quizzesTaken)
        }
        
        let roundedValue = round(average * 100) / 100
        return String(roundedValue)
    }
    
}

struct PieGraphPoint: Identifiable {
    var id = UUID().uuidString
    let category: String
    let data: Int
}

struct Quiz: Hashable, Identifiable {
    let quizResult: Double
    let quizNumber: String
    
    var id: String { quizNumber }
}

func obtainUser() -> User {
    for aUser in usersList {
        if !aUser.firstName.isEmpty {
            return aUser
        }
    }
    
    return userGlobal
}

func populateQuizList(currUser: User) -> [Quiz] {
    //***********************
    //NEEDS TO BE IMPLEMENTED
    //***********************
    
    // Last Five points
    var quizResult = [0.0, 0.0, 0.0, 0.0, 0.0]
    
    var quizList = [Quiz]()

    let dataPoints = currentUser.quizzesPoints
    
    
    var indexResult = 0
    var indexPoints = dataPoints.count-1
    
    while indexResult < 5 && indexPoints >= 0 {
        quizResult[indexResult] = Double(dataPoints[indexPoints])
        indexResult += 1
        indexPoints -= 1
    }
    
    var quizNumber = dataPoints.count
    for i in 0..<quizResult.count {
        let quizNumberString = String(quizNumber)
        
        if quizNumber > 0 {
            let newQuiz = Quiz(quizResult: quizResult[i], quizNumber: quizNumberString)
            quizList.append(newQuiz)
        } else {
            let newQuiz = Quiz(quizResult: quizResult[i], quizNumber: "Not Taken")
            quizList.append(newQuiz)
        }
        
        quizNumber -= 1
        
    }
    
    
    return quizList
}

func populatePieGraph(currUser: User) -> [PieGraphPoint] {
    
    //***********************
    //NEEDS TO BE IMPLEMENTED
    //***********************
    
    let data = [
        PieGraphPoint(category: "Learned Words",
                      data: currentUser.learnedWords!.count),
        PieGraphPoint(category: "Favorited Words",
                      data: currentUser.favoriteWords!.count),
    ]
    
    return data
}

#Preview {
    Profile()
}
