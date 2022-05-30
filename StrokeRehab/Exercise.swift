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
    
    
    var id : String
    var repetition : Int
    var completed : Bool = false
    var startAt : String
    var endAt : String = ""
    var btnPressed: [String:Int] = [:]
    var photoPath : String = ""
//    var goal : GoalType = GoalType.repetition
    
    enum GoalType : String {
        case repetition
        case timeLimit
    }
    
    func createExerciseDoc() {
        let db = Firestore.firestore()
        let exerciseCollection = db.collection(Const.collectionName)

        do {
            try exerciseCollection.document(self.id).setData([
                "id" : self.id,
                "repetition" : self.repetition,
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
    
    static func updateDocGameFinished(documentId id: String, isCompleted completed: Bool, endAt timeStamp: String) {
        let db = Firestore.firestore()
        let exerciseDocument = db.collection(Const.collectionName).document(id)
        
        exerciseDocument.updateData([
            "completed" : completed,
            "endAt" : timeStamp,
        ], completion: { (err) in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Successfully finished execrise!")
            }
        })
    }
    
}
