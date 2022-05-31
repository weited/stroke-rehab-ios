//
//  HomeViewController.swift
//  StrokeRehab
//
//  Created by mobiledev on 7/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let txt = Exercise.printBtn()
        nameLabel.text = txt
        print("#############\(txt)")
        // Do any additional setup after loading the view.
        let db = Firestore.firestore()
        print("\nINITIALIZED FIRESTORE APP \(db.app.name)\n")
        let movieCollection = db.collection("movies")
//        let matrix = Movie(title: "The Matrix", year: 1999, duration: 150)
//        do {
//            try movieCollection.addDocument(from: matrix, completion: { (err) in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    print("Successfully created movie")
//                }
//            })
//        } catch let error {
//            print("Error writing city to Firestore: \(error)")
//        }
        
        movieCollection.getDocuments() { (result, err) in
          //check for server error
          if let err = err
          {
              print("Error getting documents: \(err)")
          }
          else
          {
              //loop through the results
              for document in result!.documents
              {
                  //attempt to convert to Movie object
                  let conversionResult = Result
                  {
                      try document.data(as: Movie.self)
                  }

                  //check if conversionResult is success or failure (i.e. was an exception/error thrown?
                  switch conversionResult
                  {
                      //no problems (but could still be nil)
                      case .success(let movie):
                          print("Movie: \(movie)")
                          
                      case .failure(let error):
                          // A `Movie` value could not be initialized from the DocumentSnapshot.
                          print("Error decoding movie: \(error)")
                  }
              }
          }
        }    }
    
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
