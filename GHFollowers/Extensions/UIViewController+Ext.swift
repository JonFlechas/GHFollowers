//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Jonathan Flechas on 7/1/24.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController {
    
    func presentGFAlert(title: String, message: String, buttonTitle: String){

            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            present(alertVC, animated: true)
    }
    
    func presentDefaultAlert(){
            let alertVC = GFAlertVC(title: "Something went wrong", message: "We were unable to complete this task", buttonTitle: "OK  ")
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            present(alertVC, animated: true)
    }
    
    func presentSafariVC(with url: URL){
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }

}
