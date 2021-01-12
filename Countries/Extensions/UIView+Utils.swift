//
//  UIView+Utils.swift
//  Countries
//
//  Created by Sachendra Singh on 11/01/21.
//

import UIKit

public enum LoadingViewPosition
{
    case center
    case bottom
    case overlay
}

extension UIView
{
    @discardableResult
    func addWhiteOverlay() -> UIView
    {
        let overLay = WhiteOverlayView(withTransparency: 0.4)
        overLay.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(overLay)
        positionView(view: overLay, asPerPosition: .overlay)
        
        return overLay
    }
    
    func removeWhiteOverlay()
    {
        self.subviews.filter { $0 is WhiteOverlayView }
            .forEach({ $0.removeFromSuperview() })
    }
    
    @discardableResult
    func showBlackTranslucentOverlay(position:LoadingViewPosition = .overlay) -> UIView
    {
        let overLay = BlackTranslucentView(withTransparency: 0.4)
        overLay.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(overLay)
        positionView(view: overLay, asPerPosition: .overlay)
        
        return overLay
    }
    
    func removeBlackTranslucentOverlay()
    {
        self.subviews.filter { $0 is BlackTranslucentView }
        .forEach({ $0.removeFromSuperview() })
    }
    
    @discardableResult
    func showLoadingIndicator(position:LoadingViewPosition = .center) -> UIView
    {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        self.addSubview(indicator)
        positionView(view: indicator, asPerPosition: position)
        
        indicator.startAnimating()
        
        return indicator
    }
    
    func hideLoadingIndicator()
    {
        self.subviews.filter { $0 is UIActivityIndicatorView }
        .forEach({ $0.removeFromSuperview() })
    }
       
    func positionView(view:UIView, asPerPosition position:LoadingViewPosition)
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch position {
        case .center:
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        case .bottom:
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
            view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        case .overlay:
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }
    
}


class WhiteOverlayView:UIView {
    convenience init(withTransparency transparency:CGFloat = 0.4) {
        self.init()
        self.backgroundColor = UIColor.white.withAlphaComponent(0.4)
    }
}
class BlackTranslucentView:UIView {
    convenience init(withTransparency transparency:CGFloat = 0.4) {
        self.init()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
}
