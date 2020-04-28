import UIKit

class EndedMultiplayerViewController: UIViewController {

    var winner: String?
    
    @IBOutlet weak var winnerName: UILabel!
    override func viewDidLoad() {
        winnerName.text = winner
        super.viewDidLoad()
    }
    
    @IBAction func onGoBackClick(_ sender: Any) {
        let vcIndex = self.navigationController?.viewControllers.index(where: { (viewController) -> Bool in
            
            if let _ = viewController as? SelectCategoryController {
                return true
            }
            return false
        })
        
        let composeVC = self.navigationController?.viewControllers[vcIndex!] as! SelectCategoryController
        
        self.navigationController?.popToViewController(composeVC, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
