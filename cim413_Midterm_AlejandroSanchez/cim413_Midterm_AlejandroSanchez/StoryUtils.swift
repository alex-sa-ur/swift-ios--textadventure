//
//  StoryUtils.swift
//  cim413_Midterm_AlejandroSanchez
//
//  Created by Alex Sanchez on 3/11/19.
//  Copyright © 2019 Alejandro Sanchez. All rights reserved.
//

import Foundation

public enum UniversalVerb: String {
    case help, returnGame = "return", learn, inventory
}

public class StoryUtils{
    public func UniversalAction(verb: String, protagonist: Protagonist) -> (String){
        var universalResponse: String = " "
        
        if verb == UniversalVerb.help.rawValue{
            universalResponse = "HELP: (use RETURN to return to game)\n\nWizards in Spaaaaaace uses commands in the following format, [VERB] + [NOUN] (+ [PREPOSITION] + [NOUN]) to traverse space and solve problems\n\nApp made by Alex Sanchez"
        } else if verb == UniversalVerb.learn.rawValue{
            universalResponse = "DICTIONARY: (use RETURN to return to game)\n\nNOUNS: north, south, east, west, up, down, sword, shield, wand, enemy, self, fists,  text\n\nVERBS: go, jump, attack, take, drop, defend, take\n\nPREPOSITIONS: with, in, on"
        } else if verb == UniversalVerb.inventory.rawValue{
            universalResponse = "INVENTORY: (use RETURN to return to game)\n\n"
            
            var counter: Int = 1
            
            if protagonist.getInventory().count > 0{
                for item in protagonist.getInventory(){
                    if counter < protagonist.getInventory().count{
                        universalResponse += item.rawValue + ", "
                    } else {
                        universalResponse += item.rawValue
                    }
                    counter += 1
                }
            } else {
                universalResponse += "No items in inventoy!"
            }
        }
        
        return universalResponse
    }
    
    public func resolveInput(story: Story, verb: String, noun: String, prep: String, nou2: String) -> (text:String, resp:String, comm:String, update:Bool){
        var text: String = story.getActive().getText()
        var resp: String = ">_" + verb + " " + noun + " " + prep + " " + nou2
        let comm: String = ""
        var update: Bool = false
        
        if let verbTest: Verb = Verb(rawValue: verb),
            let nounTest: Noun = Noun(rawValue: noun){
            
            if verbTest != Verb.empty &&
            nounTest != Noun.empty &&
            story.getActive().getChap() != 0{
            
                if story.getActive()
                    .hasValidAnswer(verb: verb, noun: noun, prep:prep, nou2:nou2, protagonist: story.getProtagonist()){
                    story.nextChapter(verb: verb, noun: noun, prep:prep, nou2:nou2)
                    update = true
                
                } else if verb == Verb.take.rawValue
                    && noun == story.getActive().getItem().rawValue
                    && story.getActive().getItem() != Inventory.empty{
                    text = "You took the " + noun + "\n\n" + story.getActive().getText()
                    story.getProtagonist().addToInventory(item: story.getActive().getItem())
                    
                } else if prep != " " && nou2 == " " {
                    text = "What would you like to " + verb + " " + noun + " " + prep + "?\n\n" + story.getActive().getText()
                } else {
                    text = "You could not do that...\n\n" + story.getActive().getText()
                }
                
            } else if story.getActive().getChap() != 0 {
                resp = ">_ No command found..."
                update = true
            } else {
                let prevNum = story.getActive().getChap()
                story.setActive(num: story.getActive().getAnswers()[0].getAnswer().4)
                story.getActive().setPrev(prevNum: prevNum)
                update = true
            }
        
        } else if let _: UniversalVerb = UniversalVerb (rawValue: verb){
            let newText = StoryUtils().UniversalAction(verb: verb, protagonist: story.getProtagonist())
            if newText != " " {
                text = newText
            } else {
                update = true
            }
            
        } else if (Noun(rawValue: verb) != nil || Preposition(rawValue: verb) != nil) && verb != " " {
            text = "You used [" + verb + "] in a way I do not understand\n\n" + story.getActive().getText()
            
        } else if (Verb(rawValue: noun) != nil || Preposition(rawValue: noun) != nil) && noun != " " {
            text = "You used [" + noun + "] in a way I do not understand\n\n" + story.getActive().getText()
            
        } else if (Verb(rawValue: prep) != nil || Noun(rawValue: prep) != nil) && prep != " " {
            text = "You used [" + prep + "] in a way I do not understand\n\n" + story.getActive().getText()
            
        } else if (Verb(rawValue: nou2) != nil || Preposition(rawValue: nou2) != nil) && nou2 != " " {
            text = "You used [" + nou2 + "] in a way I do not understand\n\n" + story.getActive().getText()
            
        } else {
        text = "I did not understand the command\n\n" + story.getActive().getText()
        resp = ">_ Unidentifiable command"
    
        }
        
        return (text:text, resp:resp, comm:comm, update:update)
    }
    
  //////////////////////////////////////////////////////////////////////////////////////////
 // STORY MAKER                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////
    
    public func storyMaker() -> Story{
        //Universal answer key
        
        /*
        let answerKey_u_1 = AnswerKey(
            verb: Verb.attack,
            noun: Noun.myself,
            prep: Preposition.with,
            nou2: Noun.sword,
            successor: 2)
        */
        
        let answerKey_u: [AnswerKey] = []
        
        //Chapter 0 - Title
        
        let answerKey_0_a = AnswerKey(
            verb: Verb.empty,
            noun: Noun.empty,
            successor: 1)
        
        let answerKey_0 = [answerKey_0_a]
        
        let text_0 = "Welcome to WIZARDS IN SPAAAAAACE\n\nType HELP for more information or LEARN for list of valid commands\n\nPress NEXT >> to begin"
        
        let chapter_0 = Chapter(chapNum: 0, prevNum: 0, text: text_0, answers: answerKey_0, points: 0)
        
        //Chapter 1 - Awaken in center of room
        
        let answerKey_1_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 2)
        
        let answerKey_1_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 3)
        
        let answerKey_1_c = AnswerKey(
            verb: Verb.go,
            noun: Noun.east,
            successor: 6)
        
        let answerKey_1_d = AnswerKey(
            verb: Verb.go,
            noun: Noun.west,
            successor: 7)
        
        let answerKey_1_e = AnswerKey(
            verb: Verb.jump,
            noun: Noun.up,
            successor: 28)
        
        var answerKey_1 = [answerKey_1_a, answerKey_1_b, answerKey_1_c, answerKey_1_d, answerKey_1_e]
        answerKey_1.append(contentsOf: answerKey_u)
        
        let text_1 = "You awaken in the center of a dark room... which direction will you go?"
        
        let chapter_1 = Chapter(chapNum: 1, prevNum: 0, text: text_1, answers: answerKey_1, points: 1)
        
        //Chapter 2 - North into dragon mouth [DEATH] from start
        
        let answerKey_2_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 2)
        
        var answerKey_2 = [answerKey_2_a]
        answerKey_2.append(contentsOf: answerKey_u)
        
        let text_2 = "You walked north into the mouth of a Space Dragon and became its dinner.\n\nYou Died."
        
        let chapter_2 = Chapter(chapNum: 2, prevNum: 1, text: text_2, answers: answerKey_2, points: 0, death: true)
        
        //Chapter 3 - South towards text from start
        
        let answerKey_3_a = AnswerKey(
            verb: Verb.read,
            noun: Noun.text,
            successor: 4)
        
        let answerKey_3_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 5)
        
        var answerKey_3 = [answerKey_3_a, answerKey_3_b]
        answerKey_3.append(contentsOf: answerKey_u)
        
        let text_3 = "You walked south and saw a stone slab with text written in a strange language..."
        
        let chapter_3 = Chapter(chapNum: 3, prevNum: 1, text: text_3, answers: answerKey_3, points: 1)
        
        //Chapter 4 - Reads text
        
        let answerKey_4_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 5)
        
        var answerKey_4 = [answerKey_4_a]
        answerKey_4.append(contentsOf: answerKey_u)
        
        let text_4 = "Welcome to the Labyrinth of the Spacemancer, location: Core of Planet Montressor"
        
        let chapter_4 = Chapter(chapNum: 4, prevNum: 3, text: text_4, answers: answerKey_4, points: 2, ciphered: true)
        
        //Chapter 5 - Center of room return
        
        let answerKey_5 = answerKey_1
        
        let text_5 = "You are in the center of a dark room... which direction will you go?"
        
        let chapter_5 = Chapter(chapNum: 5, prevNum: 3, text: text_5, answers: answerKey_5, points: 0)
        
        //Chapter 6 - go east from start
        
        let answerKey_6_a = AnswerKey(
            verb: Verb.jump,
            noun: Noun.down,
            successor: 8)
        
        let answerKey_6_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.up,
            successor: 9)
        
        let answerKey_6_c = AnswerKey(
            verb: Verb.go,
            noun: Noun.west,
            successor: 5)
        
        var answerKey_6 = [answerKey_6_a, answerKey_6_b, answerKey_6_c]
        answerKey_6.append(contentsOf: answerKey_u)
        
        let text_6 = "You go east and stumble upon a split path. There are stairs leading up, and a ledge that could be jumped down from. It seems you may not be able to jump back up"
        
        let chapter_6 = Chapter(chapNum: 6, prevNum: 1, text: text_6, answers: answerKey_6, points: 1)
        
        //Chapter 7 - go west from start
        
        let answerKey_7_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.east,
            successor: 5)
        
        var answerKey_7 = [answerKey_7_a]
        answerKey_7.append(contentsOf: answerKey_u)
        
        let text_7 = "You walk west and find a stone pedestal for a wand"
        
        let chapter_7 = Chapter(chapNum: 7, prevNum: 1, text: text_7, answers: answerKey_7, points: 1, item: Inventory.wand)
        
        
        //Chapter 8 - Jump down ledge from east of start
        
        let answerKey_8_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 10)
        
        let answerKey_8_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 11)
        
        var answerKey_8 = [answerKey_8_a, answerKey_8_b]
        answerKey_8.append(contentsOf: answerKey_u)
        
        let text_8 = "You can see the ledge where you jumped above you. You find yourself in a narrow corridor going north and south..."
        
        let chapter_8 = Chapter(chapNum: 8, prevNum: 6, text: text_8, answers: answerKey_8, points: 1)
        
        //Chapter 9 - go up stairs from east of start
        
        let answerKey_9_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.up,
            successor: 12)
        
        let answerKey_9_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.east,
            successor: 13)
        
        var answerKey_9 = [answerKey_9_a, answerKey_9_b]
        answerKey_9.append(contentsOf: answerKey_u)
        
        let text_9 = "You get half way up the stairs and see a door leading east..."
        
        let chapter_9 = Chapter(chapNum: 9, prevNum: 6, text: text_9, answers: answerKey_9, points: 1)
        
        //Chapter 10 - north from ledge jump
        
        let answerKey_10_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 8)
        
        let answerKey_10_b = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.wand,
            successor: 14)
        
        let answerKey_10_c = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.fists,
            successor: 15)
        
        let answerKey_10_d = AnswerKey(
            verb: Verb.defend,
            noun: Noun.myself,
            prep: Preposition.with,
            nou2: Noun.shield,
            successor: 16)
        
        var answerKey_10 = [answerKey_10_a, answerKey_10_b, answerKey_10_c, answerKey_10_d]
        answerKey_10.append(contentsOf: answerKey_u)
        
        let text_10 = "You find yourself face to face with a Space Vampire glowing with a magical aura, it seems ready to attack!"
        
        let chapter_10 = Chapter(chapNum: 9, prevNum: 8, text: text_10, answers: answerKey_10, points: 5)
        
        //Chapter 11 - south from ledge jump
        
        let answerKey_11_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 8)
        
        var answerKey_11 = [answerKey_11_a]
        answerKey_11.append(contentsOf: answerKey_u)
        
        let text_11 = "You walk south and find a chest full of shields"
        
        let chapter_11 = Chapter(chapNum: 11, prevNum: 8, text: text_11, answers: answerKey_11, points: 1, item: Inventory.shield)
        
        //Chapter 12 - continue up stairs
        
        let answerKey_12_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 12)
        
        var answerKey_12 = [answerKey_12_a]
        answerKey_12.append(contentsOf: answerKey_u)
        
        let text_12 = "You kept walking up and got squished by a loose boulder that rolled down the stairs.\n\nYou Died."
        
        let chapter_12 = Chapter(chapNum: 12, prevNum: 9, text: text_12, answers: answerKey_12, points: 0, death: true)
        
        //Chapter 13 - go east halfway through stairs
        
        let answerKey_13_a = AnswerKey(
            verb: Verb.read,
            noun: Noun.text,
            successor: 18)
        
        let answerKey_13_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.west,
            successor: 9)
        
        let answerKey_13_c = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 19)
        
        var answerKey_13 = [answerKey_13_a, answerKey_13_b, answerKey_13_c]
        answerKey_13.append(contentsOf: answerKey_u)
        
        let text_13 = "You walked east into a room and saw a stone slab with text written in a strange language and a path leading north..."
        
        let chapter_13 = Chapter(chapNum: 13, prevNum: 9, text: text_13, answers: answerKey_13, points: 1)
        
        //Chapter 14 - attack Space Vampire with wand
        
        let answerKey_14_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 17)
        
        let answerKey_14_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 8)
        
        var answerKey_14 = [answerKey_14_a, answerKey_14_b]
        answerKey_14.append(contentsOf: answerKey_u)
        
        let text_14 = "You made the Space Vampire disappear with magic and the way north has now been cleared"
        
        let chapter_14 = Chapter(chapNum: 14, prevNum: 10, text: text_14, answers: answerKey_14, points: 5)
        
        //Chapter 15 - attack Space Vampire with fists
        
        let answerKey_15_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 8)
        
        let answerKey_15_b = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.wand,
            successor: 14)
        
        let answerKey_15_c = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.fists,
            successor: 15)
        
        let answerKey_15_d = AnswerKey(
            verb: Verb.defend,
            noun: Noun.myself,
            prep: Preposition.with,
            nou2: Noun.shield,
            successor: 16)
        
        var answerKey_15 = [answerKey_15_a, answerKey_15_b, answerKey_15_c, answerKey_15_d]
        answerKey_15.append(contentsOf: answerKey_u)
        
        let text_15 = "The Space Vampire absorbed the shock of your punches and used them against you, causing you to disintegrate!\n\nYou Died."
        
        let chapter_15 = Chapter(chapNum: 15, prevNum: 9, text: text_15, answers: answerKey_15, points: 0, death: true)
        
        //Chapter 16 - defend from Space Vampire
        
        let answerKey_16_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 8)
        
        let answerKey_16_b = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.wand,
            successor: 14)
        
        let answerKey_16_c = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.fists,
            successor: 15)
        
        let answerKey_16_d = AnswerKey(
            verb: Verb.defend,
            noun: Noun.myself,
            prep: Preposition.with,
            nou2: Noun.shield,
            successor: 16)
        
        var answerKey_16 = [answerKey_16_a, answerKey_16_b, answerKey_16_c, answerKey_16_d]
        answerKey_16.append(contentsOf: answerKey_u)
        
        let text_16 = "You blocked the Space Vampire's attack. It is ready to attack again!"
        
        let chapter_16 = Chapter(chapNum: 16, prevNum: 9, text: text_16, answers: answerKey_16, points: 0)
        
        //Chapter 17 - continue north from Space Vampire encounter
        
        let answerKey_17_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 26)
        
        let answerKey_17_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 14)
        
        var answerKey_17 = [answerKey_17_a, answerKey_17_b]
        answerKey_17.append(contentsOf: answerKey_u)
        
        let text_17 = "You may continue north into a big room"
        
        let chapter_17 = Chapter(chapNum: 17, prevNum: 14, text: text_17, answers: answerKey_17, points: 5)
        
        //Chapter 18 - Read text in room east of stairs
        
        let answerKey_18_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 19)
        
        let answerKey_18_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.west,
            successor: 9)
        
        var answerKey_18 = [answerKey_18_a, answerKey_18_b]
        answerKey_18.append(contentsOf: answerKey_u)
        
        let text_18 = "Goblins are damaged only by steel, anything else will cause them to explode and wipe out the area"
        
        let chapter_18 = Chapter(chapNum: 18, prevNum: 13, text: text_18, answers: answerKey_18, points: 2, ciphered: true)
        
        //Chapter 19 - go north from room east of stairs
        
        let answerKey_19_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 20)
        
        let answerKey_19_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 17)
        
        var answerKey_19 = [answerKey_19_a, answerKey_19_b]
        answerKey_19.append(contentsOf: answerKey_u)
        
        let text_19 = "You walk north into a narrow hallway continuing north, there are swords scattered everywhere"
        
        let chapter_19 = Chapter(chapNum: 19, prevNum: 17, text: text_19, answers: answerKey_19, points: 1, item: Inventory.sword)
        
        //Chapter 20 - continue north past swords
        
        let answerKey_20_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 21)
        
        let answerKey_20_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 19)
        
        var answerKey_20 = [answerKey_20_a, answerKey_20_b]
        answerKey_20.append(contentsOf: answerKey_u)
        
        let text_20 = "You walked past the swords and moved further north..."
        
        let chapter_20 = Chapter(chapNum: 20, prevNum: 19, text: text_20, answers: answerKey_20, points: 1)
        
        //Chapter 21 - go north from sword hallway
        
        let answerKey_21_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 20)
        
        let answerKey_21_b = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.wand,
            successor: 22)
        
        let answerKey_21_c = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.fists,
            successor: 23)
        
        let answerKey_21_d = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.sword,
            successor: 24)
        
        var answerKey_21 = [answerKey_21_a, answerKey_21_b, answerKey_21_c, answerKey_21_d]
        answerKey_21.append(contentsOf: answerKey_u)
        
        let text_21 = "The narrow hallway continues a bit further, a Space Goblin now blocks your path. It seems to be waiting for you to attack"
        
        let chapter_21 = Chapter(chapNum: 21, prevNum: 20, text: text_21, answers: answerKey_21, points: 1)
        
        //Chapter 22 - attack space goblin with wand
        
        let answerKey_22_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 20)
        
        var answerKey_22 = [answerKey_22_a]
        answerKey_22.append(contentsOf: answerKey_u)
        
        let text_22 = "The goblin exploded on impact with the spell you cast!\n\nYou Died."
        
        let chapter_22 = Chapter(chapNum: 22, prevNum: 21, text: text_22, answers: answerKey_22, points: 0, death: true)
        
        //Chapter 23 - attack space goblin with fists
        
        let answerKey_23_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 20)
        
        var answerKey_23 = [answerKey_23_a]
        answerKey_23.append(contentsOf: answerKey_u)
        
        let text_23 = "The goblin exploded on impact with your punch!\n\nYou Died."
        
        let chapter_23 = Chapter(chapNum: 23, prevNum: 21, text: text_23, answers: answerKey_23, points: 0, death: true)
        
        //Chapter 24 - attack space goblin with sword
        
        let answerKey_24_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 20)
        
        let answerKey_24_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 25)
        
        var answerKey_24 = [answerKey_24_a, answerKey_24_b]
        answerKey_24.append(contentsOf: answerKey_u)
        
        let text_24 = "The goblin dissolved into a ball of light... you may now proceed forward"
        
        let chapter_24 = Chapter(chapNum: 24, prevNum: 21, text: text_24, answers: answerKey_24, points: 0)
        
        //Chapter 25 - continue north from space goblin encounter
        
        let answerKey_25_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 27)
        
        let answerKey_25_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 24)
        
        var answerKey_25 = [answerKey_25_a, answerKey_25_b]
        answerKey_25.append(contentsOf: answerKey_u)
        
        let text_25 = "You may continue north into a big room "
        
        let chapter_25 = Chapter(chapNum: 25, prevNum: 24, text: text_25, answers: answerKey_25, points: 1)
        
        //Chapter 26 - final room A
        
        let answerKey_26_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 32)
        
        let answerKey_26_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 17)
        
        let answerKey_26_c = AnswerKey(
            verb: Verb.read,
            noun: Noun.text,
            successor: 31)
        
        var answerKey_26 = [answerKey_26_a, answerKey_26_b, answerKey_26_c]
        answerKey_26.append(contentsOf: answerKey_u)
        
        let text_26 = "You walk north into a large room with a door on the northern side and a stone tablet with text in a strange language "
        
        let chapter_26 = Chapter(chapNum: 26, prevNum: 17, text: text_26, answers: answerKey_26, points: 1)
        
        //Chapter 27 - final room B
        
        let answerKey_27_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 33)
        
        let answerKey_27_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 25)
        
        let answerKey_27_c = AnswerKey(
            verb: Verb.read,
            noun: Noun.text,
            successor: 30)
        
        var answerKey_27 = [answerKey_27_a, answerKey_27_b, answerKey_27_c]
        answerKey_27.append(contentsOf: answerKey_u)
        
        let text_27 = "You walk north into a large room with a door on the northern side and a stone tablet with text in a strange language "
        
        let chapter_27 = Chapter(chapNum: 27, prevNum: 25, text: text_27, answers: answerKey_27, points: 1)
        
        //Chapter 28 - final room C
        
        let answerKey_28_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 34)
        
        let answerKey_28_b = AnswerKey(
            verb: Verb.jump,
            noun: Noun.down,
            successor: 5)
        
        let answerKey_28_c = AnswerKey(
            verb: Verb.read,
            noun: Noun.text,
            successor: 31)
        
        var answerKey_28 = [answerKey_28_a, answerKey_28_b, answerKey_28_c]
        answerKey_28.append(contentsOf: answerKey_u)
        
        let text_28 = "You jumped through a hole in the ceiling into a large room with a door on the northern side and a stone tablet with text in a strange language "
        
        let chapter_28 = Chapter(chapNum: 28, prevNum: 5, text: text_28, answers: answerKey_28, points: 1)
        
        //Chapter 29 - final room a text
        
        let answerKey_29_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 32)
        
        let answerKey_29_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 17)
        
        var answerKey_29 = [answerKey_29_a, answerKey_29_b]
        answerKey_29.append(contentsOf: answerKey_u)
        
        let text_29 = "Magic works against this foe"
        
        let chapter_29 = Chapter(chapNum: 29, prevNum: 26, text: text_29, answers: answerKey_29, points: 2, ciphered: true)
        
        //Chapter 30 - final room b text
        
        let answerKey_30_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 33)
        
        let answerKey_30_b = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 25)
        
        var answerKey_30 = [answerKey_30_a, answerKey_30_b]
        answerKey_30.append(contentsOf: answerKey_u)
        
        let text_30 = "Swords work against this foe"
        
        let chapter_30 = Chapter(chapNum: 30, prevNum: 27, text: text_30, answers: answerKey_30, points: 2, ciphered: true)
        
        //Chapter 31 - final room c text
        
        let answerKey_31_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 34)
        
        let answerKey_31_b = AnswerKey(
            verb: Verb.jump,
            noun: Noun.down,
            successor: 5)
        
        var answerKey_31 = [answerKey_31_a, answerKey_31_b]
        answerKey_31.append(contentsOf: answerKey_u)
        
        let text_31 = "This foe is weak to the use of punching attacks"
        
        let chapter_31 = Chapter(chapNum: 31, prevNum: 28, text: text_31, answers: answerKey_31, points: 2, ciphered: true)
        
        //Chapter 32 - final boss A
        
        let answerKey_32_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 26)
        
        let answerKey_32_b = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.wand,
            successor: 35)
        
        let answerKey_32_c = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.fists,
            successor: 36)
        
        let answerKey_32_d = AnswerKey(
            verb: Verb.defend,
            noun: Noun.myself,
            prep: Preposition.with,
            nou2: Noun.shield,
            successor: 36)
        
        var answerKey_32 = [answerKey_32_a, answerKey_32_b, answerKey_32_c, answerKey_32_d]
        answerKey_32.append(contentsOf: answerKey_u)
        
        let text_32 = "There is a strong wizard blocking the exit to the Labyrinth... It's the musical wizard Priya!"
        
        let chapter_32 = Chapter(chapNum: 32, prevNum: 26, text: text_32, answers: answerKey_32, points: 1)
        
        //Chapter 33 - final boss B
        
        let answerKey_33_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 27)
        
        let answerKey_33_b = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.wand,
            successor: 36)
        
        let answerKey_33_c = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.fists,
            successor: 36)
        
        let answerKey_33_d = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.sword,
            successor: 35)
        
        var answerKey_33 = [answerKey_33_a, answerKey_33_b, answerKey_33_c, answerKey_33_d]
        answerKey_33.append(contentsOf: answerKey_u)
        
        let text_33 = "There is a strong wizard blocking the exit to the Labyrinth... It's the dancing wizard Wanlong and his dancing cat Frida!"
        
        let chapter_33 = Chapter(chapNum: 33, prevNum: 27, text: text_33, answers: answerKey_33, points: 1)
        
        //Chapter 34 - final boss C
        
        let answerKey_34_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.south,
            successor: 28)
        
        let answerKey_34_b = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.wand,
            successor: 36)
        
        let answerKey_34_c = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.fists,
            successor: 35)
        
        let answerKey_34_d = AnswerKey(
            verb: Verb.attack,
            noun: Noun.enemy,
            prep: Preposition.with,
            nou2: Noun.sword,
            successor: 36)
        
        var answerKey_34 = [answerKey_34_a, answerKey_34_b, answerKey_34_c, answerKey_34_d]
        answerKey_34.append(contentsOf: answerKey_u)
        
        let text_34 = "There is a strong wizard blocking the exit to the Labyrinth... It's the jumping wizard Alex!"
        
        let chapter_34 = Chapter(chapNum: 34, prevNum: 28, text: text_34, answers: answerKey_34, points: 1)
        
        //Chapter 35 - Labyrinth exit - end screen
        
        let answerKey_35_a = AnswerKey(
            verb: Verb.empty,
            noun: Noun.empty,
            successor: 1)
        
        let answerKey_35 = [answerKey_35_a]
        
        let text_35 = "You defeated one of the three strongest wizards guarding the Labyrinth and managed to find the exit! Congratulations!"
        
        let chapter_35 = Chapter(chapNum: 35, prevNum: 32, text: text_35, answers: answerKey_35, points: 10, death: true)
        
        //Chapter 36 - last stand death
        
        let answerKey_36_a = AnswerKey(
            verb: Verb.go,
            noun: Noun.north,
            successor: 2)
        
        var answerKey_36 = [answerKey_36_a]
        answerKey_36.append(contentsOf: answerKey_u)
        
        let text_36 = "The wizard deflected your attack and evaporated you with a simple spell.\n\nYou Died."
        
        let chapter_36 = Chapter(chapNum: 36, prevNum: 34, text: text_36, answers: answerKey_36, points: 0, death: true)
        
        //Chapter collection
        
        let chapters = [chapter_0, chapter_1, chapter_2, chapter_3, chapter_4, chapter_5, chapter_6, chapter_7, chapter_8, chapter_9, chapter_10, chapter_11, chapter_12, chapter_13, chapter_14, chapter_15, chapter_16, chapter_17, chapter_18, chapter_19, chapter_20, chapter_21, chapter_22, chapter_23, chapter_24, chapter_25, chapter_26, chapter_27, chapter_28, chapter_29, chapter_30, chapter_31, chapter_32, chapter_33, chapter_34, chapter_35, chapter_36]
        
        //Protagonist
        
        let protagonist = Protagonist()
        
        //Story
        
        let story = Story(chapters: chapters, protagonist: protagonist)
        
        return story
    }
}
