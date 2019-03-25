//
//  Cipher.swift
//  cim413_Midterm_AlejandroSanchez
//
//  Created by Alex Sanchez on 3/12/19.
//  Copyright © 2019 Alejandro Sanchez. All rights reserved.
//

import Foundation

public class Cipher{
    public func cipher(key: Int, text: String) -> String{
        let capA = Int(UnicodeScalar("A").value)
        let capZ = Int(UnicodeScalar("Z").value)
        let lowA = Int(UnicodeScalar("a").value)
        let lowZ = Int(UnicodeScalar("z").value)
        
        var cipheredString: String = ""
        
        for char in text {
            let intChar = Int(UnicodeScalar(String(char))!.value)
            
            switch intChar{
            case capA...capZ:
                var newChar = intChar + key
                
                switch (newChar){
                case capA...capZ:
                    cipheredString += String(Character(UnicodeScalar(newChar)!))
                    
                default:
                    if newChar > capZ{
                        newChar = newChar % capZ + capA - 1
                    } else {
                        newChar = capZ - capA % newChar
                    }
                    
                    cipheredString += String(Character(UnicodeScalar(newChar)!))
                }
                
            case lowA...lowZ:
                var newChar = intChar + key
                
                switch (newChar){
                case lowA...lowZ:
                    cipheredString += String(Character(UnicodeScalar(newChar)!))
                    
                default:
                    if newChar > lowZ{
                        newChar = newChar % lowZ + lowA - 1
                    } else {
                        newChar = lowZ - lowA % newChar
                    }
                    
                    cipheredString += String(Character(UnicodeScalar(newChar)!))
                }
                
            default:
                cipheredString += String(char)
            }
        }
        
        return cipheredString
    }
}
