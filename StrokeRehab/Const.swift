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
        static let normal : UIColor = .init(red: 127/255, green: 181/255, blue: 255/255, alpha: 1)
        static let indicator : UIColor = .init(red: 255/255, green: 196/255, blue: 221/255, alpha: 1)
        static let wrong : UIColor = .red
        static let pressedNomal : UIColor = .init(red: 115/255, green: 153/255, blue: 255/255, alpha: 1)
        static let pressedIndicator : UIColor = .init(red: 1, green: 175/255, blue: 200/255, alpha: 1)
    }
}
