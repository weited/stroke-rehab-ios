//
//  Exercise.swift
//  StrokeRehab
//
//  Created by mobiledev on 23/5/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

public struct Exercise : Codable
{
//    @DocumentID var documentID:String?
//    var title:String
//    var year:Int32
//    var duration:Float
    
    
    var id : String?
    var isFreeMode : Bool? = false
    var gameGoalType : String = Const.GoalType.repetition.rawValue
    var repetitionLimit : Int = 0
    var timeLimit : Int? = 0
    var completed : Bool = false
    var repetitionDone : Int = 0
    var timeTakenForRepe : Int? = 0
    var startAt : String
    var endAt : String = ""
    var btnPressed: [[String:String]] = [[:]]
//    var photoPath : String = ""
//    var goal : GoalType = GoalType.repetition
    
//    enum GoalType : String {
//        case repetition
//        case timeLimit
//    }
    
    func createExerciseDoc() {
        let db = Firestore.firestore()
        let exerciseCollection = db.collection(Const.collectionName)

        do {
            try exerciseCollection.document(self.id!).setData([
                "id" : self.id,
                "isFreeMode" : self.isFreeMode,
                "gameGoalType" : self.gameGoalType,
                "repetitionLimit" : self.repetitionLimit,
                "repetitionDone" : self.repetitionDone,
                "completed" : self.completed,
                "startAt" : self.startAt,
                "endAt" : self.endAt,
                "btnPressed" : btnPressed,
            ], completion: { (err) in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Successfully created execrise!")
                }
            })
            
        } catch let error {
            print("Error writing execrise to Firestore: \(error)")
        }
    }
    
    static func updateDocGameFinished(documentId id: String, isCompleted completed: Bool, endAt timeStamp: String, repetitionsDone repeNum : Int) {
        let db = Firestore.firestore()
        let exerciseDocument = db.collection(Const.collectionName).document(id)
        exerciseDocument.updateData([
            "completed" : completed,
            "endAt" : timeStamp,
            "repetitionDone" : repeNum
        ], completion: { (err) in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Successfully finished execrise!")
            }
        })
    }
    
    static func addBtnPressedToDB(documentId id: String, repetitionDone repeNum: Int ,btnPressed button: [String:Any]) {
        let db = Firestore.firestore()
        let exerciseDocument = db.collection(Const.collectionName).document(id)
        exerciseDocument.updateData([
            "repetitionDone" : repeNum,
            "btnPressed" : FieldValue.arrayUnion([button])
        ], completion: { (err) in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Successfully finished execrise!")
            }
        })
    }
    
    static func deleteExerciseById(documentId id : String) {
        let db = Firestore.firestore()
        let document = db.collection(Const.collectionName).document(id)
        document.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    static func shareStr() -> String {
//        btnsPressed : [[String:Int]]
        let btns = [["time":"20s22-028'-232 05123", "check": "false", "btn" : "11" ], ["time":"2222-22'-232 05123", "check": "false", "btn" : "222" ]]
        var displayStr : String = ""
        var btnsStr : String = ""
        
        for btn in btns {
            let singleBtnStr = "[\(btn["time"]):\(btn["btn"])],"
            btnsStr.append(singleBtnStr)
        }
        
        print("############# \(btnsStr)")
//
//        let btnStrings = btns.map{ (btn) -> String in
//            let btnStr = "[\(btn["time"]):\(btn["btn"])],"
//            btnpressedStr += btnStr
////            print(btnStr)
//            return btnStr
//        }
//
//        print(btns)
//        displayStr = btnStrings.joined(separator: "\n")
//////        return btnStr
////        for btn in btns{
//////            let key = btn.key
//////            let value = String(btn.value)
////            let btnStr = "\(btn.key)    \(btn.value)\n"
////            displayStr += btnStr
//////            btnStr.append()
////        }
        return displayStr
    }
    
}
