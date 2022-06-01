import UIKit

class NameChangeViewController: UIViewController {
    let defalutFile = UserDefaults.standard

    @IBOutlet weak var nameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSave(_ sender: Any) {
        let username = nameTextField.text!
        
        defalutFile.set(username, forKey: "username")
        self.performSegue(withIdentifier: Const.saveNameSegue, sender: sender)
        
    }
    
    @IBAction func nameEntered(_ sender: Any) {
        print("User typed \(nameTextField.text!)")
        //this is the line of code you should add to your project.
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
