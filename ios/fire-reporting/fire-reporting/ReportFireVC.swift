import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class ReportFireVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var featuredImage: UIImageView!
    var isImageSelected :Bool!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func didTapAddImage(_ sender: Any) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        //               picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func didTapDone(_ sender: Any) {
    }
    
    @IBAction func didTapGoBack(_ sender: Any) {
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            featuredImage.image = selectedImage
        }
                
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didTapUpload(_ sender: Any) {
      
    }
    
}
