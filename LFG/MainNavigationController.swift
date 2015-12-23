//
//  MainNavigationController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-22.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit
import MessageUI

class MainNavigationController: UINavigationController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func togglePanel() {
        if let containerVC = self.parentViewController as? ContainerViewController {
            containerVC.togglePanel()
        }
    }
    
    func showViewForPanelOption(option: PanelOption) {
        switch(option) {
            case .Games:
                self.popViewControllerAnimated(true)
            case .Feedback:
                self.presentFeedbackView()
            case .Donate:
                self.pushDonateView()
            case .Help:
                self.pushHelpView()
        }
    }
    
    // MARK: UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        var panelEnabled = false
        
        if viewController is PostsViewController {
            panelEnabled = true
        }
        
        if let containerVC = self.parentViewController as? ContainerViewController {
            containerVC.panelEnabled = panelEnabled
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch(result.rawValue) {
            case MFMailComposeResultCancelled.rawValue:
                print("Mail canelled")
            case MFMailComposeResultSent.rawValue:
                print("Mail sent")
            default:
                break
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Helper Methods
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["LFGFeedback@gmail.com"])
        mailComposerVC.setSubject("App Feedback")
        mailComposerVC.setMessageBody("Hey! I'd like to share the following feedback: \n", isHTML: false)
        
        return mailComposerVC
    }
    
    func presentFeedbackView() {
        
        let mailComposeViewController = configuredMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    func pushDonateView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let helpVC = storyboard.instantiateViewControllerWithIdentifier("DonateViewController")
        self.pushViewController(helpVC, animated: true)
    }
    
    func pushHelpView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let helpVC = storyboard.instantiateViewControllerWithIdentifier("HelpViewController")
        self.pushViewController(helpVC, animated: true)
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device is not able to send email.  Please check e-mail configuration in the iOS Mailing app. and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
}
