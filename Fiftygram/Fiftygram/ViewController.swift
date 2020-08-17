//
//  ViewController.swift
//  Fiftygram
//
//  Created by Liliana Covileac on 04/08/2020.
//  Copyright © 2020 Liliana Covileac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    let context = CIContext()
    var original: UIImage?
    
    @IBAction func choosePhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            navigationController?.present(picker, animated: true, completion: nil)
        }
    
    }
    
    @IBAction func applySepia()
    {
        if original == nil {
            return
        }
        
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(0.5, forKey: kCIInputIntensityKey)
        display(filter: filter!)
    }
    
    @IBAction func applyNoir(){
        if original == nil{
            return
        }
        
        let filter = CIFilter(name: "CIPhotoEffectNoir")
        display(filter: filter!)
        
    }
    @IBAction func applyChrome(){
        if original == nil{
            return
        }
        
        let filter = CIFilter(name: "CIPhotoEffectChrome")
        display(filter: filter!)
    }
    
    @IBAction func applyVignette()
    {
        if original == nil {
                   return
               }
        
        let filter = CIFilter(name: "CIVignette")
        filter?.setValue(1, forKey: kCIInputIntensityKey)
        filter?.setValue(1, forKey: kCIInputRadiusKey)
        display(filter: filter!)
        
    }
    
    @IBAction func applyVintage(){
        if original == nil {
            return
        }
        
        let filter = CIFilter(name: "CIPhotoEffectProcess")
        display(filter: filter!)
    }
    
    @IBAction func showOriginal()
    {
        if original == nil{
            return
        }
        
        imageView.image = original
    }
    
    func display(filter: CIFilter)
    {
        filter.setValue(CIImage(image: original!), forKey: kCIInputImageKey)
        let output = filter.outputImage
        imageView.image = UIImage(cgImage: self.context.createCGImage(output!, from: output!.extent)!)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        navigationController?.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            original = image
        }
    }

    @IBAction func saveImage()
    {
        guard let image = imageView.image else {
            let alert = UIAlertController(title: "No Image was selected", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("We got an error : \(error) ")
        } else {
            print("Your image was saved successfully!")
            let alert = UIAlertController(title: "Image saved successfully", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
 
}

