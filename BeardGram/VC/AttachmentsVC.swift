//
//  AttachmentsVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 06.03.2023.
//

import Foundation
import UIKit
import AlamofireImage

class AttachmentsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var addImageView: UIImageView!
    
    var imageURL: URL?
    let imageRepository: MessagesRepository = FirebaseMessagesRepository()
    var onImageReady: ((URL) -> Void)?
    
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
        guard let img = imageURL else {
            return 
        }
        self.onImageReady?(img)
        self.navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: false)
        imageURL = info[.imageURL] as? URL
        guard let image = imageURL else {
            return
        }
        addImageView.af.setImage(withURL: image)
    }
}
