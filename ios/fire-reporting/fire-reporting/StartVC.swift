import Foundation
import UIKit
import Firebase
import FirebaseAuth


class StartVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        Auth.auth().addStateDidChangeListener({ (auth:Auth, user:User?) in
            
            if user != nil {
                self.performSegue(withIdentifier: "goToHome", sender: nil)
            }else{
                self.performSegue(withIdentifier: "goToLogin", sender: nil)
            }
        })
        
    }
}
