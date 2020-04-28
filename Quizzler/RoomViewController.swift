import UIKit
import Firebase
import SwiftyJSON
import ObjectMapper

class RoomViewController: UIViewController {

    var roomCodeValue:  String? = nil
    var state: Int? = 0
    var db: Firestore?
    var ref: DocumentReference? = nil
    var countNumber: Int = 10
    var timer : Timer?
    var counterStarted = false
    var allQuestions: [Question]?
    var isCreator: Bool = false
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var roomCode: UILabel!
    override func viewDidLoad() {
        roomCode.text = roomCodeValue
        db = Firestore.firestore()
        ref = db!.collection("games").document(roomCodeValue!)
        ref?.addSnapshotListener {
            documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error")
                return
            }
            guard let data = document.data() else {
                print("Doc empty")
                return
            }
            if data["game_state"] as! Int == 1 {
                if self.counterStarted == false {
                    self.startCountdown()
                    self.counterStarted = true
                }
            }
        }
 
        ref?.getDocument {
            document, error in
            if let error = error {
                print("\(error)")
            } else {
                let jsonResponse = JSON(document?.data())
                let questions = [Question].init(JSONString: jsonResponse["questions"].description)
                self.allQuestions = questions
      
            }
        }
            
    
    
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startCountdown() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(RoomViewController.count), userInfo: nil, repeats: true)
    }
    
    @objc func count() {
        if countNumber > 0 {
            countNumber = countNumber - 1
            timerLabel.text = String(countNumber)
        } else {
            timer?.invalidate()
            timer = nil
            self.performSegue(withIdentifier: "navigateToMultiplayerGame", sender: self)
            ref?.updateData(["game_state": 3]){
                err in
                if let err = err {
                    print("Error writing document: \(err.localizedDescription)")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToMultiplayerGame" {
            let destinationVC = segue.destination as! StartMenuViewController
            destinationVC.allQuestions = self.allQuestions ?? []
            destinationVC.roomID = self.roomCodeValue!
            destinationVC.isCreator = self.isCreator
            destinationVC.isMultiplayer = true
        }
    }

}
