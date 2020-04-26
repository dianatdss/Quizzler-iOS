
import Foundation

class Game : Codable {
    var creator: String
    var joiner: String
    var questions: [Question]
    var game_state: Int?
}

class Leaderboard {
    var player: String?
    var score: Int?
    
    
    init(player: String?, score: Int?) {
        self.player = player
        self.score = score
    }
}

class Player {

    var email: String?
    var score: Int?
    var wins: Bool?
}

enum QUESTION_STATE: Int {
    case NOT_ACCESED = 0
    case DISPLAYING = 1
    case FIRST_ANSWER = 2
    case SECOND_ANSWER = 3
    case DONE  = 4
}

enum GAME_STATE: Int {
    case OPEN = 0
    case JOINED = 1
    case IN_PROGRESS = 2
    case DONE = 3
}
