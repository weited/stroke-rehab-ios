//
//  Movie.swift
//  StrokeRehab
//
//  Created by mobiledev on 23/5/2022.
//

import Foundation

import Firebase
import FirebaseFirestoreSwift

public struct Movie : Codable
{
    @DocumentID var documentID:String?
    var title:String
    var year:Int32
    var duration:Float
}
