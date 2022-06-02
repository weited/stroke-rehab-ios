//
//  Const.swift
//  StrokeRehab
//

import UIKit
struct Const {
    static let collectionName = "exercisesIOS"
    static let goalToCustSegue = "goalToCustomize"
    static let freeModeToCustSegue = "freeModeToCustSegue"
    static let prescribedCustmToStartSegue = "preCustomToStart"
    static let gameToFinishedSegue = "gameToFinished"
    static let showHistoryDetailSegue = "showHistoryDetailSegue"
    static let deleteRecordSegue = "deleteRecordSegue"
    static let saveNameSegue = "saveNameSegue"
    static let dGameToCustSegue = "dGameToCustSegue"
    
    static let historyDetailCell = "historyDetailTableViewCell"

    enum GoalType : String {
        case repetition = "Repetition Limit"
        case timeLimit = "Time Limit"
    }
    
    enum GameName : String {
        case pGame = "Prescribed Game"
        case dGame = "Designed Game"
    }
    
    struct BtnColors {
        static let normal : UIColor = .init(red: 0.647468, green: 0.840358, blue: 0.980702, alpha: 1)
        static let indicator : UIColor = .init(red: 1.02621, green: 0.864526, blue: 0.953756, alpha: 1)
//        static let ticked : UIColor =
        static let wrong : UIColor = .red
    }
}
