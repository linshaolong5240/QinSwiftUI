//
//  NeuCircleButtonView.swift
//  Qin
//
//  Created by 林少龙 on 2020/4/28.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct NEUCircleButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let systemName: String
    let size: ButtonSize
    let active: Bool
    
    var body: some View {
        VStack {
            if colorScheme == .light {
                Image(systemName: systemName)
                    .font(.system(size: size.fontSize, weight: .bold))
                    .frame(width: size.width, height: size.height)
                    .foregroundColor(active ? .white : Color.mainTextColor)
                    .background(
                        VStack {
                            if active {
                                ZStack {
                                    if size != .small {
                                        Circle()
                                        .shadow(color: Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1)), radius: 10, x: -10, y: -10)
                                        .shadow(color: Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1)), radius: 5, x: 3, y: 3)
                                    }
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9194737077, green: 0.2849465311, blue: 0.1981146634, alpha: 1)),Color(#colorLiteral(red: 0.9983269572, green: 0.3682751656, blue: 0.2816230953, alpha: 1)),Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .clipShape(Circle())
                                }
                            }else {
                                ZStack {
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),Color("BGC3")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                        .clipShape(Circle())
                                        .padding(.all, size.width / 20)
                                }
                                .clipShape(Circle())
//                                .blur(radius: 0.25)
                                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 5, x: -5, y: -5)
                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.2), radius: 10, x: 10, y: 10)
                            }
                        }
                )
            }else {
                Image(systemName: systemName)
                    .font(.system(size: size.fontSize, weight: .bold))
                    .frame(width: size.width, height: size.height)
                    .foregroundColor(active ? .white : Color.secondTextColor)
                    .background(
                        VStack {
                            if active {
                                ZStack {
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7242732644, green: 0.1235787049, blue: 0.06050202996, alpha: 1)),Color(#colorLiteral(red: 0.9250395894, green: 0.2772472203, blue: 0.07692974061, alpha: 1)),Color(#colorLiteral(red: 0.8801239729, green: 0.3246800303, blue: 0.03817423061, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .clipShape(Circle())
                                    Circle().stroke(Color(#colorLiteral(red: 0.925039351, green: 0.2816193104, blue: 0.0769296065, alpha: 1)), lineWidth: size.width / 20)
                                        .blur(radius: 1)
                                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.3), radius: 6, x: 6, y: 6)
                                }
                            }else {
                                ZStack {
                                    LinearGradient(gradient: Gradient(colors: [Color("backgroundColor"),Color("BGC2"),Color("BGC3")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                        .clipShape(Circle())
                                        .padding(.all, size.width / 20)
                                        .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).opacity(0.1),
                                                radius: 10,
                                                x: 5,
                                                y: 5)
                                        .shadow(color:  Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.5),
                                                radius: 10,
                                                x: -5,
                                                y: -5)
                                }
                            }
                        }
                        .clipShape(Circle())
                        .shadow(color: Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).opacity(0.15), radius: 10, x: -10, y: -10)
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.5), radius: 10, x: 10, y: 10)
                )
            }
        }
    }
}

extension NEUCircleButtonView {
    enum ButtonSize {
        case small
        case medium
        case big
        case large
        
        var width: CGFloat {
            switch self {
            case .small:
                return 40
            case .medium:
                return 50
            case .big:
                return 80
            case .large:
                return 90
            }
        }
        var height: CGFloat {
            switch self {
            case .small:
                return 40
            case .medium:
                return 50
            case .big:
                return 80
            case .large:
                return 90
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small:
                return 10
            case .medium:
                return 15
            case .big:
                return 20
            case .large:
                return 25
            }
        }
        //        var innerShadowOffset: CGFloat {
        //            switch self {
        //            case .small:
        //                return 10
        //            case .medium:
        //                return 10
        //            case .large:
        //                return 10
        //            }
        //        }
    }
}

struct NeuCircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 20.0) {
                NEUCircleButtonView(systemName: "arrow.left", size: .small, active: true)
                NEUCircleButtonView(systemName: "arrow.left", size: .medium, active: true)
                NEUCircleButtonView(systemName: "arrow.left", size: .big, active: true)
                NEUCircleButtonView(systemName: "arrow.left", size: .large, active: true)
            }
        }
        .environment(\.colorScheme, .light)
    }
}
