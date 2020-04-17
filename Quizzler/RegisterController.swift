//
//  RegisterController.swift
//  Quizzler
//
//  Created by Diana on 11/04/2020.
//  Copyright © 2020 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fromRegisterToLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "fromRegisterToLogin", sender: self)

    }
    @IBAction func register(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (user, error) in
            if error != nil {
                print(error!)
            } else {
                self.performSegue(withIdentifier: "navigateFromRegister", sender: self)
                print("Success")
            }
        }

    }
    
}
