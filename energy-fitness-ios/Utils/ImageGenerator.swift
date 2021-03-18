//
//  ProfileImageGenerator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 07/03/2021.
//

import UIKit

class ImageGenerator {
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    func generateProfileImage(initials: String) -> UIImage {
        let label = UILabel()
        label.frame.size = CGSize(width: 100.0, height: 100.0)
        label.textColor = UIColor.white
        label.text = initials
        label.font = .systemFont(ofSize: 50)
        label.textAlignment = .center
        label.backgroundColor = .energyOrange //NiceRandomColour().generate()
        label.layer.cornerRadius = 50.0

        UIGraphicsBeginImageContext(label.frame.size)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }

//    func generateGymClassImage(for name: String) -> UIImage {
//        let view = UIView()
//        let image = UIImage(named: "energy-logo-transparent")
//
//
//
//        let label = UILabel()
//        label.frame.size = CGSize(width: 100.0, height: 100.0)
//        label.textColor = UIColor.white
//        label.text = initials
//        label.font = .systemFont(ofSize: 50)
//        label.textAlignment = .center
//        label.backgroundColor = .black
//        label.layer.cornerRadius = 50.0
//
//        UIGraphicsBeginImageContext(label.frame.size)
//        label.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return image!
//    }
}
