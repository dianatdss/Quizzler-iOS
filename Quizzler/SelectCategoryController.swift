//
//  SelectCategoryController.swift
//  Quizzler
//
//  Created by Diana on 11/04/2020.
//  Copyright © 2020 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class SelectCategoryController: UIViewController {
    var sentCategory : Int = 0
    var allQuestions: [Question]?
    let group = DispatchGroup() // initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func onButtonClick(_ sender: Any) {
        sentCategory = 9
        loadNewQuestions()
    }
    
    @IBAction func onSecondButtonClick(_ sender: Any) {
        sentCategory = 27
        loadNewQuestions()
    }
    
    @IBAction func onGeographyClick(_ sender: Any) {
        sentCategory = 22
        loadNewQuestions()
    }
    @IBAction func onMusicClick(_ sender: Any) {
        sentCategory = 12
        loadNewQuestions()
    }
    @IBAction func onArtClick(_ sender: Any) {
        sentCategory = 25
        loadNewQuestions()
    }
    @IBAction func onMoviesClick(_ sender: Any) {
        sentCategory = 11
        loadNewQuestions()
    }
  
    @IBAction func onLogoutClick(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("error, there was a problem signing out.")
        }
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToQuiz" {
            let destinationVC = segue.destination as! StartMenuViewController
            destinationVC.allQuestions = allQuestions
        }
    }
    
    func loadNewQuestions() {
        Question.getQuestions(category: sentCategory) { (questions) in
            
            self.allQuestions  = questions!
            self.performSegue(withIdentifier: "navigateToQuiz", sender: self)
        }
    }

}
