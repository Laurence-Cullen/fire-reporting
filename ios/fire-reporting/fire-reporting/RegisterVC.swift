import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var db: Firestore!
    var accountType: String!
    var avatarURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        nameTextField.becomeFirstResponder()
        
    }
    
    func showAlertWithMessage(alertMessage:String){
        
        let alertCon = UIAlertController(title: "Create Account Failed", message:alertMessage , preferredStyle: UIAlertController.Style.alert)
        alertCon.addAction(UIAlertAction(title: "OK",
                                         style: UIAlertAction.Style.default,
                                         handler: {(alertCon: UIAlertAction!) in
                                            
                                            
                                            
        }))
        
        
        self.present(alertCon, animated: true, completion: nil)
        
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.performSegue(withIdentifier: "goToInitial", sender: nil)
    }
    

    @IBAction func didTapRegister(_ sender: Any) {
        //        showHUD(progressLabel: "Signing up")
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user == nil {
            }
            if error == nil {
                self.addName()
                
            }else{
                
                //                self.dismissHUD(isAnimated: true)
                
                self.showAlertWithMessage(alertMessage: "\(String(describing: error!.localizedDescription))")
            }
        }
    }
    
    private func addName() {
        
        let user = Auth.auth().currentUser
        var _: DocumentReference? = nil
        
        let frankDocRef = db.collection("users").document(String(describing: Auth.auth().currentUser!.uid))
        frankDocRef.setData([
            "uid": user?.uid as Any,
            "name": nameTextField.text as Any,
            "email": emailTextField.text as Any,
            "createdAt": Date(),
            "updatedAt": Date(),
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(frankDocRef.documentID)")
                    
                    let defaults = UserDefaults.standard
                    defaults.set(self.accountType, forKey: "accountType")
                    defaults.set(user?.uid, forKey: "uid")
                    defaults.set(self.nameTextField.text, forKey: "name")
                    
                    self.performSegue(withIdentifier: "goToExplore", sender: nil)
                    
                    
                    
                }
        }
    }
    
}
