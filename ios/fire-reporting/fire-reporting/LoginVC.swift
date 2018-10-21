import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class LoginVC: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
          emailTextField.text = "john.doe@email.com"
            passwordTextField.text = "password"
        
        self.hideKeyboardWhenTappedAround()

        
    }
    
    @IBAction func didTapDone(_ sender: Any) {
//        showHUD(progressLabel: "Logging in")
        performSignIn()
    }
    
    func showAlertWithMessage(alertMessage:String){
        
        let alertCon = UIAlertController(title: "Sign In Failed", message:alertMessage , preferredStyle: UIAlertController.Style.alert)
        alertCon.addAction(UIAlertAction(title: "OK",
                                         style: UIAlertAction.Style.default,
                                         handler: {(alertCon: UIAlertAction!) in
                                            
                                            
                                            
        }))
        self.present(alertCon, animated: true, completion: nil)
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        performSignIn()
    }
    
    private func checkUserisalreadyinDB() {
//        let user = Auth.auth().currentUser
//        db.collection("users").whereField("uid", isEqualTo: user?.uid ?? "NO ID")
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//
//                    print("Error getting documents: \(err.localizedDescription)")
//
//                } else {
//
//                    if (querySnapshot?.documents.count)! > 0 {
//
//                        for document in querySnapshot!.documents {
//                            print("\(document.documentID) => \(document.data())")
//                            let allDoc = document.data()
//                            let ids = allDoc["uid"] as! String
//                            let name = allDoc["name"] as! String
//                            let accountType = allDoc["accountType"] as! String
//                            print(accountType)
//                            print(name)
//                            let defaults = UserDefaults.standard
//                            defaults.set(accountType, forKey: "accountType")
//                            defaults.set(ids, forKey: "uid")
//                            defaults.set(name, forKey:"name")
//
//                            print("#$#$%%***********************")
//                            if ids == user?.uid{
//                                print("User is available")
//                                self.performSegue(withIdentifier: "goToHome", sender: nil)
//                                break
//                            }
//                        }
//                    }
//                }
//        }
    }
    
    
    private func performSignIn() {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user == nil {
                
            }
            if error == nil {
                print("Login success")
                self.performSegue(withIdentifier: "goToHome", sender: nil)
            } else {
//                self.dismissHUD(isAnimated: true)
                self.showAlertWithMessage(alertMessage: "\(String(describing: error!.localizedDescription))")
            }
        }
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
