//
//  Question.swift
//  Quizzler
//
//  Created by Diana on 29/03/2020.
//  Copyright © 2020 London App Brewery. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

class Question: Mappable {
    
    var question : String?
    var correct_answer : String?
    
    var answer: Bool {
        return (self.correct_answer == "True") ? true : false
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        question               <- map["question"]
        correct_answer         <- map["correct_answer"]
    }
    
    static func getQuestions(category: Int, completion: @escaping (_ questions: [Question]?) -> ()) {
  
        let url = "https://opentdb.com/api.php"
        let parameters : [String : String] = [
            "amount" : "10",
            "category" : String(category),
            "type" : "boolean"
        ]
      
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonResponse = JSON(value)
                
                let questions = [Question].init(JSONString: jsonResponse["results"].description)
                
                completion(questions)
            
            case .failure(let error):
                
                completion(nil)
                print("Error \(response.result.error)")
                
            }
        }
    }}
