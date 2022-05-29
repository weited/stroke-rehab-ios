//
//  GamePlayViewController.swift
//  StrokeRehab
//
//  Created by mobiledev on 28/5/2022.
//

import UIKit

class GamePlayViewController: UIViewController {

    var repeNum : Int = 3
    var isFreeMode : Bool = false
    var isBtnRandom : Bool = true
    var isBtnIndicator : Bool = true
    var btnNum : Int = 3
    var btnSize : Int = 2
    
    var targetBtns : [Int] = [1,2,3]
    var randomBtns : [Int] = [2,1,3]

    var currentBtn : Int = 1
    var round : Int = 0
    
    var btnUIGroup : [UIButton] = []
    var isOverlap : Bool = false
    
    @IBOutlet weak var btnAreaView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        
        for index in 1...btnNum {
            btnAreaView.layoutIfNeeded()
            let height = btnAreaView!.frame.size.height - 50
            let width = btnAreaView!.frame.size.width - 50
            print("size is \(height)")
            print("size is \(width)")
//            let button = UIButton(frame: CGRect(x: Int(CGFloat( arc4random_uniform( UInt32( floor( width  ) ) ) )), y: Int(CGFloat( arc4random_uniform( UInt32( floor( height ) ) ) )), width: 50, height: 50))
            
            let button = UIButton()

            
            button.layer.cornerRadius = 25
            button.setTitle("\(index)", for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            button.tag = index
            
            btnAreaView.addSubview(button)
            
            btnUIGroup.append(button)
            
            
        }
        
        print("is over lap before while? \(isOverlap)")
        
        // random button position first then check if overlap
        repeat
        {
            print("before repeat? \(isOverlap)")
            randomPosition()
            checkBtnOverlap(btnGroup: btnUIGroup)
            print("after repeat? \(isOverlap)")
        }
        while isOverlap == true
        
        
        


        // Do any additional setup after loading the view.
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button \(currentBtn)")
        if sender.tag == currentBtn {
            sender.backgroundColor = .blue
            currentBtn += 1
            
            if currentBtn > btnNum {
                randomPosition()
                currentBtn = 1
                
            }
        }
        
        print("Button tapped\(sender.tag)")


    }
    
    func checkBtnOverlap(btnGroup: [UIButton]) {
//        for index in 1...btnNum {var button = btnAreaView.viewWithTag(index) as? UIButton}
//        var isOverlap : Bool = false
        for i in 0..<btnNum {
            print("before iii: \(i) \(isOverlap)")
            if isOverlap == true {
                break
                
            } else {
                for j in i+1..<btnNum {
                    print("in jjjj: \(i) and \(j)  \(isOverlap)")
                    if btnGroup[i].frame.intersects(btnGroup[j].frame) {
                       
                        isOverlap = true
                        print("is over lap? \(isOverlap)")
                        break
                    }
//                    else {
//                        isOverlap = false
//
//                        print("is over lap f? \(isOverlap)")
////                        continue
//                    }
                }
            }

        }
    }
    
    func randomPosition() {
        let height = btnAreaView!.frame.size.height - 50
        let width = btnAreaView!.frame.size.width - 50
        
        for index in 1...btnNum {
//            let button = btnAreaView.viewWithTag(index) as? UIButton
            let button = btnUIGroup[index-1]
            button.frame = CGRect(x: Int(CGFloat( arc4random_uniform( UInt32( floor( width  ) ) ) )), y: Int(CGFloat( arc4random_uniform( UInt32( floor( height ) ) ) )), width: 50, height: 50)
            if index == 1 {
                button.backgroundColor = .red
                
            }
            else {
                button.backgroundColor = .green
            }
        }
        print("inside random? \(isOverlap)")
        isOverlap = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
