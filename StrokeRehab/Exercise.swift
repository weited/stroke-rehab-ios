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
    
    static func printBtn() -> String {
//        btnsPressed : [[String:Int]]
        let btns = ["1":0,"20s22-028'-232 05123" : 1,"20z22sv-9804-141 13231" : 2,"2022-0x28-232 05123" : 3,"2022-9c804-141 13231" : 4,"2022v-028-232 05123" : 5,"2022-9804-141 132b31" : 6,"2022-0n28-232 05123" : 7,"2022-980m4-141 13231" : 8,"2022z-028,-232 05123" : 9,"202.2-98zx04-141 13231" : 10,"2022-02x8-232 0/5123" : 11,"2022-19c804-141 13231" : 12,"20222-v028-232 05123" : 13,"20223-9804-141 13231" : 14,"20422-028-232 05123" : 15,"2022-9804-141 153231" : 16,"2022-0286-232 05123" : 17,"2022-98704-141 13231" : 18,"20822-028-232 05123" : 19,"2022-99b804-141 13231" : 20,"2022n-028-232 050123" : 21,"2022-9-804m-141 13231" : 22,"2022-=,028-232 05123" : 23,"202.2-a9804-141 13231" : 24,"2022f-028-232/ 05123" : 25,"2022-9804-1`41 13g231" : 26,"afsfsafsfas":27]
        var displayStr : String = ""
                
        let btnStrings = btns.map{ (btn) -> String in
            let btnStr = "\(btn.key)    \(btn.value)"
//            displayStr += btnStr
//            print(btnStr)
            return btnStr
        }
        
        print(btns)
        displayStr = btnStrings.joined(separator: "\n")
////        return btnStr
//        for btn in btns{
////            let key = btn.key
////            let value = String(btn.value)
//            let btnStr = "\(btn.key)    \(btn.value)\n"
//            displayStr += btnStr
////            btnStr.append()
//        }
        return displayStr
    }
    
}
