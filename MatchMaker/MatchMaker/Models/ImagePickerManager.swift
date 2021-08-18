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

/**
 ImagePickerManager is a class created to abstract and facilitate the process of accessing the users camera and gallery in order to upload photos to the App.
 
 **Important: In order to use this class you must call inside an UIViewController**
 
 How to use: ```ImagePickerManager().pickImage(self) { image, url
    //your implementation goes here
 }```
 
 */
class ImagePickerManager: NSObject, UINavigationControllerDelegate {
    
    //MARK: ImagePickerManager - Variables Setup

    private var picker = UIImagePickerController()
    private weak var viewController: UIViewController?
    private var pickImageCallback : ((UIImage, URL) -> ())?
    
    private let galleryAccessMessage: String = NSLocalizedString("galleryAccessMessage", comment: "This is the translation for 'galleryAccessMessage' at the ImagePickerManager section of Localizable.strings")
    private let cameraAccessMessage: String = NSLocalizedString("cameraAccessMessage", comment: "This is the translation for 'cameraAccessMessage' at the ImagePickerManager section of Localizable.strings")

    //MARK: ImagePickerManager - Class init
    
    override init(){
        super.init()
        
        //PHPhotoLibrary.shared().register(self)

        // Add the actions
        picker.delegate = self
    }
    
    //MARK: ImagePickerManager - Class functions
    
    /**
     Sets up an image either from the gallery or the camera given by the user.
     
     - Parameters:
        - viewController: the UIViewController in question to present the alert
        - callback: the actual implementation of the closure
     
     - returns: Void
     */
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage, URL) -> ())) {
        let alert = UIAlertController(title: NSLocalizedString("cameraGallerySheet", comment: "This is the translation for 'cameraGallerySheet' at the ImagePickerManager section of Localizable.strings"), message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: NSLocalizedString("cameraAction", comment: "This is the translation for 'cameraAction' at the ImagePickerManager section of Localizable.strings"), style: .default){ [weak self] UIAlertAction in
            guard let self = self else { return }
            self.requestUserPermissionForCamera()
        }
        
        let galleryAction = UIAlertAction(title: NSLocalizedString("galleryAction", comment: "This is the translation for 'galleryAction' at the ImagePickerManager section of Localizable.strings"), style: .default){ [weak self] UIAlertAction in
            guard let self = self else { return }
            self.requestPermissionForPhotoLibrary()
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancelAction", comment: "This is the translation for 'cancelAction' at the ImagePickerManager section of Localizable.strings"), style: .cancel){ [weak self] UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        pickImageCallback = callback
        self.viewController = viewController

        alert.popoverPresentationController?.sourceView = self.viewController?.view

        viewController.present(alert, animated: true, completion: nil)
    }
    
    /**
     If available, opens up the camera
     
     - Parameters: No parameters
     
     - returns: Void
     */
    private func openCamera(){
//        DispatchQueue.main.async {
//            self.viewController?.dismiss(animated: true, completion: nil)
//        }
        
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            DispatchQueue.main.async {
                self.picker.sourceType = .camera
                self.viewController?.present(self.picker, animated: true, completion: nil)
            }
        }
        else {
            DispatchQueue.main.async {
                let alertController: UIAlertController = {
                    let controller = UIAlertController(title: NSLocalizedString("warningTitle", comment: "This is the translation for 'warningTitle' at the ImagePickerManager section of Localizable.strings"), message: NSLocalizedString("cameraError", comment: "This is the translation for 'cameraError' at the ImagePickerManager section of Localizable.strings"), preferredStyle: .alert)
                    let action = UIAlertAction(title: NSLocalizedString("OKAction", comment: "This is the translation for 'OKAction' at the ImagePickerManager section of Localizable.strings"), style: .default)
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
    private func openGallery(){
        DispatchQueue.main.async {
//            self.viewController?.dismiss(animated: true, completion: nil)
            self.picker.sourceType = .photoLibrary
            self.viewController?.present(self.picker, animated: true, completion: nil)
        }
    }
    
    /**
     Opens up the limited photo gallery
     
     - Parameters: No parameters
     
     - returns: Void
     */
    private func openLimitedGallery(){
        let actionSheet = UIAlertController(title: NSLocalizedString("avatarUploadSheetTitle", comment: "This is the translation for 'avatarUploadSheetTitle' at the ImagePickerManager section of Localizable.strings"), message: NSLocalizedString("avatarUploadSheetMessage", comment: "This is the translation for 'avatarUploadSheetMessage' at the ImagePickerManager section of Localizable.strings"), preferredStyle: .actionSheet)
        
        let selectProfileImage = UIAlertAction(title: NSLocalizedString("selectImageAction", comment: "This is the translation for 'selectImageAction' at the ImagePickerManager section of Localizable.strings"), style: .default) { [unowned self] (_) in
            DispatchQueue.main.async {
                //self.viewController?.dismiss(animated: true, completion: nil)
                
                //old method
                self.picker.sourceType = .photoLibrary
                self.viewController?.present(self.picker, animated: true, completion: nil)
                
//                var configuration = PHPickerConfiguration(photoLibrary: .shared())
//                configuration.selectionLimit = 1
//                configuration.filter = .images
//
//                let picker = PHPickerViewController(configuration: configuration)
//                self.viewController?.present(picker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(selectProfileImage)

        let selectPhotosAction = UIAlertAction(title: NSLocalizedString("limitedGalleryAction", comment: "This is the translation for 'limitedGalleryAction' at the ImagePickerManager section of Localizable.strings"), style: .default) { [unowned self] (_) in
            // Show limited library picker
            guard let viewController = self.viewController else { return }
            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: viewController)
        }
        actionSheet.addAction(selectPhotosAction)

        let allowFullAccessAction = UIAlertAction(title: NSLocalizedString("fullGalleryAction", comment: "This is the translation for 'fullGalleryAction' at the ImagePickerManager section of Localizable.strings"), style: .default) { [unowned self] (_) in
            // Open app privacy settings
            gotoAppPrivacySettings()
        }
        actionSheet.addAction(allowFullAccessAction)

        let cancelAction = UIAlertAction(title: NSLocalizedString("cancelAction", comment: "This is the translation for 'cancelAction' at the ImagePickerManager section of Localizable.strings"), style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)

        self.viewController?.present(actionSheet, animated: true, completion: nil)
    }
    
    /**
     Redirects the user to the app privacy settings
     
     - Parameters: No parameters
     
     - returns: Void
     */
    private func gotoAppPrivacySettings() {
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
    private func requestPermissionForPhotoLibrary(){
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
            case .authorized:
                self.openGallery()
                return
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
                            self.openGallery()
                        }
                        return
                    case .denied:
                        DispatchQueue.main.async {
                            let alertController: UIAlertController = {
                                let controller = UIAlertController(title: NSLocalizedString("warningTitle", comment: "This is the translation for 'warningTitle' at the ImagePickerManager section of Localizable.strings"), message: self.galleryAccessMessage, preferredStyle: .alert)
                                let action = UIAlertAction(title: NSLocalizedString("OKAction", comment: "This is the translation for 'OKAction' at the ImagePickerManager section of Localizable.strings"), style: .default)
                                controller.addAction(action)
                                
                                return controller
                            }()
                            
                            self.viewController?.present(alertController, animated: true)
                        }
                        return
                    case .limited:
                        DispatchQueue.main.async {
                            let alertController: UIAlertController = {
                                let controller = UIAlertController(title: NSLocalizedString("warningTitle", comment: "This is the translation for 'warningTitle' at the ImagePickerManager section of Localizable.strings"), message: self.galleryAccessMessage, preferredStyle: .alert)
                                let action = UIAlertAction(title: NSLocalizedString("OKAction", comment: "This is the translation for 'OKAction' at the ImagePickerManager section of Localizable.strings"), style: .default)
                                controller.addAction(action)
                                
                                return controller
                            }()
                            
                            self.viewController?.present(alertController, animated: true)
                        }
                        return
                    case .notDetermined:
                        DispatchQueue.main.async {
                            let alertController: UIAlertController = {
                                let controller = UIAlertController(title: NSLocalizedString("warningTitle", comment: "This is the translation for 'warningTitle' at the ImagePickerManager section of Localizable.strings"), message: self.galleryAccessMessage, preferredStyle: .alert)
                                let action = UIAlertAction(title: NSLocalizedString("OKAction", comment: "This is the translation for 'OKAction' at the ImagePickerManager section of Localizable.strings"), style: .default)
                                controller.addAction(action)
                                
                                return controller
                            }()
                            
                            self.viewController?.present(alertController, animated: true)
                        }
                        return
                    case .restricted:
                        DispatchQueue.main.async {
                            let alertController: UIAlertController = {
                                let controller = UIAlertController(title: NSLocalizedString("warningTitle", comment: "This is the translation for 'warningTitle' at the ImagePickerManager section of Localizable.strings"), message: self.galleryAccessMessage, preferredStyle: .alert)
                                let action = UIAlertAction(title: NSLocalizedString("OKAction", comment: "This is the translation for 'OKAction' at the ImagePickerManager section of Localizable.strings"), style: .default)
                                controller.addAction(action)
                                
                                return controller
                            }()
                            
                            self.viewController?.present(alertController, animated: true)
                        }
                        return
                    @unknown default:
                        fatalError("An Error occurred while trying to access the gallery")
                    }
                }
                
                return
            case .restricted:
                DispatchQueue.main.async {
                    let alertController: UIAlertController = {
                        let controller = UIAlertController(title: NSLocalizedString("warningTitle", comment: "This is the translation for 'warningTitle' at the ImagePickerManager section of Localizable.strings"), message: self.galleryAccessMessage, preferredStyle: .alert)
                        let action = UIAlertAction(title: NSLocalizedString("OKAction", comment: "This is the translation for 'OKAction' at the ImagePickerManager section of Localizable.strings"), style: .default)
                        controller.addAction(action)
                        
                        return controller
                    }()
                    
                    self.viewController?.present(alertController, animated: true)
                }
                
                return
            case .denied:
                DispatchQueue.main.async {
                    let alertController: UIAlertController = {
                        let controller = UIAlertController(title: NSLocalizedString("warningTitle", comment: "This is the translation for 'warningTitle' at the ImagePickerManager section of Localizable.strings"), message: self.galleryAccessMessage, preferredStyle: .alert)
                        let action = UIAlertAction(title: NSLocalizedString("OKAction", comment: "This is the translation for 'OKAction' at the ImagePickerManager section of Localizable.strings"), style: .default)
                        controller.addAction(action)
                        
                        return controller
                    }()
                    
                    self.viewController?.present(alertController, animated: true)
                }
                
                return
            case .limited:
                DispatchQueue.main.async {
                    let alertController: UIAlertController = {
                        let controller = UIAlertController(title: NSLocalizedString("warningTitle", comment: "This is the translation for 'warningTitle' at the ImagePickerManager section of Localizable.strings"), message: self.galleryAccessMessage, preferredStyle: .alert)
                        let action = UIAlertAction(title: NSLocalizedString("OKAction", comment: "This is the translation for 'OKAction' at the ImagePickerManager section of Localizable.strings"), style: .default)
                        controller.addAction(action)
                        
                        return controller
                    }()
                    
                    self.viewController?.present(alertController, animated: true)
                }
                return
            @unknown default:
                DispatchQueue.main.async {
                    let alertController: UIAlertController = {
                        let controller = UIAlertController(title: NSLocalizedString("warningTitle", comment: "This is the translation for 'warningTitle' at the ImagePickerManager section of Localizable.strings"), message: self.galleryAccessMessage, preferredStyle: .alert)
                        let action = UIAlertAction(title: NSLocalizedString("OKAction", comment: "This is the translation for 'OKAction' at the ImagePickerManager section of Localizable.strings"), style: .default)
                        controller.addAction(action)
                        
                        return controller
                    }()
                    
                    self.viewController?.present(alertController, animated: true)
                }
        }
    }
    
    /**
     Requests user's permission for camera usage.
     
     - Parameters: No parameters
     
     - Returns: Void
     */
    private func requestUserPermissionForCamera() {
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
                            let controller = UIAlertController(title: NSLocalizedString("warningTitle", comment: "This is the translation for 'warningTitle' at the ImagePickerManager section of Localizable.strings"), message: self.galleryAccessMessage, preferredStyle: .alert)
                            let action = UIAlertAction(title: NSLocalizedString("OKAction", comment: "This is the translation for 'OKAction' at the ImagePickerManager section of Localizable.strings"), style: .default)
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
                    let controller = UIAlertController(title: NSLocalizedString("warningTitle", comment: "This is the translation for 'warningTitle' at the ImagePickerManager section of Localizable.strings"), message: self.galleryAccessMessage, preferredStyle: .alert)
                    let action = UIAlertAction(title: NSLocalizedString("OKAction", comment: "This is the translation for 'OKAction' at the ImagePickerManager section of Localizable.strings"), style: .default)
                    controller.addAction(action)
                    
                    return controller
                }()
                
                self.viewController?.present(alertController, animated: true)
            }
            
            return
        case .denied:
            DispatchQueue.main.async {
                let alertController: UIAlertController = {
                    let controller = UIAlertController(title: NSLocalizedString("warningTitle", comment: "This is the translation for 'warningTitle' at the ImagePickerManager section of Localizable.strings"), message: self.galleryAccessMessage, preferredStyle: .alert)
                    let action = UIAlertAction(title: NSLocalizedString("OKAction", comment: "This is the translation for 'OKAction' at the ImagePickerManager section of Localizable.strings"), style: .default)
                    controller.addAction(action)
                    
                    return controller
                }()
                
                self.viewController?.present(alertController, animated: true)
            }
            
            return
        @unknown default:
            DispatchQueue.main.async {
                let alertController: UIAlertController = {
                    let controller = UIAlertController(title: NSLocalizedString("warningTitle", comment: "This is the translation for 'warningTitle' at the ImagePickerManager section of Localizable.strings"), message: self.galleryAccessMessage, preferredStyle: .alert)
                    let action = UIAlertAction(title: NSLocalizedString("OKAction", comment: "This is the translation for 'OKAction' at the ImagePickerManager section of Localizable.strings"), style: .default)
                    controller.addAction(action)
                    
                    return controller
                }()
                
                self.viewController?.present(alertController, animated: true)
            }
        }
    }
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
        
        guard let image = info[.originalImage] as? UIImage
        else {
            fatalError("Expected a dictionary containing an image and the URL of the image, but was provided the following: \(info)")
        }
        
        var imageURL = info[.imageURL] as? URL
        
        if imageURL == nil,
           let cacheURL = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
            
            imageURL = cacheURL.appendingPathComponent(UUID().uuidString)
            try? image.jpegData(compressionQuality: 1)?.write(to: imageURL!)
        }

        pickImageCallback?(image, imageURL!)
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
