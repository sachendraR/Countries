//
//  BaseViewController.swift
//  Countries
//
//  Created by Sachendra Singh on 12/01/21.
//

import UIKit

class BaseViewController : UIViewController
{
    /**
     Method allows all its inheritors to be able to show errors consistently. Also, specific handling based on error's nature can easility be scaled from here
     */
    func showError(_ error:Error, onRetry:(()->Void)?)
    {
        error.handle { (msg) in
            let alertController = UIAlertController(title: "Error",
                                                    message: msg,
                                                    preferredStyle: .alert)
            
            let retryAction = UIAlertAction(title: "Retry",
                                            style: .default) { (_) in
                onRetry?()
            }
            
            alertController.addAction(retryAction)
            
            self.present(alertController,
                         animated: true,
                         completion: nil)
        }
    }
}
