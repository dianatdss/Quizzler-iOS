//
//  StartMenuViewController.swift
//  Quizzler
//
//  Created by Diana on 04/04/2020.
//  Copyright © 2020 London App Brewery. All rights reserved.
//

import UIKit

class StartMenuViewController: UIViewController {

    var allQuestions: [Question]?
    var pickedAnswer : Bool = false
    var index : Int = 0
    var score : Int = 0
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func answerPressed(_ sender: AnyObject) {
        if sender.tag == 1 {
            pickedAnswer = true
        } else {
            pickedAnswer = false
        }
        checkAnswer()
    }
    
    
    func updateUI() {
        scoreLabel.text = "Score: \(score)"
        progressLabel.text = "\(index+1) / \(allQuestions!.count)"
        
        progressBar.frame.size.width = (view.frame.size.width / CGFloat(allQuestions!.count) * CGFloat(index+1))
    }
    
    
    func nextQuestion() {
        if !allQuestions!.isEmpty {
            if index < allQuestions!.count {
                questionLabel.text = allQuestions![index].question
                updateUI()
            }
            else {
                let alert = UIAlertController(title: "Awesome!", message: "You've finished your quiz! Go back and select a new Quiz", preferredStyle: .alert)
                let restartAction = UIAlertAction(title: "Ok!", style: .default, handler:
                { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                })
                
                alert.addAction(restartAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func checkAnswer() {
        let answer = allQuestions![index].answer
        if answer == pickedAnswer {
            score += 1
        } else {
            print("wrong :(")
        }
        index += 1
        nextQuestion()
    }
    
    
    func startOver() {
        index = 0
        score = 0
        
    }
}
