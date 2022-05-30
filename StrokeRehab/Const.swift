//
//  Const.swift
//  StrokeRehab
//
struct Const {
    static let goalToCustSegue = "goalToCustomize"
    static let prescribedCustmToStartSegue = "preCustomToStart"
    static let gameToFinishedSegue = "gameToFinished"
    static let collectionName = "exercises"
    
    enum GoalType : String {
        case repetition
        case timeLimit
    }
}
