//
//  QinImageView.swift
//  Qin
//
//  Created by 林少龙 on 2020/4/28.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI
import Kingfisher
import struct Kingfisher.DownsamplingImageProcessor

enum QinImageSize {
    case little
    case small
    case medium
    case large
    
    var width: CGFloat {
        switch self {
        case .little:
            return 60
        case .small:
            return 110
        case .medium:
            return 130
        case .large:
            return 300
        }
    }
}

struct QinImageView<S: Shape>: View {
    
    @Environment(\.colorScheme) private var colorScheme

    let url: String?
    let size: QinImageSize
    let innerShape: S
    let outerShape: S
    let innerPadding: CGFloat
    let shadowReverse: Bool
    let isOrigin: Bool
    
    init(url: String?,
         size: QinImageSize = .medium,
         innerShape: S,
         outerShape: S,
         innerPadding: CGFloat,
         shadowReverse: Bool = false,
         isOrigin: Bool = false) {
        self.url = url
        self.size = size
        self.innerShape = innerShape
        self.outerShape = outerShape
        self.innerPadding = innerPadding
        self.shadowReverse = shadowReverse
        self.isOrigin = isOrigin
    }
    
    var body: some View {
        if colorScheme == .light {
            QinLightImageView(url: url,
                              size: size,
                              innerShape: innerShape,
                              outerShape: outerShape,
                              innerPadding: innerPadding,
                              shadowReverse: shadowReverse,
                              isOrigin: isOrigin)
        }else {
            QinDarkImageView(url: url,
                             size: size,
                             innerShape: innerShape,
                             outerShape: outerShape,
                             innerPadding: innerPadding,
                             shadowReverse: shadowReverse,
                             isOrigin: isOrigin)
        }
    }
}

struct QinLightImageView<S: Shape>: View {
    let url: String?
    let size: QinImageSize
    let innerShape: S
    let outerShape: S
    let innerPadding: CGFloat
    let shadowReverse: Bool
    let isOrigin: Bool
    
    init(url: String?,
         size: QinImageSize = .medium,
         innerShape: S,
         outerShape: S,
         innerPadding: CGFloat = 10,
         shadowReverse: Bool = false,
         isOrigin: Bool = false) {
        self.url = url
        self.size = size
        self.innerShape = innerShape
        self.outerShape = outerShape
        self.innerPadding = innerPadding
        self.shadowReverse = shadowReverse
        self.isOrigin = isOrigin
    }
    
    var body: some View {
        ZStack {
            ZStack {
                Color.lightBackgourdStart
                    Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
                    .frame(width: size.width - innerPadding * 2,
                           height: size.width - innerPadding * 2)
                    .clipShape(innerShape)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.12),
                            radius: 10,
                            x: -innerPadding,
                            y: -innerPadding)
                    .shadow(color: Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), radius: 10,
                            x: innerPadding,
                            y: innerPadding)
            }
            .frame(width: size.width, height: size.width)
            .clipShape(outerShape)
            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
                    radius: 10,
                    x: -innerPadding,
                    y: -innerPadding)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.1),
                    radius: 10,
                    x: innerPadding,
                    y: innerPadding)
            Image("PlaceholderImage")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width - innerPadding * 2,
                       height: size.width - innerPadding * 2)
                .clipShape(innerShape)
            if let imageUrl = url {
                if isOrigin {
                    KFImage(URL(string: imageUrl))
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width - innerPadding * 2,
                               height: size.width - innerPadding * 2)
                        .clipShape(innerShape)
                }else {
                    KFImage(URL(string: imageUrl))
//                      .placeholder(placeholderImage)
                      .setProcessor(DownsamplingImageProcessor(size: CGSize(width: size.width * 2, height: size.width * 2)))
                      .fade(duration: 0.25)
                      .onProgress { receivedSize, totalSize in  }
                      .onSuccess { result in  }
                      .onFailure { error in }
                      .resizable()
                      .renderingMode(.original)
                      .aspectRatio(contentMode: .fill)
                      .frame(width: size.width - innerPadding * 2,
                             height: size.width - innerPadding * 2)
                      .clipShape(innerShape)
                }
            }
        }
    }
}

struct QinDarkImageView<S: Shape>: View {
    let url: String?
    let size: QinImageSize
    let innerShape: S
    let outerShape: S
    let innerPadding: CGFloat
    let shadowReverse: Bool
    let isOrigin: Bool
    
    init(url: String?,
         size: QinImageSize = .medium,
         innerShape: S,
         outerShape: S,
         innerPadding: CGFloat = 10,
         shadowReverse: Bool = false,
         isOrigin: Bool = false) {
        self.url = url
        self.size = size
        self.innerShape = innerShape
        self.outerShape = outerShape
        self.innerPadding = innerPadding
        self.shadowReverse = shadowReverse
        self.isOrigin = isOrigin
    }
    
    var body: some View {
        ZStack {
            ZStack {
                if shadowReverse {
                    LinearGradient(gradient: Gradient(colors: [.darkBackgourdMiddle, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                    Color.darkBackgourdStart
//                    Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
//                    .frame(width: size.width - innerPadding * 2,
//                           height: size.width - innerPadding * 2)
//                    .clipShape(innerShape)
//                        .shadow(color: .darkBackgourdMiddle,
//                            radius: 10,
//                            x: -innerPadding,
//                            y: -innerPadding)
//                        .shadow(color: .black, radius: 10,
//                            x: innerPadding,
//                            y: innerPadding)
                }else {
                    Color.darkBackgourdStart
                    Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
                        .frame(width: size.width - innerPadding * 2,
                               height: size.width - innerPadding * 2)
                        .clipShape(innerShape)
                        .shadow(color: .darkBackgourdEnd,
                                radius: 10,
                                x: -innerPadding,
                                y: -innerPadding)
                        .shadow(color: .darkBackgourdStart, radius: 10,
                                x: innerPadding,
                                y: innerPadding)
                }
            }
            .frame(width: size.width, height: size.width)
            .clipShape(outerShape)
            .shadow(color: Color.white.opacity(0.05),
                    radius: 10,
                    x: -innerPadding,
                    y: -innerPadding)
            .shadow(color: Color.black.opacity(0.25),
                    radius: 10,
                    x: innerPadding,
                    y: innerPadding)
            Image("PlaceholderImage")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width - innerPadding * 2,
                       height: size.width - innerPadding * 2)
                .clipShape(innerShape)
            if let imageUrl = url {
                if isOrigin {
                    KFImage(URL(string: imageUrl))
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width - innerPadding * 2,
                               height: size.width - innerPadding * 2)
                        .clipShape(innerShape)
                }else {
                    KFImage(URL(string: imageUrl))
//                      .placeholder(placeholderImage)
                      .setProcessor(DownsamplingImageProcessor(size: CGSize(width: size.width * 2, height: size.width * 2)))
                      .fade(duration: 0.25)
                      .onProgress { receivedSize, totalSize in  }
                      .onSuccess { result in  }
                      .onFailure { error in }
                      .resizable()
                      .renderingMode(.original)
                      .aspectRatio(contentMode: .fill)
                      .frame(width: size.width - innerPadding * 2,
                             height: size.width - innerPadding * 2)
                      .clipShape(innerShape)
                }
            }
        }
    }
}
