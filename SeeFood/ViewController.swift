//
//  ViewController.swift
//  SeeFood
//
//  Created by Karen Turner on 4/6/22.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
     }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userChosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userChosenImage
            
            guard let ciImage = CIImage(image: userChosenImage) else {
                fatalError("Error converting image to CIImage")
            }
            
            detect(image: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as?[VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            print(results)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
        try handler.perform([request])
        } catch {
            print(error)
        }
    }

    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

