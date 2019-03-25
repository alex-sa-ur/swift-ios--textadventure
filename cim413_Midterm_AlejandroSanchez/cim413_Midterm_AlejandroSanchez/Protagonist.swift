//
//  Protagonist.swift
//  cim413_Midterm_AlejandroSanchez
//
//  Created by Alex Sanchez on 3/11/19.
//  Copyright © 2019 Alejandro Sanchez. All rights reserved.
//

import Foundation

public class Protagonist{
    private var name: String
    private var inventory: Set<Inventory>
    private var score: Int
    
    init(){
        self.name = ""
        self.inventory = []
        self.score = 0
    }
    
    public func getInventory() -> Set<Inventory>{
        return self.inventory
    }
    
    public func removeFromInventory(item: Inventory){
        self.inventory.remove(item)
    }
    
    public func addToInventory(item: Inventory){
        self.inventory.insert(item)
    }
    
    public func getScore() -> Int{
        return self.score
    }
    
    public func addScore(points: Int){
        self.score += points
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func setName(name: String) {
        self.name = name
    }
    
    public func clearInventory(){
        self.inventory = []
    }
}

public enum Inventory: String{
    case wand, sword, shield
    case empty = " "
}
