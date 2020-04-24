//
//  ViewController.swift
//  Quizzler
//
//  Created by Diana on 30/03/2020.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    override func viewDidLoad() {
   
        super.viewDidLoad()
    }
    
    @IBAction func onRegisterClick(_ sender: Any) {
        performSegue(withIdentifier: "navigateToRegister", sender: self)

    }
    @IBAction func onLoginClick(_ sender: Any) {
        performSegue(withIdentifier: "navigateToLogin", sender: self)

    }
    
}
