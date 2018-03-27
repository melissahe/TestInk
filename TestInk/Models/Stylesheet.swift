//
//  StyleSheet.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import UIKit

enum Stylesheet {
    
    enum Colors {
        static let Lapislazuli = UIColor(hex: "#247BA0")
        static let WhiteSmoke = UIColor(hex: "#F3F9F6")
        static let Mandarin = UIColor(hex: "#EB783F")
        static let Gainsboro = UIColor(hex: "#DBDBDB")
        static let MediumSkyBlue = UIColor(hex: "#65DEF1")
        static let White = UIColor.white
    }
    
    enum Fonts {
        static let AppName = UIFont(name: "HelveticaNeue-CondensedBold", size: 45.0)
        //static let PostTitle = UIFont(name: "HelveticaNeue-CondensedBold", size: 30.0)
        static let Regular = UIFont(name: "HelveticaNeue-Light", size: 15.0)
        static let TextfieldFont = UIFont(name: "HelveticaNeue-Light", size: 15.0)
        static let Link = UIFont(name: "HelveticaNeue", size: 15.0)
        static let Bold = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
    }
    enum BorderWidths {
        
        static let PostImages = 0.5
        static let UserImages = 0.5
        static let FunctionButtons = 0.5
        static let Buttons = 1
    }
    
    enum ConstraintSizes {
        static let ButtonWidthMult = 0.6
        static let ButtonHeightMult = 0.04
       
    }
    
    enum Buttons {
        case Login
        case Link
        case CreateButton
        case ClearButton
        
        func style(button: UIButton) {
            switch self {
            case .Login:
                button.setTitleColor(Stylesheet.Colors.MediumSkyBlue, for: .normal)
                button.titleLabel?.font = Stylesheet.Fonts.Bold
                button.backgroundColor = Stylesheet.Colors.Lapislazuli
                button.layer.borderColor = (Stylesheet.Colors.Mandarin).cgColor
                button.layer.borderWidth = CGFloat(Stylesheet.BorderWidths.Buttons)
                button.showsTouchWhenHighlighted = true
            case .Link:
                button.setTitleColor(Stylesheet.Colors.WhiteSmoke, for: .normal)
                button.titleLabel?.font = Stylesheet.Fonts.Link
                button.backgroundColor = .clear
                button.showsTouchWhenHighlighted = true
            case .CreateButton:
                button.setTitleColor(Stylesheet.Colors.Mandarin, for: .normal)
                button.titleLabel?.font = Stylesheet.Fonts.Bold
                button.backgroundColor = Stylesheet.Colors.MediumSkyBlue
                button.layer.borderColor = (Stylesheet.Colors.Mandarin).cgColor
                button.layer.borderWidth = CGFloat(Stylesheet.BorderWidths.Buttons)
                button.showsTouchWhenHighlighted = true
            case .ClearButton:
                button.backgroundColor = .clear
                button.contentMode = .scaleAspectFit
                button.tintColor = Stylesheet.Colors.Mandarin
            }
        }
    }
    enum Contexts {
        enum Global {
            static let BackgroundColor = Colors.White
        }
        
        enum NavigationController {
            static let BarTintColor = Colors.White
            static let BarTextColor = Colors.White
            static let BarColor = Colors.Lapislazuli
        }
        
        enum TabBarController {
            //default color of the icons on the buttons
        }
        
    }
    
}

extension UIColor {
    
    
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


