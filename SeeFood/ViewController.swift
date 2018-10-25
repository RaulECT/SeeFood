//
//  ViewController.swift
//  SeeFood
//
//  Created by Raul  Canul on 10/25/18.
//  Copyright © 2018 Raul  Canul. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UI Elements
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else { fatalError( "Could not convert to CIImage" ) }
            
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { fatalError("Loading CoreML Model failed") }
    
        let request = VNCoreMLRequest(model: model) { (req, error) in
            guard let result = req.results as? [VNClassificationObservation] else { fatalError( "Convert results failed" ) }
            
            print(result)
        }
        
        let handler = VNImageRequestHandler(ciImage: image )
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        

    }
    


}

