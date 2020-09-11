//
//  CoverView.swift
//  Qin
//
//  Created by 林少龙 on 2020/4/28.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor
enum ImageSize {
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
    var innerPadding: CGFloat {
        switch self {
        case .large:
            return self.width / 16
        default:
            return self.width / 12
        }
    }
    var shadowRadius: CGFloat { self.width / 24 }
}

struct NEUImageView<S: Shape>: View {
    @Environment(\.colorScheme) var colorScheme

    let url: String
    let size: ImageSize
    let innerShape: S
    let outerShape: S
    let isOrigin: Bool
    
    init(url: String, size: ImageSize = .medium, innerShape: S, outerShape: S, isOrigin: Bool = false) {
        self.url = url
        self.size = size
        self.innerShape = innerShape
        self.outerShape = outerShape
        self.isOrigin = isOrigin
    }
    var body: some View {
        if colorScheme == .light {
            NEULightImageView(url: url, size: size, innerShape: innerShape, outerShape: outerShape, isOrigin: isOrigin)
        }else {
            NEUDarkImageView(url: url, size: size, innerShape: innerShape, outerShape: outerShape, isOrigin: isOrigin)
        }
    }
}

struct NEULightImageView<S: Shape>: View {
    let url: String
    let size: ImageSize
    let innerShape: S
    let outerShape: S
    let isOrigin: Bool
    
    init(url: String, size: ImageSize = .medium, innerShape: S, outerShape: S, isOrigin: Bool = false) {
        self.url = url
        self.size = size
        self.innerShape = innerShape
        self.outerShape = outerShape
        self.isOrigin = isOrigin
    }
    var body: some View {
        ZStack {
            ZStack {
                Color.lightBackgourdStart
//                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9194737077, green: 0.2849465311, blue: 0.1981146634, alpha: 1)),Color(#colorLiteral(red: 0.9983269572, green: 0.3682751656, blue: 0.2816230953, alpha: 1)),Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
                    .frame(width: size.width - size.innerPadding * 2,
                           height: size.width - size.innerPadding * 2)
                    .clipShape(innerShape)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.12),
                            radius: 10,
                            x: -size.innerPadding,
                            y: -size.innerPadding)
                    .shadow(color: Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), radius: 10,
                            x: size.innerPadding,
                            y: size.innerPadding)
            }
            .frame(width: size.width, height: size.width)
            .clipShape(outerShape)
            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
                    radius: 10,
                    x: -size.innerPadding,
                    y: -size.innerPadding)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.1),
                    radius: 10,
                    x: size.innerPadding,
                y: size.innerPadding)
            Image("DefaultCover")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width - size.innerPadding * 2,
                       height: size.width - size.innerPadding * 2)
                .clipShape(innerShape)
            if isOrigin {
                KFImage(URL(string: url))
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - size.innerPadding * 2,
                           height: size.width - size.innerPadding * 2)
                    .clipShape(innerShape)
            }else {
                KFImage(URL(string: url), options: [.processor(DownsamplingImageProcessor(size: CGSize(width: size.width + 100, height: size.width + 100)))])
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - size.innerPadding * 2,
                           height: size.width - size.innerPadding * 2)
                    .clipShape(innerShape)
            }

        }
    }
}

struct NEUDarkImageView<S: Shape>: View {
    let url: String
    let size: ImageSize
    let innerShape: S
    let outerShape: S
    let isOrigin: Bool
    
    init(url: String, size: ImageSize = .medium, innerShape: S, outerShape: S, isOrigin: Bool = false) {
        self.url = url
        self.size = size
        self.innerShape = innerShape
        self.outerShape = outerShape
        self.isOrigin = isOrigin
    }
    var body: some View {
        ZStack {
            ZStack {
                Color.darkBackgourdStart
//                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9194737077, green: 0.2849465311, blue: 0.1981146634, alpha: 1)),Color(#colorLiteral(red: 0.9983269572, green: 0.3682751656, blue: 0.2816230953, alpha: 1)),Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
                    .frame(width: size.width - size.innerPadding * 2,
                           height: size.width - size.innerPadding * 2)
                    .clipShape(innerShape)
                        .shadow(color: .darkBackgourdEnd,
                            radius: 10,
                            x: -size.innerPadding,
                            y: -size.innerPadding)
                        .shadow(color: .darkBackgourdStart, radius: 10,
                            x: size.innerPadding,
                            y: size.innerPadding)
            }
            .frame(width: size.width, height: size.width)
            .clipShape(outerShape)
            .shadow(color: .darkBackgourdStart,
                    radius: 10,
                    x: -size.innerPadding,
                    y: -size.innerPadding)
            .shadow(color: .darkBackgourdEnd,
                    radius: 10,
                    x: size.innerPadding,
                y: size.innerPadding)
            Image("DefaultCover")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width - size.innerPadding * 2,
                       height: size.width - size.innerPadding * 2)
                .clipShape(innerShape)
            if isOrigin {
                KFImage(URL(string: url))
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - size.innerPadding * 2,
                           height: size.width - size.innerPadding * 2)
                    .clipShape(innerShape)
            }else {
                KFImage(URL(string: url), options: [.processor(DownsamplingImageProcessor(size: CGSize(width: size.width + 100, height: size.width + 100)))])
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - size.innerPadding * 2,
                           height: size.width - size.innerPadding * 2)
                    .clipShape(innerShape)
            }

        }
    }
}
#if DEBUG
struct NEUImageView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEULightBackgroundView()
            VStack(spacing: 50) {
                NEULightImageView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
                             size: .small,
                             innerShape: RoundedRectangle(cornerRadius: 15, style: .continuous),
                             outerShape: RoundedRectangle(cornerRadius: 18, style: .continuous),
                             isOrigin: false)
                NEULightImageView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
                             size: .medium,
                             innerShape: RoundedRectangle(cornerRadius: 25, style: .continuous),
                             outerShape: RoundedRectangle(cornerRadius: 33, style: .continuous),
                             isOrigin: false)
                NEULightImageView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
                             size: .large,
                             innerShape: RoundedRectangle(cornerRadius: 50, style: .continuous),
                             outerShape: RoundedRectangle(cornerRadius: 60, style: .continuous),
                             isOrigin: true)
            }
        }
        ZStack {
            NEUDarkBackgroundView()
            VStack(spacing: 50) {
                NEUDarkImageView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
                             size: .small,
                             innerShape: RoundedRectangle(cornerRadius: 15, style: .continuous),
                             outerShape: RoundedRectangle(cornerRadius: 18, style: .continuous),
                             isOrigin: false)
                NEUDarkImageView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
                             size: .medium,
                             innerShape: RoundedRectangle(cornerRadius: 25, style: .continuous),
                             outerShape: RoundedRectangle(cornerRadius: 33, style: .continuous),
                             isOrigin: false)
                NEUDarkImageView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
                             size: .large,
                             innerShape: RoundedRectangle(cornerRadius: 50, style: .continuous),
                             outerShape: RoundedRectangle(cornerRadius: 60, style: .continuous),
                             isOrigin: true)
            }
        }
    }
}
#endif
