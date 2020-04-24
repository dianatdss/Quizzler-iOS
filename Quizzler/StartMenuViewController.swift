//
//  StartMenuViewController.swift
//  Quizzler
//
//  Created by Diana on 04/04/2020.
//

import UIKit
import Firebase

class StartMenuViewController: UIViewController {

    var allQuestions: [Question] = []
    var pickedAnswer : Bool = false
    var index : Int = 0
    var score : Int = 0
    var isMultiplayer: Bool = false
    var isCreator: Bool = true
    var roomID: String?
    var db: Firestore?
    var ref: DocumentReference? = nil
    var winner: String = ""
    var listener: ListenerRegistration?
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        if isMultiplayer == true {
            db = Firestore.firestore()
            ref = db!.collection("games").document(roomID!)
        }
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
        questionLabel.text = allQuestions[index].question
        scoreLabel.text = "Score: \(score)"
        progressLabel.text = "\(index+1) / \(allQuestions.count)"
        progressBar.frame.size.width = (view.frame.size.width / CGFloat(allQuestions.count) * CGFloat(index+1))
        
        print("\(questionLabel.text)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "multiplayerEnded" {
            let destinationVC = segue.destination as! EndedMultiplayerViewController
            destinationVC.winner = self.winner
        }
    }
    
    func navigate() {
        self.performSegue(withIdentifier: "multiplayerEnded", sender: self)
    }
    
    func nextQuestion() {
        
            print("Index = \(index)")
            
            if index < allQuestions.count {
                self.updateUI()
            } else if index == allQuestions.count {
                if isMultiplayer == false {
                    let alert = UIAlertController(title: "Awesome!", message: "You've finished your quiz! Go back and select a new Quiz", preferredStyle: .alert)
                    let restartAction = UIAlertAction(title: "Ok!", style: .default, handler: {
                        (UIAlertAction) in
                            self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(restartAction)
                    present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    let alert = UIAlertController(title: "Awesome!", message: "You've finished your quiz! Let's wait for you opponent to see the results!", preferredStyle: .alert)
                    present(alert, animated: true, completion: nil)
                    
                    let string_to_update = isCreator == true ? "creator_score" : "joiner_score"
                    ref?.updateData([string_to_update : self.score]){
                            err in
                            if let err = err {
                                print("Error writing document: \(err.localizedDescription)")
                            }
                    }
                    
                    listener = ref?.addSnapshotListener {
                        documentSnapshot, error in
                        guard let document = documentSnapshot else {
                            print("Error")
                            return
                        }
                        guard let data = document.data() else {
                            print("Doc empty")
                            return
                        }
                        
                        if data["joiner_score"] != nil && data["creator_score"] != nil {
                            
                            
                            if (data["joiner_score"] as! Int) < (data["creator_score"] as! Int) {
                                self.winner = data["creator"] as! String
                            } else if (data["joiner_score"] as! Int) > (data["creator_score"] as! Int) {
                                self.winner = data["joiner"] as! String
                            } else {
                                self.winner = "IT'S A DRAW"
                            }
                            self.listener?.remove()
                            alert.dismiss(animated: true, completion:{
                                self.navigate()
                            })
                                                    }
                    }
                }
            }
        
    }
    
    
    func checkAnswer() {
        let answer = allQuestions[index].correct_answer == "True" ? true : false
        index += 1

        if answer == pickedAnswer {
            score += 1
        }
        
        nextQuestion()
    }
    
    func startOver() {
        index = 0
        score = 0
    }
}
