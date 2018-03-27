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
        static let LightGrey = UIColor(hex: "#d3d3d3")
        static let DarkSlateGray = UIColor(hex: "#2F4858")
        static let LightBlue = UIColor(hex: "#A8DCE5")
        static let White = UIColor.white
        
    }
    
    
    
    enum Fonts {
        static let AppName = UIFont(name: "HelveticaNeue-CondensedBold", size: 45.0)
        static let Title = UIFont(name: "HelveticaNeue-CondensedBold", size: 30.0)
        static let Regular = UIFont(name: "HelveticaNeue-Light", size: 15.0)
        static let TextfieldFont = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        static let Link = UIFont(name: "HelveticaNeue", size: 15.0)
        static let Bold = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
    }
    
    
    enum BorderWidths {
        static let Textviews = 0.5
        static let TextfieldEditable = 1
        static let TextfieldCompleted = 0
        static let PostImages = 0.5
        static let UserImages = 0.5
        static let FunctionButtons = 0.5
        static let Buttons = 1
    }
    
    enum ConstraintSizes {
        static let ButtonWidthMult = 0.4
        static let ButtonHeightMult = 0.04
        static let TextfieldWidthMult = 0.6
        static let TextfieldHeight = 40
        
    }
    
    enum Contexts {
        enum Global {
            static let BackgroundColor = Colors.White
        }
        
        enum NavigationController {
            static let BarTintColor = Colors.White
            static let BarTextColor = Colors.Lapislazuli
            static let BarColor = Colors.LightGrey
        }
        
        enum TabBarController {
            //default color of the icons on the buttons
        }
        
    }
    
    // Custom underline
    enum View {
        case userName
        
        func style(view: UIView, text: UITextField) {
            switch self {
            case .userName:
                view.backgroundColor = UIColor(displayP3Red: (229/255), green: (229/255), blue: (229/255), alpha: 1.0)
                view.translatesAutoresizingMaskIntoConstraints = false
                //txt.addSubview(border)
                view.heightAnchor.constraint(equalToConstant: 1).isActive = true
                view.widthAnchor.constraint(equalTo: text.widthAnchor).isActive = true
                view.bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: -1).isActive = true
                view.leftAnchor.constraint(equalTo: text.leftAnchor).isActive = true
            }
        }
    }
}

extension Stylesheet {
    
    enum Objects {
        
        enum ImageViews {
            case Clear
            case Opaque
            
            func style(imageView: UIImageView) {
                switch self {
                case .Clear:
                    imageView.backgroundColor = .clear
                    imageView.contentMode = .scaleAspectFit
                    imageView.layer.borderWidth = CGFloat(Stylesheet.BorderWidths.FunctionButtons)
                    imageView.layer.borderColor = (Stylesheet.Colors.Mandarin).cgColor
                case .Opaque:
                    imageView.backgroundColor = .white
                    imageView.contentMode = .scaleAspectFill
                    imageView.layer.borderWidth = CGFloat(Stylesheet.BorderWidths.FunctionButtons)
                    imageView.layer.borderColor = (Stylesheet.Colors.LightGrey).cgColor
                }
            }
        }
        
        
        enum Buttons {
            case Login
            case ForgotPassword
            case SignUpButton
            case CreateButton
            case ClearButton
            case ResetButton
            
            func style(button: UIButton) {
                switch self {
                case .Login:
                    button.setTitleColor(Stylesheet.Colors.LightGrey, for: .normal)
                    button.titleLabel?.font = Stylesheet.Fonts.Bold
                    button.backgroundColor = Stylesheet.Colors.Mandarin
                    button.layer.borderColor = (Stylesheet.Colors.LightGrey).cgColor
                    button.layer.borderWidth = CGFloat(Stylesheet.BorderWidths.Buttons)
                    button.showsTouchWhenHighlighted = true
                case .ForgotPassword:
                    button.setTitleColor(Stylesheet.Colors.Mandarin, for: .normal)
                    button.titleLabel?.font = Stylesheet.Fonts.Link
                    button.backgroundColor = .clear
                    button.showsTouchWhenHighlighted = true
                case .SignUpButton:
                    button.setTitleColor(Stylesheet.Colors.Mandarin, for: .normal)
                    button.titleLabel?.font = Stylesheet.Fonts.Bold
                    button.backgroundColor = .clear
                    button.showsTouchWhenHighlighted = true
                case .CreateButton:
                    button.setTitleColor(Stylesheet.Colors.LightGrey, for: .normal)
                    button.titleLabel?.font = Stylesheet.Fonts.Bold
                    button.backgroundColor = Stylesheet.Colors.Mandarin
                    button.layer.borderColor = (Stylesheet.Colors.LightGrey).cgColor
                    button.layer.borderWidth = CGFloat(Stylesheet.BorderWidths.Buttons)
                    button.showsTouchWhenHighlighted = true
                case .ClearButton:
                    button.backgroundColor = .clear
                    button.contentMode = .scaleAspectFit
                    button.tintColor = Stylesheet.Colors.Mandarin
                case .ResetButton:
                    button.setTitleColor(Stylesheet.Colors.LightGrey, for: .normal)
                    button.titleLabel?.font = Stylesheet.Fonts.Bold
                    button.backgroundColor = Stylesheet.Colors.Mandarin
                    button.layer.borderColor = (Stylesheet.Colors.LightGrey).cgColor
                    button.layer.borderWidth = CGFloat(Stylesheet.BorderWidths.Buttons)
                    button.showsTouchWhenHighlighted = true
                }
            }
        }
        
        enum Labels {
            case Title
            case Regular
            case AppName
            case PostUsername
            
            func style(label: UILabel) {
                switch self {
                case .Title:
                    label.font = Stylesheet.Fonts.Title
                    label.textColor = Stylesheet.Colors.DarkSlateGray
                    label.backgroundColor = .clear
                    label.textAlignment = .left
                    label.numberOfLines = 0
                case .Regular:
                    label.font = Stylesheet.Fonts.Regular
                    label.textColor = Stylesheet.Colors.DarkSlateGray
                    label.backgroundColor = .clear
                    label.textAlignment = .left
                    label.numberOfLines = 0
                case .AppName:
                    label.font = Stylesheet.Fonts.AppName
                    label.textColor = Stylesheet.Colors.LightGrey
                    label.backgroundColor = .clear
                    label.textAlignment = .center
                    label.numberOfLines = 0
                case .PostUsername:
                    label.font = Stylesheet.Fonts.Bold
                    label.textColor = Stylesheet.Colors.LightGrey
                    label.backgroundColor = .clear
                    label.backgroundColor = .white
                    label.textAlignment = .left
                    label.numberOfLines = 1
                }
            }
        }
        
        enum Textviews {
            case Completed
            case Editable
            
            func style(textview: UITextView) {
                switch self {
                case .Completed:
                    textview.layer.borderWidth = CGFloat(Stylesheet.BorderWidths.TextfieldCompleted)
                    textview.layer.borderColor = (Stylesheet.Colors.LightGrey).cgColor
                    textview.backgroundColor = Stylesheet.Colors.White
                    textview.textAlignment = .natural
                    textview.isEditable = false
                    textview.textColor = Stylesheet.Colors.LightGrey
                    textview.font = Stylesheet.Fonts.Regular
                    textview.adjustsFontForContentSizeCategory = true
                    textview.isScrollEnabled = false
                case .Editable:
                    textview.layer.borderWidth = CGFloat(Stylesheet.BorderWidths.TextfieldEditable)
                    textview.layer.borderColor = (Stylesheet.Colors.LightGrey).cgColor
                    textview.backgroundColor = Stylesheet.Colors.White
                    textview.textAlignment = .natural
                    textview.isEditable = true
                    textview.textColor = Stylesheet.Colors.LightGrey
                    textview.font = Stylesheet.Fonts.Regular
                    textview.adjustsFontForContentSizeCategory = true
                    textview.isScrollEnabled = true
                }
            }
        }
        
        enum Textfields {
            case UserName
            case LoginEmail
            case LoginPassword
            
            func style(textfield: UITextField) {
                switch self {
                    
                case .UserName:
                    let border = UIView()
                    border.backgroundColor = UIColor(displayP3Red: (229/255), green: (229/255), blue: (229/255), alpha: 1.0)
                    border.translatesAutoresizingMaskIntoConstraints = false
                    textfield.addSubview(border)
                    border.heightAnchor.constraint(equalToConstant: 1).isActive = true
                    border.widthAnchor.constraint(equalTo: textfield.widthAnchor).isActive = true
                    border.bottomAnchor.constraint(equalTo: textfield.bottomAnchor, constant: -1).isActive = true
                    border.leftAnchor.constraint(equalTo: textfield.leftAnchor).isActive = true
                    
                    textfield.borderStyle = .none
                    textfield.layer.borderColor = (Stylesheet.Colors.LightGrey).cgColor
                    textfield.textAlignment = NSTextAlignment.left
                    textfield.font = Stylesheet.Fonts.TextfieldFont
                    textfield.textColor = Stylesheet.Colors.White
                    textfield.adjustsFontSizeToFitWidth = true
                    textfield.autocapitalizationType = .words
                    textfield.autocorrectionType = .no
                    textfield.keyboardType = .asciiCapable
                    textfield.returnKeyType = .default
                    textfield.placeholder = "User Name"
                    
                case .LoginEmail:
                    let border = UIView()
                    border.backgroundColor = UIColor(displayP3Red: (229/255), green: (229/255), blue: (229/255), alpha: 1.0)
                    border.translatesAutoresizingMaskIntoConstraints = false
                    textfield.addSubview(border)
                    border.heightAnchor.constraint(equalToConstant: 1).isActive = true
                    border.widthAnchor.constraint(equalTo: textfield.widthAnchor).isActive = true
                    border.bottomAnchor.constraint(equalTo: textfield.bottomAnchor, constant: -1).isActive = true
                    border.leftAnchor.constraint(equalTo: textfield.leftAnchor).isActive = true
                    
                    textfield.borderStyle = .none
                    textfield.layer.borderColor = (Stylesheet.Colors.LightGrey).cgColor
                    textfield.textAlignment = NSTextAlignment.left
                    textfield.font = Stylesheet.Fonts.TextfieldFont
                    textfield.textColor = Stylesheet.Colors.White
                    textfield.adjustsFontSizeToFitWidth = true
                    textfield.autocapitalizationType = .none
                    textfield.autocorrectionType = .no
                    textfield.keyboardType = .emailAddress
                    textfield.returnKeyType = .default
                    textfield.placeholder = "Enter email"
                    
                case .LoginPassword:
                    
                    
                    textfield.borderStyle = .none
                    textfield.layer.borderColor = (Stylesheet.Colors.LightGrey).cgColor
                    textfield.textAlignment = NSTextAlignment.left
                    textfield.font = Stylesheet.Fonts.TextfieldFont
                    textfield.textColor = Stylesheet.Colors.LightGrey
                    textfield.adjustsFontSizeToFitWidth = true
                    textfield.autocapitalizationType = .none
                    textfield.autocorrectionType = .no
                    textfield.keyboardType = .asciiCapable
                    textfield.returnKeyType = .default
                    textfield.placeholder = "Password"
                    textfield.isSecureTextEntry = true
                    let border = UIView()
                    border.backgroundColor = UIColor(displayP3Red: (229/255), green: (229/255), blue: (229/255), alpha: 1.0)
                    border.translatesAutoresizingMaskIntoConstraints = false
                    textfield.addSubview(border)
                    border.heightAnchor.constraint(equalToConstant: 1).isActive = true
                    border.widthAnchor.constraint(equalTo: textfield.widthAnchor).isActive = true
                    border.bottomAnchor.constraint(equalTo: textfield.bottomAnchor, constant: -1).isActive = true
                    border.leftAnchor.constraint(equalTo: textfield.leftAnchor).isActive = true
                }
            }
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

