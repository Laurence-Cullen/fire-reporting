import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import CoreLocation

class ReportFireVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate
 {
    /// Model interpreter manager that manages loading models and detecting objects.
    private lazy var modelManager = ModelInterpreterManager()

    
    @IBOutlet weak var imagePicked: UIImageView!
    
    var isImageSelected :Bool!
    var db: Firestore!
    
    var placeLatitude: Double = 0.0
    var placeLongitude: Double = 0.0

    @IBOutlet weak var descriptionTextView: UITextView!
    var locationManager:CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        db = Firestore.firestore()
    
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        print( "\(userLocation.coordinate.latitude)")
        print("\(userLocation.coordinate.longitude)")
        
        placeLongitude = userLocation.coordinate.longitude
        placeLatitude = userLocation.coordinate.longitude
        
        UserDefaults.standard.set(userLocation.coordinate.latitude as Double, forKey: "LAT")
        UserDefaults.standard.set(userLocation.coordinate.longitude as Double, forKey: "LON")
        UserDefaults().synchronize()
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // perform inferance
        // ------------------------------------------------------------
        imagePicked.image = image
        
        setUpLocalModel()
        
        print("Loading the local model...\n")
        if !modelManager.loadLocalModel(isQuantized: false) {
            print("Failed to load the local model.")
            return
        }
        print("Starting inference...\n")
        
        let isQuantized = false
        DispatchQueue.global(qos: .userInitiated).async {
            var imageData: Any?
            if isQuantized {
                imageData = self.modelManager.scaledImageData(from: image,
                                                              componentsCount: 3)
            } else {
                imageData = self.modelManager.scaledPixelArray(from: image,
                                                               componentsCount: 3,
                                                               isQuantized: isQuantized)
            }
            
            self.modelManager.detectObjects(in: imageData) { (results, error) in
                guard error == nil, let results = results, !results.isEmpty else {
                    var errorString = error?.localizedDescription ?? Constants.failedToDetectObjectsMessage
                    errorString = "Inference error: \(errorString)"
                    print(errorString)
                    return
                }
                
                print(self.detectionResultsString(fromResults: results))
                
            }
        }
        
        // end inferance
        // ------------------------------------------------------------
        
        dismiss(animated:true, completion: nil)
    }
    
    
    func storeReport() {
        
        let user = Auth.auth().currentUser
        let ref = db.collection("reports").document()
        
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("featured_images").child("\(imageName).png")
        
        //Compress New Event Image and Upload
        do {
            try self.imagePicked.image?.compressImage(300, completion: { (image, compressRatio) in
                print(image.size)
                let imageData = UIImageJPEGRepresentation(image, compressRatio)
                
                storageRef.putData(imageData!, metadata: nil, completion: { (metadata, error) in
                    
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url, error) in
                        if (error == nil) {
                            if let profileImageUrl = url?.absoluteString {
                                
                                let lat = UserDefaults.standard.value(forKey: "LAT")
                                let lon = UserDefaults.standard.value(forKey: "LON")
                                
                                let currentGeoLocation = GeoPoint(latitude: lat as! Double, longitude: lon as! Double)
                                
                                
                                let newEvent = Report(uid: (user?.uid)!, eventID: (ref.documentID), geoLocation:currentGeoLocation, lat: lat as! Double, lon: lon as! Double, imageURL: profileImageUrl, description: self.descriptionTextView.text!, createdAt: Date(), updatedAt: Date())
                                
                                ref.setData(newEvent.dictionary)
                                
                                self.dismiss(animated: true, completion: nil)
                                print("Dimiss processed")
                                
                                
                            }
                        } else {
                            // Do something if error
                            print("Something went wrong!")
                        }
                    })
                    
                })
            })
        } catch {
            print("Error")
        }
        
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        storeReport()
    }
    
    @IBAction func didTapGoBack(_ sender: Any) {
    }
    
    /// Sets up the local model.
    private func setUpLocalModel() {
        let name = ModelInterpreterConstants.floatModelFilename
        let filename = ModelInterpreterConstants.floatModelFilename
        if !self.modelManager.setUpLocalModel(withName: name, filename: filename) {
            print("\nFailed to set up the local model.")
        }
    }
    
    /// Returns a string representation of the detection results.
    private func detectionResultsString(
        fromResults results: [(label: String, confidence: Float)]?
        ) -> String {
        guard let results = results else { return Constants.failedToDetectObjectsMessage }
        return results.reduce("") { (resultString, result) -> String in
            let (label, confidence) = result
            return resultString + "\(label): \(String(describing: confidence))\n"
        }
    }

    
}


extension UIImage {
    
    enum CompressImageErrors: Error {
        case invalidExSize
        case sizeImpossibleToReach
    }
    func compressImage(_ expectedSizeKb: Int, completion : (UIImage,CGFloat) -> Void ) throws {
        
        let minimalCompressRate :CGFloat = 0.4 // min compressRate to be checked later
        
        if expectedSizeKb == 0 {
            throw CompressImageErrors.invalidExSize // if the size is equal to zero throws
        }
        
        let expectedSizeBytes = expectedSizeKb * 1024
        let imageToBeHandled: UIImage = self
        var actualHeight : CGFloat = self.size.height
        var actualWidth : CGFloat = self.size.width
        var maxHeight : CGFloat = 841 //A4 default size I'm thinking about a document
        var maxWidth : CGFloat = 594
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 1
        var imageData:Data = UIImageJPEGRepresentation(imageToBeHandled, compressionQuality)!
        while imageData.count > expectedSizeBytes {
            
            if (actualHeight > maxHeight || actualWidth > maxWidth){
                if(imgRatio < maxRatio){
                    imgRatio = maxHeight / actualHeight;
                    actualWidth = imgRatio * actualWidth;
                    actualHeight = maxHeight;
                }
                else if(imgRatio > maxRatio){
                    imgRatio = maxWidth / actualWidth;
                    actualHeight = imgRatio * actualHeight;
                    actualWidth = maxWidth;
                }
                else{
                    actualHeight = maxHeight;
                    actualWidth = maxWidth;
                    compressionQuality = 1;
                }
            }
            let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
            UIGraphicsBeginImageContext(rect.size);
            imageToBeHandled.draw(in: rect)
            let img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if let imgData = UIImageJPEGRepresentation(img!, compressionQuality) {
                if imgData.count > expectedSizeBytes {
                    if compressionQuality > minimalCompressRate {
                        compressionQuality -= 0.1
                    } else {
                        maxHeight = maxHeight * 0.9
                        maxWidth = maxWidth * 0.9
                    }
                }
                imageData = imgData
            }
            
            
        }
        
        completion(UIImage(data: imageData)!, compressionQuality)
    }
}

// MARK: - Constants
private enum Constants {
    static let failedToDetectObjectsMessage = "Failed to detect objects in image."
}
