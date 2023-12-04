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
                            .overlay {
                                Rectangle()
                                    .stroke(lineWidth: 2.0)
                                
                            }
                    }
                    
                    //Average Quiz Score
                    VStack {
                        Text("Average Quiz Score")
                        Text("Last 2 Weeks")
                            .font(.system(size: 12))
                        Text(averageQuiz)
                            .overlay {
                                Rectangle()
                                    .stroke(lineWidth: 2.0)
                                
                            }
                            .padding(1)
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
    
    var quizzes: String {
        //***********************
        //NEEDS TO BE IMPLEMENTED
        //***********************
        
        return "[PLACE HOLDER]"
    }
    
    var averageQuiz: String {
        //***********************
        //NEEDS TO BE IMPLEMENTED
        //***********************
        
        return "[PLACE HOLDER]"
    }
    
}

struct PieGraphPoint: Identifiable {
    var id = UUID().uuidString
    let category: String
    let data: Int
}

struct quiz: Hashable, Identifiable {
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

func populateQuizList(currUser: User) -> [quiz] {
    //***********************
    //NEEDS TO BE IMPLEMENTED
    //***********************
    
    // This Is fake points rn
    let quizResult = [30.0, 50.0, 90.0, 70.0]
    
    var quizList = [quiz]()
    
    for i in 0..<quizResult.count {
        let currResult = quizResult[i]
        let currNumber = i + 1
        
        let newQuiz = quiz(quizResult: currResult, quizNumber: String(currNumber))
        
        quizList.append(newQuiz)
    }
        
    return quizList
}

func populatePieGraph(currUser: User) -> [PieGraphPoint] {
    
    //***********************
    //NEEDS TO BE IMPLEMENTED
    //***********************
    
    let data = [
        PieGraphPoint(category: "Learned Words",
                      data: 30),
        PieGraphPoint(category: "Favorited Words Not Learned",
                      data: 100),
        PieGraphPoint(category: "Goal", data: 300)
    ]
    
    return data
}

#Preview {
    Profile()
}
