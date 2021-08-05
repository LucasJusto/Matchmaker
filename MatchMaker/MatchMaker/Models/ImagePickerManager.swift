//
//  ImagePickerManager.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 30/07/21.
//

import Foundation
import AVFoundation
import PhotosUI
import UIKit

//MARK: - ImagePickerManager Class

class ImagePickerManager: NSObject, UINavigationControllerDelegate {
    
    //MARK: ImagePickerManager - Variables Setup

    var picker = UIImagePickerController()
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage, URL) -> ())?
    
    private let galleryAccessMessage: String = "In order to set a profile image, you must grant access to your gallery. Go to Settings > Matchmaker > Photos."
    private let cameraAccessMessage: String = "In order to set a profile image, you must grant access to your gallery. Go to Settings > Matchmaker > Camera."

    //MARK: ImagePickerManager - Class init
    
    override init(){
        super.init()
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){ UIAlertAction in
            self.requestUserPermissionForCamera()
            
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){ UIAlertAction in
            self.requestPermissionForPhotoLibrary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ UIAlertAction in
        }
        
        //PHPhotoLibrary.shared().register(self)

        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
    }
    
    /**
     Sets up an image either from the gallery or the camera given by the user.
     
     - Parameters:
        - viewController: the UIViewController in question to present the alert
        - callback: the actual implementation of the closure
     
     - returns: Void
     */
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage, URL) -> ())) {
        pickImageCallback = callback
        self.viewController = viewController

        alert.popoverPresentationController?.sourceView = self.viewController!.view

        viewController.present(alert, animated: true, completion: nil)
    }
    
    /**
     If available, opens up the camera
     
     - Parameters: No parameters
     
     - returns: Void
     */
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            DispatchQueue.main.async {
                self.picker.sourceType = .camera
                self.viewController!.present(self.picker, animated: true, completion: nil)
            }
        }
        else {
            DispatchQueue.main.async {
                let alertController: UIAlertController = {
                    let controller = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    controller.addAction(action)
                    
                    return controller
                }()
                
                self.viewController?.present(alertController, animated: true)
            }
        }
    }
    
    /**
     Opens up the photo gallery
     
     - Parameters: No parameters
     
     - returns: Void
     */
    func openGallery(){
        DispatchQueue.main.async {
            self.alert.dismiss(animated: true, completion: nil)
            self.picker.sourceType = .photoLibrary
            self.viewController!.present(self.picker, animated: true, completion: nil)
        }
    }
    
    /**
     Opens up the limited photo gallery
     
     - Parameters: No parameters
     
     - returns: Void
     */
    func openLimitedGallery(){
        let actionSheet = UIAlertController(title: "Select an option", message: "Select more photos or go to Settings to allow access to all photos.", preferredStyle: .actionSheet)
        
        let selectProfileImage = UIAlertAction(title: "Select a photo from gallery", style: .default) { [unowned self] (_) in
            DispatchQueue.main.async {
                self.alert.dismiss(animated: true, completion: nil)
                self.picker.sourceType = .photoLibrary
                self.viewController!.present(self.picker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(selectProfileImage)

        let selectPhotosAction = UIAlertAction(title: "Select more photos", style: .default) { [unowned self] (_) in
            // Show limited library picker
            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: viewController!)
        }
        actionSheet.addAction(selectPhotosAction)

        let allowFullAccessAction = UIAlertAction(title: "Allow access to all photos", style: .default) { [unowned self] (_) in
            // Open app privacy settings
            gotoAppPrivacySettings()
        }
        actionSheet.addAction(allowFullAccessAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)

        self.viewController!.present(actionSheet, animated: true, completion: nil)
    }
    
    /**
     Redirects the user to the app privacy settings
     
     - Parameters: No parameters
     
     - returns: Void
     */
    func gotoAppPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else {
                assertionFailure("Not able to open App privacy settings")
                return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    /**
     Requests user's permission for photo gallery usage.
     
     - Parameters: No parameters
     
     - Returns: Void
     */
    func requestPermissionForPhotoLibrary(){
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
            case .authorized:
                self.openGallery()
                return
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    if status == .authorized {
                        self.openGallery()
                    }
                    else {
                        DispatchQueue.main.async {
                            let alertController: UIAlertController = {
                                let controller = UIAlertController(title: "Warning", message: self.galleryAccessMessage, preferredStyle: .alert)
                                let action = UIAlertAction(title: "OK", style: .default)
                                controller.addAction(action)
                                
                                return controller
                            }()
                            
                            self.viewController?.present(alertController, animated: true)
                        }
                    }
                }
                
                return
            case .restricted:
                DispatchQueue.main.async {
                    let alertController: UIAlertController = {
                        let controller = UIAlertController(title: "Warning", message: self.galleryAccessMessage, preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default)
                        controller.addAction(action)
                        
                        return controller
                    }()
                    
                    self.viewController?.present(alertController, animated: true)
                }
                
                return
            case .denied:
                DispatchQueue.main.async {
                    let alertController: UIAlertController = {
                        let controller = UIAlertController(title: "Warning", message: self.galleryAccessMessage, preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default)
                        controller.addAction(action)
                        
                        return controller
                    }()
                    
                    self.viewController?.present(alertController, animated: true)
                }
                
                return
            case .limited:
                // FIXME: Wrong denied alert showing even when an image is selected
                openLimitedGallery()
                return
            @unknown default:
                fatalError("An Error occurred while trying to access the gallery")
        }
    }
    
    /**
     Requests user's permission for camera usage.
     
     - Parameters: No parameters
     
     - Returns: Void
     */
    func requestUserPermissionForCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.openCamera()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted { self.openCamera() }
                else {
                    DispatchQueue.main.async {
                        let alertController: UIAlertController = {
                            let controller = UIAlertController(title: "Warning", message: self.cameraAccessMessage, preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default)
                            controller.addAction(action)
                            
                            return controller
                        }()
                        
                        self.viewController?.present(alertController, animated: true)
                    }
                }
            }
            
            return
        case .restricted:
            DispatchQueue.main.async {
                let alertController: UIAlertController = {
                    let controller = UIAlertController(title: "Warning", message: self.cameraAccessMessage, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    controller.addAction(action)
                    
                    return controller
                }()
                
                self.viewController?.present(alertController, animated: true)
            }
            
            return
        case .denied:
            DispatchQueue.main.async {
                let alertController: UIAlertController = {
                    let controller = UIAlertController(title: "Warning", message: self.cameraAccessMessage, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    controller.addAction(action)
                    
                    return controller
                }()
                
                self.viewController?.present(alertController, animated: true)
            }
            
            return
        @unknown default:
            fatalError("An Error occurred while trying to access the camera")
        }
    }

//    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
//
//    }
}

//MARK: - UIImagePickerControllerDelegate Extension

extension ImagePickerManager: UIImagePickerControllerDelegate {
    
    //MARK: UIImagePickerControllerDelegate - Cancel Action
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate - Fetching both the Image and its URL
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage,
              let imageURL = info[.imageURL] as? URL
        else {
            fatalError("Expected a dictionary containing an image and the URL of the image, but was provided the following: \(info)")
        }
        
        pickImageCallback?(image, imageURL)
    }
}

//MARK: - PHPhotoLibraryChangeObserver Extension

//extension ImagePickerManager: PHPhotoLibraryChangeObserver {
//    func photoLibraryDidChange(_ changeInstance: PHChange) {
//        DispatchQueue.main.async { [unowned self] in
//            requestPermissionForPhotoLibrary()
//        }
//    }
//}
