//
//  NEUCoverView.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/14.
//

import SwiftUI

#if DEBUG
struct NEUCoverView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            VStack(spacing: 50) {
                NEUCoverView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
                             coverShape: .rectangle,
                             size: .little)
                NEUCoverView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
                             coverShape: .rectangle,
                             size: .medium)
                NEUCoverView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
                             coverShape: .rectangle,
                             size: .large)
                
            }
        }
        .environment(\.colorScheme, .dark)
//        ZStack {
//            NEUBackgroundView()
//            VStack(spacing: 50) {
//                NEUCoverView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
//                             coverShape: .circle,
//                             size: .small)
//                NEUCoverView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
//                             coverShape: .circle,
//                             size: .medium)
//                NEUCoverView(url: "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg",
//                             coverShape: .circle,
//                             size: .large)
//
//            }
//        }
//        .environment(\.colorScheme, .dark)
    }
}
#endif

enum NEUCoverShape: Int, CaseIterable, Codable {
    case circle = 0 ,rectangle
    var systemName: String {
        switch self {
        case .circle:
            return "circle"
        case .rectangle:
            return "rectangle"
        }
    }
}

struct NEUCoverView: View {
    let url: String?
    let coverShape: NEUCoverShape
    let size: QinImageSize
    var innerPadding: CGFloat {
        switch coverShape {
        case .circle:
            switch size {
            case .large:
                return size.width / 24
            default:
                return size.width / 16
            }
        case .rectangle:
            switch size {
            case .large:
                return size.width / 16
            default:
                return size.width / 12
            }
        }
    }
    
    var body: some View {
        switch coverShape {
        case .circle:
            switch size {
            case .little:
                QinImageView(url: url,
                             size: size,
                             innerShape: Circle(),
                             outerShape: Circle(),
                             innerPadding: innerPadding,
                             shadowReverse: true,
                             isOrigin: false)
            case .small:
                QinImageView(url: url,
                             size: size,
                             innerShape: Circle(),
                             outerShape: Circle(),
                             innerPadding: innerPadding,
                             shadowReverse: true,
                             isOrigin: false)
            case .medium:
                QinImageView(url: url,
                             size: size,
                             innerShape: Circle(),
                             outerShape: Circle(),
                             innerPadding: innerPadding,
                             shadowReverse: true,
                             isOrigin: false)
            case .large:
                QinImageView(url: url,
                             size: size,
                             innerShape: Circle(),
                             outerShape: Circle(),
                             innerPadding: innerPadding,
                             shadowReverse: true,
                             isOrigin: false)
            }
        case .rectangle:
            switch size {
            case .little:
                QinImageView(url: url,
                             size: size,
                             innerShape: RoundedRectangle(cornerRadius: (size.width - innerPadding) / 5, style: .continuous),
                             outerShape: RoundedRectangle(cornerRadius: size.width / 4, style: .continuous),
                             innerPadding: innerPadding,
                             isOrigin: false)
            case .small:
                QinImageView(url: url,
                             size: size,
                             innerShape: RoundedRectangle(cornerRadius: (size.width - innerPadding) / 5, style: .continuous),
                             outerShape: RoundedRectangle(cornerRadius: size.width / 4, style: .continuous),
                             innerPadding: innerPadding,
                             isOrigin: false)
            case .medium:
                QinImageView(url: url,
                             size: size,
                             innerShape: RoundedRectangle(cornerRadius: (size.width - innerPadding) / 5, style: .continuous),
                             outerShape: RoundedRectangle(cornerRadius: size.width / 4, style: .continuous),
                             innerPadding: innerPadding,
                             isOrigin: false)
            case .large:
                QinImageView(url: url,
                             size: size,
                             innerShape: RoundedRectangle(cornerRadius: (size.width - innerPadding) / 5, style: .continuous),
                             outerShape: RoundedRectangle(cornerRadius: size.width / 4, style: .continuous),
                             innerPadding: innerPadding,
                             isOrigin: true)
            }
        }
    }
}
