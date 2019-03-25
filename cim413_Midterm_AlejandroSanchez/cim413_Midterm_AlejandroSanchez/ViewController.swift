//
//  ViewController.swift
//  cim413_Midterm_AlejandroSanchez
//
//  Created by Alex Sanchez on 3/7/19.
//  Copyright © 2019 Alejandro Sanchez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var nameField: UITextField!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var respLabel: UILabel!
    @IBOutlet var commandField: UITextField!
    @IBOutlet var translateLabel: UILabel!
    @IBOutlet var translateSlider: UISlider!
    
    var story: Story = StoryUtils().storyMaker()
    
    func updateName(){
        story.getProtagonist().setName(name: nameField.text ?? "")
    }
    
    func updateText(){
        textLabel.text = story.getActive().getText()
        commandField.text = ""
    }
    
    @IBAction func backButton(){
        if textLabel.text == story.getActive().getText(){
            story.setActive(num: story.getActive().getPrev())
        }
        
        story.getProtagonist().setName(name: nameField.text ?? "")
        respLabel.text = ">_"
        updateText()
        
        commandField.resignFirstResponder()
    }
    
    func startOverAlert(){
        let alert = UIAlertController(
            title: "Requested Mission Abort",
            message: "Commander, you have requested to abort mission and start over, is this correct?",
            preferredStyle: .alert
        )
        
        let OKAction = UIAlertAction(
            title: "Confirm",
            style: .default){
                (action:UIAlertAction!) in
                    self.story.setActive(num: 0)
                    self.respLabel.text = ">_"
                    self.updateText()
                    self.nameField.text = ""
                    self.story.getProtagonist().setName(name: self.nameField.text ?? "")
                    self.story.getProtagonist().clearInventory()
        }
        
        let CancelAction = UIAlertAction(
            title: "Cancel",
            style: .default){
                (action:UIAlertAction!) in
        }
        
        alert.addAction(OKAction)
        alert.addAction(CancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func startOverButton(){
        commandField.resignFirstResponder()
        startOverAlert()
        
    }
    
    @IBAction func nextButton(){
        var verb: String = " "
        var noun: String = " "
        var prep: String = " "
        var nou2: String = " "
        var command = commandField.text!.split(separator: " ")
        if command.count > 0 {
            verb = String(command[0]).lowercased()
        }
        
        if command.count > 1{
            noun = String(command[1]).lowercased()
        }
        
        if command.count > 2{
            prep = String(command[2]).lowercased()
        }
        
        if command.count > 3{
            nou2 = String(command[3]).lowercased()
        }
        
        if !story.getActive().isDeathScreen(){
        
            let chapUpdate: (text:String, resp:String, comm:String, update:Bool) = StoryUtils().resolveInput(story: self.story, verb: verb, noun: noun, prep: prep, nou2: nou2)
            
            textLabel.text = chapUpdate.text
            respLabel.text = chapUpdate.resp
            commandField.text = chapUpdate.comm
            
            if chapUpdate.update {
                updateText()
            }
        }
        
        story.getProtagonist().setName(name: nameField.text ?? "")
        
        commandField.resignFirstResponder()
        
    }
    
    @IBAction func sliderMoved(){
        let value = Int(translateSlider.value)
        var valueString = String(value)
        
        if (value < 10){
            valueString = "0" + valueString
        }
        
        valueString = "Universal Translator: " + valueString
        
        let cipheredText = Cipher().cipher(key: value, text: story.getActive().getText())
        
        translateLabel.text = valueString
        textLabel.text = cipheredText
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo? [UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        updateText()
    }


}

