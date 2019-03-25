//
//  Chapter.swift
//  cim413_Midterm_AlejandroSanchez
//
//  Created by Alex Sanchez on 3/11/19.
//  Copyright © 2019 Alejandro Sanchez. All rights reserved.
//

import Foundation

public class Chapter {
    private var chapNum: Int
    private var prevNum: Int
    private var nextNum: Int
    private var text: String
    private var answers: [AnswerKey]
    private var item: Inventory
    private var points: Int
    private var death: Bool
    private var hasEnemy: Bool
    private var ciphered: Bool
    private var cipherKey: Int
    
    init(chapNum: Int, prevNum: Int, text: String, answers: [AnswerKey], points: Int, item: Inventory = Inventory.empty, death: Bool = false, hasEnemy: Bool = false, ciphered: Bool = false){
        self.chapNum = chapNum
        self.prevNum = chapNum
        self.nextNum = chapNum
        self.text = text
        self.answers = answers
        self.item = item
        self.points = points
        self.death = death
        self.hasEnemy = hasEnemy
        self.ciphered = ciphered
        self.cipherKey = Int.random(in: 1...25)
    }
    
    public func getChap() -> Int{
        return self.chapNum
    }
    
    public func getPrev() -> Int{
        return self.prevNum
    }
    
    public func getNext() -> Int{
        return self.nextNum
    }
    
    public func hasValidAnswer(verb: String, noun: String, prep: String, nou2: String, protagonist: Protagonist) -> Bool{
        for answer in answers{
            if answer.getAnswer().0.rawValue == verb.lowercased()
                && answer.getAnswer().1.rawValue == noun.lowercased()
                && answer.getAnswer().2.rawValue == prep.lowercased()
                && answer.getAnswer().3.rawValue == nou2.lowercased(){
                if protagonist.getInventory().contains(answer.getAnswer().5)
                || answer.getAnswer().5 == Inventory.empty{
                   return true
                }
            }
        }
        
        return false
    }
    
    public func setNext(verb: String, noun: String, prep: String, nou2: String){
        for answer in answers{
            if answer.getAnswer().0.rawValue == verb.lowercased()
                && answer.getAnswer().1.rawValue == noun.lowercased()
                && answer.getAnswer().2.rawValue == prep.lowercased()
                && answer.getAnswer().3.rawValue == nou2.lowercased(){
                self.nextNum = answer.getAnswer().4
            }
        }
    }
    
    public func setPrev(prevNum: Int){
        self.prevNum = prevNum
    }
    
    public func getText() -> String{
        if ciphered {
            return Cipher().cipher(key: self.cipherKey, text: self.text)
        } else {
            return self.text
        }
    }
    
    public func getAnswers() -> [AnswerKey]{
        return self.answers
    }
    
    public func getItem() -> Inventory{
        return self.item
    }
    
    public func setItem(item: Inventory) {
        self.item = item
    }
    
    public func getPoints() -> Int {
        return self.points
    }
    
    public func isDeathScreen() -> Bool {
        return self.death
    }
}
