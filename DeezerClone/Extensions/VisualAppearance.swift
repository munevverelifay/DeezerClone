//
//  VisualAppearance.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 13.05.2023.
//

import UIKit

extension UIViewController{
    func configurebackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds

        let startColor = UIColor(red: 237/255, green: 221/255, blue: 244/255, alpha: 1).cgColor
        let middleColor = UIColor(red: 229/255, green: 204/255, blue: 254/255, alpha: 1).cgColor
        let endColor = UIColor(red: 67/255, green: 72/255, blue: 240/255, alpha: 1).cgColor

        gradientLayer.colors = [startColor, middleColor, endColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func configureNavigation() {
        navigationController?.navigationBar.tintColor = UIColor(red: 249/255, green: 36/255, blue: 87/255, alpha: 1.0)
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 249/255, green: 36/255, blue: 87/255, alpha: 1.0)]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
    }
    

}
