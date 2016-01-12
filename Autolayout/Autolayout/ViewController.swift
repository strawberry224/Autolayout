//
//  ViewController.swift
//  Autolayout
//
//  Created by Shen Lijia on 16/1/12.
//  Copyright © 2016年 ShenLijia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // after the demo, appropriate things were private-ized.
    // including outlets and actions.
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // once we're loaded (outlets set, etc.), update the UI
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // our Model, the logged in user
    var loggedInUser: User? { didSet { updateUI() } }
    
    // sets whether the password field is secure or not
    var secure = false { didSet { updateUI() } }
    
    // update the user-interface
    // by transferring information from the Model to our View
    // and setting up security in the password fields
    //
    // NOTE:    After the demo, this method was protected against
    //          crashing if it is called before our outlets are set
    //          This is nice to do sincee setting our Model calls this
    //          and our Model might get set while we are being prepared.
    //          It was easy too. Just added ? after outlets
    private func updateUI() {
        passwordField.secureTextEntry = secure
        passwordLabel.text = secure ? "Secure Password" : "Password"
        nameLabel.text = loggedInUser?.name
        companyLabel.text = loggedInUser?.company
        image = loggedInUser?.image
    }
    
    // toggle whether paawords are secure or not
    @IBAction func toggleSecurity() {
        secure = !secure
    }
    
    // log in (set our Model)
    @IBAction func login() {
        loggedInUser = User.login(loginField.text ?? "", password: passwordField.text ?? "")
    }
    
    
    // a convenience property 
    // so that we can easily intervene
    // when an image is set in our imageView
    // whenever the image is set in our imageView
    // we add a constraint that the imageView
    // must maintain the aspect ratio of its image
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            if let contrainedView = imageView {
                if let newImage = newValue {
                    aspectRatioConstraint = NSLayoutConstraint(
                        item: contrainedView,
                        attribute: .Width,
                        relatedBy: .Equal,
                        toItem: contrainedView,
                        attribute: .Height,
                        multiplier: newImage.aspectRatio,
                        constant: 0)
                }
            } else {
                aspectRatioConstraint = nil
            }
        }
    }
    
    // the imageView aspect ratio constraint
    // when it is set here
    // we'll remove any existing aspect ratio constraint
    // and then add the new one to our view
    private var aspectRatioConstraint: NSLayoutConstraint? {
        willSet {
            if let existingContraint = aspectRatioConstraint {
                view.removeConstraint(existingContraint)
            }
        }
        didSet {
            if let newcontraint = aspectRatioConstraint {
                view.addConstraint(newcontraint)
            }
        }
    }
}

// User is our Model
// so it can't itself have anything UI-related
// but we can add a UI-specific property
// just for us to use
// because we are the Controller
// note this extension is private
extension User {
    var image: UIImage? {
        if let image = UIImage(named: login) {
            return image
        } else {
            return UIImage(named: "unknown_user")
        }
    }
}

// wouldn't it be convenient
// to have an aspectRatio property in UIImage?
// yes, it would, so let's add one!
// why is this not already in UIImage?
// probably because the semantic of returning zero
//      if the height is zero is not perfect
//      (nil might be better, but annoying)
extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}
