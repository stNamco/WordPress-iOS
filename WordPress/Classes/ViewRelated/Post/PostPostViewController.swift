//
//  PostPostViewController.swift
//  WordPress
//
//  Created by Nate Heagy on 2016-11-02.
//  Copyright © 2016 WordPress. All rights reserved.
//

import UIKit
import WordPressShared

class PostPostViewController: UIViewController {

    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var siteIconView:UIImageView!
    @IBOutlet var siteNameLabel:UILabel!
    @IBOutlet var siteUrlLabel:UILabel!
    @IBOutlet var shareButton:UIButton!
    @IBOutlet var navBar:UINavigationBar!
    @IBOutlet var actionsStackView:UIStackView!
    var post:Post?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupPost()

        navBar.barTintColor = WPStyleGuide.wordPressBlue()
        self.view.backgroundColor = WPStyleGuide.wordPressBlue()
        navBar.tintColor = UIColor.whiteColor()
        let clearImage = UIImage(color: UIColor.clearColor(), havingSize: CGSizeMake(320, 4))
        navBar.shadowImage = clearImage
        navBar.setBackgroundImage(clearImage, forBarMetrics: .Default)

        self.view.alpha = 0
        self.actionsStackView.alpha = 0
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.actionsStackView.layer.transform = CATransform3DMakeTranslation(0, 100, 0)
        self.actionsStackView.alpha = 1

        UIView.animateWithDuration(0.66, delay:0, options:UIViewAnimationOptions.CurveEaseIn, animations: {
            self.view.alpha = 1
            self.actionsStackView.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
            }, completion: { (success) in

        })
    }

    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    func setupPost() {
        guard let post = post, let blogSettings = post.blog.settings else {
            return
        }

        titleLabel.text = post.titleForDisplay()
        siteNameLabel.text = blogSettings.name
        siteUrlLabel.text = post.blog.url
        if let icon = post.blog.icon {
            siteIconView.setImageWithSiteIcon(icon)
        } else {
            siteIconView.superview?.hidden = true
        }
        let isPrivate = !post.blog.visible
        if isPrivate {
            shareButton.hidden = true
        }
    }

    @IBAction func shareTapped() {
        guard let post = post else {
            return
        }

        let sharingController = PostSharingController()
        sharingController.sharePost(post, fromView: self.shareButton, inViewController: self)
    }

    @IBAction func editTapped() {
    }

    @IBAction func viewTapped() {
    }

    @IBAction func doneTapped() {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? WordPressAppDelegate else {
            return
        }

        UIView.animateWithDuration(0.66, animations: {
                self.view.alpha = 0.0
            }) { (success) in
                if self.view.window == appDelegate.testExtraWindow {
                    appDelegate.testExtraWindow.hidden = true
                    appDelegate.testExtraWindow = nil
                }
        }


    }

}
