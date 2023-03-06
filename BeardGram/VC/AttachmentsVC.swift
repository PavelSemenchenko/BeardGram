//
//  AttachmentsVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 06.03.2023.
//

import Foundation
import UIKit
import Photos
import PhotosUI

class AttachmentsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var addImageView: UIImageView!
    
    var photoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addImageGestureRecogniserClicked(_ sender: Any) {
        let img = UIImagePickerController()
        img.sourceType = .savedPhotosAlbum
        img.allowsEditing = true
        img.delegate = self
        present(img, animated: true)
    }
    
    @IBAction func sendImageButton(_ sender: Any) {
        guard let img = photoURL else {
            return
        }
    }
    
}
