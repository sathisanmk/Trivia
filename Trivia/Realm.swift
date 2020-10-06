//
//  Realm.swift
//  Trivia
//
//  Created by Sathishkumar Muthukumar on 05/10/20.
//  Copyright © 2020 Sathishkumar Muthukumar. All rights reserved.
//

import Foundation
import RealmSwift

//This is the Realm object model 
class GameData: Object {
    @objc dynamic var firstName = ""
    @objc dynamic var date = ""
    let questionData = RealmSwift.List<QuestionData>()
    convenience init(name:String) {
        self.init()
        self.firstName = name
    }
}

class QuestionData: Object {
    @objc dynamic var question = ""
    @objc dynamic var answer = ""

    convenience init(question:String,answer:String) {
        self.init()
        self.question = question
        self.answer = answer
    }

}
