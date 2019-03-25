//
//  Story.swift
//  cim413_Midterm_AlejandroSanchez
//
//  Created by Alex Sanchez on 3/11/19.
//  Copyright © 2019 Alejandro Sanchez. All rights reserved.
//

import Foundation

public class Story{
    private var chapters: [Chapter]
    private var activeChapter: Chapter
    private var protagonist: Protagonist
    
    init(chapters: [Chapter], protagonist: Protagonist){
        self.chapters = chapters
        self.protagonist = protagonist
        self.activeChapter = chapters[0]
    }
    
    public func getActive() -> Chapter{
        return self.activeChapter
    }
    
    public func setActive(num: Int){
        self.activeChapter = chapters[num]
    }
    
    public func nextChapter(verb: String, noun: String, prep: String, nou2: String){
        activeChapter.setNext(verb: verb, noun: noun, prep:prep, nou2:nou2)
        let prevNum = activeChapter.getChap()
        setActive(num: activeChapter.getNext())
        if activeChapter.getChap() != prevNum{
            activeChapter.setPrev(prevNum: prevNum)
            protagonist.addScore(points: activeChapter.getPoints())
        }
    }
    
    public func prevChapter(){
        if protagonist.getInventory().contains(activeChapter.getItem()){
            protagonist.removeFromInventory(item: activeChapter.getItem())
        }
        setActive(num: activeChapter.getPrev())
        protagonist.addScore(points: -activeChapter.getPoints())
    }
    
    public func getProtagonist() -> Protagonist{
        return self.protagonist
    }
}
