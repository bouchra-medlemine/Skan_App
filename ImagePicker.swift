/*
 * ImagePicker.swift  
 *
 * Author: Bouchra Mohamed Lemine
 * Date: 03/04/2024
 *
 * Description: This struct reads an image from the camera or the photo library, runs the DenseNet model to classify it, and returns the results to ScanView.
 * Some of the code used in this file is from https://www.appcoda.com/swiftui-camera-photo-library/
 */


import SwiftUI
import Vision

 

struct ImagePicker: UIViewControllerRepresentable {
    
    // Defines the image source (i.e., camera or photoLibrary)
    var sourceType: UIImagePickerController.SourceType
    
    // The following 2 binding variables store the skin lesion photo and its diagnosis.
    @Binding var selectedImage: UIImage?
    @Binding var prediction: String
    
    // imageWasClassified is used in ScanView to know if the image selection and classification completed successfully, in that case ImageView is shown.
    @Binding var imageWasClassified: Bool
    
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePicker
        let labels = ["Benign", "Malignant"]
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
                
                // Check if the DenseNet model can be loaded
                guard let model = try? VNCoreMLModel(for: DenseNet_Model().model) else {
                    self.parent.prediction = "Error!!! Cannot load the model"
                    fatalError("Unable to load model 😫")
                }
                
                print("Successfully loaded the model 🎉")
            
                // Create a vision request to run the image through the model.
                let request = VNCoreMLRequest(model: model) {request, error in
                    
                    print("Request created 🎉")
                    
                    let result = request.results?.description
                    print(result ?? "No result found")

                    // Parse the output to get the label predicted by the model.
                    let firstIndex = result?.lastIndex(of: "[")
                    let lastIndex = result?.firstIndex(of: "]")
                    let model_output = String(result?[(result?.index(after: firstIndex!) ?? String.Index(encodedOffset: 0))...(result?.index(before: lastIndex!) ?? String.Index(encodedOffset: 0))] ?? "").split(separator: ",")
                    
                    let predicted_class = zip(model_output.indices, model_output).max(by: { $0.1 < $1.1 })?.0
                        
                    // Save the model output
                    self.parent.prediction = "\(self.labels[predicted_class ?? 0])"
                    self.parent.imageWasClassified = true
                    
                }
                
                // Change the image format from UIImage to CIImage so that the model can process it.
                guard let ciImage = CIImage(image: image)
                else { 
                    self.parent.prediction = "Error!!! Cannot read picked image"
                    fatalError("Cannot read picked image")
                }
                
                // Run the classifier
                let handler = VNImageRequestHandler(ciImage: ciImage)
                 
                do {
                    try handler.perform([request])
                } catch {
                    print(error)
                }
            }
            
            // Exit the photo library or camera view after an image is chosen.
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
