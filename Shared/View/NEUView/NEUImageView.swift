//
//  NEUImageView.swift
//  Qin
//
//  Created by 林少龙 on 2020/4/28.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

enum NEUImageSize {
    case small
    case medium
    case large
    
    var width: CGFloat {
        switch self {
        case .small:
            return screen.width * 0.15
        case .medium:
            return screen.width * 0.3
        case .large:
            return screen.width * 0.7
        }
    }
}

struct NEUImageView<S: Shape>: View {
    @Environment(\.colorScheme) var colorScheme

    let url: String
    let size: NEUImageSize
    let innerShape: S
    let outerShape: S
    let innerPadding: CGFloat
    let shadowReverse: Bool
    let isOrigin: Bool
    
    init(url: String,
         size: NEUImageSize = .medium,
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
            NEULightImageView(url: url,
                              size: size,
                              innerShape: innerShape,
                              outerShape: outerShape,
                              innerPadding: innerPadding,
                              shadowReverse: shadowReverse,
                              isOrigin: isOrigin)
        }else {
            NEUDarkImageView(url: url,
                             size: size,
                             innerShape: innerShape,
                             outerShape: outerShape,
                             innerPadding: innerPadding,
                             shadowReverse: shadowReverse,
                             isOrigin: isOrigin)
        }
    }
}

struct NEULightImageView<S: Shape>: View {
    let url: String
    let size: NEUImageSize
    let innerShape: S
    let outerShape: S
    let innerPadding: CGFloat
    let shadowReverse: Bool
    let isOrigin: Bool
    
    init(url: String,
         size: NEUImageSize = .medium,
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
            Image("DefaultCover")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width - innerPadding * 2,
                       height: size.width - innerPadding * 2)
                .clipShape(innerShape)
            if isOrigin {
                KFImage(URL(string: url))
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - innerPadding * 2,
                           height: size.width - innerPadding * 2)
                    .clipShape(innerShape)
            }else {
                KFImage(URL(string: url), options: [.processor(DownsamplingImageProcessor(size: CGSize(width: size.width + 100, height: size.width + 100)))])
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

struct NEUDarkImageView<S: Shape>: View {
    let url: String
    let size: NEUImageSize
    let innerShape: S
    let outerShape: S
    let innerPadding: CGFloat
    let shadowReverse: Bool
    let isOrigin: Bool
    
    init(url: String,
         size: NEUImageSize = .medium,
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
                    LinearGradient(.darkBackgourdMiddle, .black)
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
            .shadow(color: Color.white.opacity(0.1),
                    radius: 10,
                    x: -innerPadding,
                    y: -innerPadding)
            .shadow(color: Color.black.opacity(0.5),
                    radius: 10,
                    x: innerPadding,
                    y: innerPadding)
            Image("DefaultCover")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width - innerPadding * 2,
                       height: size.width - innerPadding * 2)
                .clipShape(innerShape)
            if isOrigin {
                KFImage(URL(string: url))
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - innerPadding * 2,
                           height: size.width - innerPadding * 2)
                    .clipShape(innerShape)
            }else {
                KFImage(URL(string: url), options: [.processor(DownsamplingImageProcessor(size: CGSize(width: size.width + 100, height: size.width + 100)))])
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
#if DEBUG
struct NEUImageView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            VStack(spacing: 50) {
                NEUCoverView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
                             coverShape: .rectangle,
                             size: .small)
                NEUCoverView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
                             coverShape: .rectangle,
                             size: .medium)
                NEUCoverView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
                             coverShape: .rectangle,
                             size: .large)
                
            }
        }
        .environment(\.colorScheme, .dark)
        ZStack {
            NEUBackgroundView()
            VStack(spacing: 50) {
                NEUCoverView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
                             coverShape: .circle,
                             size: .small)
                NEUCoverView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
                             coverShape: .circle,
                             size: .medium)
                NEUCoverView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
                             coverShape: .circle,
                             size: .large)

            }
        }
        .environment(\.colorScheme, .dark)
    }
}
#endif
