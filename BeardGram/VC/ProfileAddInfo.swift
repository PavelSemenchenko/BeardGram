//
//  ProfileAddInfo.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 06.02.2023.
//

import Foundation
import UIKit

class ProfileAddInfo: UIViewController {
    
    @IBOutlet weak var profileAddNameTextField: NameTextField!
    
    let profilesRepository: ProfilesRepository = FirebaseProfilesRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func continueRegButtonClicked(_ sender: Any) {
        onContinue()
        guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeSB") as? HomeVC else {
            return
        }
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    // need button
    func onContinue(){
        guard let name = profileAddNameTextField.text else {
            return
        }
        profilesRepository.createProfile(name: name)
    }
}
@IBDesignable
public class GradientProfileAddInfo: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }
}
