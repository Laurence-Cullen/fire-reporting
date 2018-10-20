import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class ReportFireVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    var isImageSelected :Bool!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    var imagePicker: UIImagePickerController!

    @IBAction func didTapTakePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Error")
        }
    }
    @IBAction func didTapAddImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    
  {
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
      
        guard let image = info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage else {
                return
        }
        
        imagePicked.image = image
        
        
//        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
    
    
    
    
    
    
    
    
    @IBAction func didTapDone(_ sender: Any) {
    }
    
    @IBAction func didTapGoBack(_ sender: Any) {
    }
    
 

    
}
