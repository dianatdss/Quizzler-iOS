//
//  SelectCategoryController.swift
//  Quizzler
//
//  Created by Diana on 11/04/2020.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class SelectCategoryController: UIViewController {
    var sentCategory : Int = 0
    var allQuestions: [Question]?
    var isCreateRoomSelected: Bool = false
    var isJoinARoomSelected: Bool = false
    
    //create room
    var db: Firestore?
    var ref: DocumentReference? = nil
    public var id: String?
    var game_state: Int?
    let group = DispatchGroup()
    let groupJoin = DispatchGroup()
    let questionsGroup = DispatchGroup()
    var isCreator: Bool = false
  
    let defaultColor = UIColor(red: 1, green: 0.52, blue: 1, alpha: 1)
    
    @IBOutlet weak var joinRoomButton: UIButton!
    @IBOutlet weak var createRoomButton: UIButton!
    @IBOutlet weak var selectCategoryLabel: UILabel!
    @IBOutlet weak var roomCodeInput: UITextField!
    @IBOutlet weak var joinBTN: UIButton!
 
 
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetValues()
        super.viewWillAppear(animated);
        
    }
    
    func resetValues() {
        setButtonsToNormalState()
        allQuestions = []
        isCreator = false
        isCreateRoomSelected = false
        isJoinARoomSelected = false
    
    }
    
    
    func setButtonsToNormalState() {
        createRoomButton.backgroundColor = UIColor.white
        createRoomButton.setTitleColor(defaultColor, for: .normal)
        joinRoomButton.backgroundColor = UIColor.white
        joinRoomButton.setTitleColor(defaultColor, for: .normal)
        selectCategoryLabel.isHidden = false
        roomCodeInput.isHidden = true
        joinBTN.isHidden = true
    }
    
    @IBAction func onJoinBTNClick(_ sender: Any) {
        joinRoom()
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

    @IBAction func onCreateRoomClick(_ sender: Any) {
        isCreateRoomSelected = !isCreateRoomSelected
        createRoomButton.backgroundColor = UIColor.black
        createRoomButton.setTitleColor(UIColor.white, for: .normal)
        
        joinRoomButton.backgroundColor = UIColor.white
        joinRoomButton.setTitleColor(defaultColor, for: .normal)
       
     //   roomCodeInput.isHidden = true
        selectCategoryLabel.isHidden = false
        roomCodeInput.isHidden = true
        joinBTN.isHidden = true
    }

    
    @IBAction func onJoinARoomClick(_ sender: Any) {
        isJoinARoomSelected = !isJoinARoomSelected
        
        createRoomButton.backgroundColor = UIColor.white
        createRoomButton.setTitleColor(defaultColor, for: .normal)
        
        joinRoomButton.backgroundColor = UIColor.black
        joinRoomButton.setTitleColor(UIColor.white, for: .normal)
       
     //   roomCodeInput.isHidden = !roomCodeInput.isHidden
        selectCategoryLabel.isHidden = !selectCategoryLabel.isHidden
        roomCodeInput.isHidden = !roomCodeInput.isHidden
        joinBTN.isHidden = !joinBTN.isHidden
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "navigateToQuiz" {
            let destinationVC = segue.destination as! StartMenuViewController
            destinationVC.allQuestions = allQuestions!
        }
        
        if segue.identifier == "navigateToCreateRoom" {
            let destinationVC = segue.destination as! RoomViewController
            destinationVC.roomCodeValue = self.id
            destinationVC.isCreator = self.isCreator
            destinationVC.allQuestions = allQuestions
        }
    }
    
    func loadNewQuestions() {
        
        questionsGroup.enter()
        Question.getQuestions(category: sentCategory) { (questions) in
            
            if !((questions?.isEmpty)!) {
                self.allQuestions  = questions!
                self.questionsGroup.leave()
            }
    
        }
        
        questionsGroup.notify(queue: .main) {
            
            if self.isCreateRoomSelected == true {
                self.createRoom()
            } else {
                self.performSegue(withIdentifier: "navigateToQuiz", sender: self)
            }
        }
    }
    
    func createRoom() {
        self.db = Firestore.firestore()
        
        group.enter();
        let docData : [String: Any] = [
            "creator": Auth.auth().currentUser?.email ?? "User",
            "questions": allQuestions!.toJSON(),
            "game_state": 0
        ]
        
        ref = db!.collection("games").addDocument( data: docData){
            err in
            if let err = err {
                print("Error writing document: \(err.localizedDescription)")
            } else {
                print("Doc added with ID: \(self.ref!.documentID)")
                self.group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.id = self.ref!.documentID
            self.game_state = 0
            self.isCreator = true
            self.performSegue(withIdentifier: "navigateToCreateRoom", sender: self)
        }
    }
    
    func joinRoom() {
        self.db = Firestore.firestore()
   
        groupJoin.enter();
        db!.collection("games").document(roomCodeInput.text!).updateData(["joiner" : Auth.auth().currentUser?.email ?? "User", "game_state": 1]){
            err in
            if let err = err {
                print("Error writing document: \(err.localizedDescription)")
            } else {
                self.groupJoin.leave()
            }
        }
        
        groupJoin.notify(queue: .main) {
            self.id = self.roomCodeInput.text!
            self.game_state = 1
            self.performSegue(withIdentifier: "navigateToCreateRoom", sender: self)
        }
    }
    
    
}
