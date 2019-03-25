//
//  Answer.swift
//  cim413_Midterm_AlejandroSanchez
//
//  Created by Alex Sanchez on 3/11/19.
//  Copyright © 2019 Alejandro Sanchez. All rights reserved.
//

import Foundation

protocol AnswerProtocol {
    var answer: (Verb, Noun, Int) {get set}
}

//class Answer: AnswerProtocol{}

enum Verb: String {
    case go
}

enum Noun: String{
    case wand
}
