//import UIKit
//
//@objc(ViewController)
//class ViewController: UIViewController, UINavigationControllerDelegate {
//
//  // MARK: - Properties
//
//  /// Model interpreter manager that manages loading models and detecting objects.
//  private lazy var modelManager = ModelInterpreterManager()
//
//
//  // MARK: - IBActions
//
//  @IBAction func detectObjects(_ sender: Any) {
//
//
//    setUpLocalModel()
//
//    guard let image = imageView.image else {
//      resultsTextView.text = "Image must not be nil.\n"
//      return
//    }
//
//  print("Loading the local model...\n")
//  if !modelManager.loadLocalModel(isQuantized: false) {
//    print("Failed to load the local model.")
//    return
//  }
//    var newResultsTextString = "Starting inference...\n"
//
//    let isQuantized = false
//    DispatchQueue.global(qos: .userInitiated).async {
//      var imageData: Any?
//      if isQuantized {
//        imageData = self.modelManager.scaledImageData(from: image,
//                                                      componentsCount: 3)
//      } else {
//        imageData = self.modelManager.scaledPixelArray(from: image,
//                                                       componentsCount: 3,
//                                                       isQuantized: isQuantized)
//      }
//
//      self.modelManager.detectObjects(in: imageData) { (results, error) in
//        guard error == nil, let results = results, !results.isEmpty else {
//          var errorString = error?.localizedDescription ?? Constants.failedToDetectObjectsMessage
//          errorString = "Inference error: \(errorString)"
//          print(errorString)
//          return
//        }
//
//        print(self.detectionResultsString(fromResults: results))
//
//      }
//    }
//  }
//
//  /// Sets up the local model.
//  private func setUpLocalModel() {
//    let name = ModelInterpreterConstants.floatModelFilename
//    let filename = ModelInterpreterConstants.floatModelFilename
//    if !modelManager.setUpLocalModel(withName: name, filename: filename) {
//      print("\nFailed to set up the local model.")
//    }
//  }
//
//  /// Returns a string representation of the detection results.
//  private func detectionResultsString(
//    fromResults results: [(label: String, confidence: Float)]?
//  ) -> String {
//    guard let results = results else { return Constants.failedToDetectObjectsMessage }
//    return results.reduce("") { (resultString, result) -> String in
//      let (label, confidence) = result
//      return resultString + "\(label): \(String(describing: confidence))\n"
//    }
//  }
//}
//
//// MARK: - Constants
//private enum Constants {
//  static let failedToDetectObjectsMessage = "Failed to detect objects in image."
//}
