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
    var isFreeMode : Bool = false
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
                print("Successfully uploaded button pressed")
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
    
    func shareRecord() -> String {
        let gameGoal = String(self.repetitionLimit)
        let status : String = self.completed ? "completed" : "Not completed"
        let btns = self.btnPressed
        var displayStr : String = ""
        var btnsStr : String = ""
        
        for btn in btns {
            if let timeStamp = btn["time"], let btnNum = btn["btn"] {
                let time = timeStamp.components(separatedBy: " ")[1]
                btnsStr.append("[\(time) : \(btnNum)], ")
            }
        }
        
        displayStr = "Game type: \(self.gameGoalType), game goal: \(gameGoal), completition status: \(status), started at: \(self.startAt), end at: \(self.endAt), \(self.repetitionDone) repetitions has done, button pressed: [ \(btnsStr) ]"

        return displayStr
    }
    
}
