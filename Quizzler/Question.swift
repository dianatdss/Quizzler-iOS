import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

class Question: Mappable, Codable {
    
    var question : String?
    var correct_answer : String?
    var question_state: Int?
    
    var answer: Bool {
        return (self.correct_answer == "True") ? true : false
    }
    init(question: String?, correct_answer: String?) {
        self.question = question
        self.correct_answer = correct_answer
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
