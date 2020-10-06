//
//  HomeModel.swift
//  Trivia
//
//  Created by Sathishkumar Muthukumar on 06/10/20.
//  Copyright © 2020 Sathishkumar Muthukumar. All rights reserved.
//

import Foundation

//List of Questions with answers

let json = """
[{"type":"FILL","question":"What is your name?","answers":[]},
{"type":"MULTI_CHOICE","question":"Who is the best cricketer in the world?","answers":["Sachin Tendulkar","Virat Kolhi","Adam Gilchirst","Jacques Kallis"]},
{"type":"MULTI_SELECT","question":"What are the colors in the Indian national flag?","answers":["White","Yellow","Orange","Green"]}]
""".data(using: .utf8)!

struct QuestionModel: Decodable{
    var type : String
    var question  : String
    var answers  : [String]
}
