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
    @DocumentID var documentID:String?
//    var title:String
//    var year:Int32
//    var duration:Float
    var repetition : Int
    var completed : Bool
    var startAt : String
    var endAt : String
    var btnPressed: [String:Int]
    var photoPath : String
    
}
