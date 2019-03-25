//
//  AnswerKey.swift
//  cim413_Midterm_AlejandroSanchez
//
//  Created by Alex Sanchez on 3/11/19.
//  Copyright © 2019 Alejandro Sanchez. All rights reserved.
//

import Foundation

public class AnswerKey {
    private var answer: (Verb, Noun, Preposition, Noun, Int, Inventory)
    
    init(verb: Verb, noun: Noun, prep: Preposition = Preposition.empty, nou2: Noun = Noun.empty, successor: Int, itemRequired: Inventory = Inventory.empty){
        self.answer = (verb, noun, prep, nou2, successor, itemRequired)
    }
    
    public func getAnswer() -> (Verb, Noun,Preposition, Noun, Int, Inventory){
        return self.answer
    }
}

public enum Verb: String {
    case go, jump, attack, take, drop, defend, read
    case empty = " "
}

public enum Noun: String{
    case wand, sword, shield
    case north, south, east, west, up, down, enemy, myself = "self", text, fists
    case empty = " "
}

public enum Preposition: String {
    case with, put_in = "in", on
    case empty = " "
}
