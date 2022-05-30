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
    var completed : Bool
    var startAt : String
    var endAt : String?
    var btnPressed: [String:Int]?
    var photoPath : String?
    
    func createGameDoc() {
        let db = Firestore.firestore()
        let exerciseCollection = db.collection(Const.collectionName)

        do {
            try exerciseCollection.document(self.id).setData([
                "repetition" : self.repetition,
                "completed" : self.completed
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
    
}
