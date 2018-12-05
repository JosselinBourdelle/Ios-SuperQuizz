//
//  Question.swift
//  SuperQuizz
//
//  Created by formation12 on 04/12/2018.
//  Copyright © 2018 formation12. All rights reserved.
//

import Foundation

class Question {

    var idquestion: Int?
    var title: String?
    var propositions: [String] = [String]()
    var correctAnswer: String?
    var imageAuthorUrl: String?
    var authorName: String?
    var userChoice: String?
    
    init (_ title: String){
        self.title = title
    }
    
    func addPropostions(answer: String){
        propositions.append(answer)
    }
    
    
}
