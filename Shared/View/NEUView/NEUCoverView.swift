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
    }
}
#endif

enum NEUCoverShape {
    case circle
    case rectangle
}

struct NEUCoverView: View {
    let url: String
    let coverShape: NEUCoverShape
    let size: NEUImageSize
    var innerPadding: CGFloat {
        switch coverShape {
        case .circle:
            switch size {
            case .large:
                return size.width / 32
            default:
                return size.width / 18
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
            case .small:
                NEUImageView(url: url,
                             size: size,
                             innerShape: Circle(),
                             outerShape: Circle(),
                             innerPadding: innerPadding,
                             shadowReverse: true,
                             isOrigin: false)
            case .medium:
                NEUImageView(url: url,
                             size: size,
                             innerShape: Circle(),
                             outerShape: Circle(),
                             innerPadding: innerPadding,
                             shadowReverse: true,
                             isOrigin: false)
            case .large:
                NEUImageView(url: url,
                             size: size,
                             innerShape: Circle(),
                             outerShape: Circle(),
                             innerPadding: innerPadding,
                             shadowReverse: true,
                             isOrigin: false)
            }
        case .rectangle:
            switch size {
            case .small:
                NEUImageView(url: url,
                             size: size,
                             innerShape: RoundedRectangle(cornerRadius: 15, style: .continuous),
                             outerShape: RoundedRectangle(cornerRadius: 18, style: .continuous),
                             innerPadding: innerPadding,
                             isOrigin: false)
            case .medium:
                NEUImageView(url: url,
                             size: size,
                             innerShape: RoundedRectangle(cornerRadius: 25, style: .continuous),
                             outerShape: RoundedRectangle(cornerRadius: 33, style: .continuous),
                             innerPadding: innerPadding,
                             isOrigin: false)
            case .large:
                NEUImageView(url: url,
                             size: size,
                             innerShape: RoundedRectangle(cornerRadius: 50, style: .continuous),
                             outerShape: RoundedRectangle(cornerRadius: 60, style: .continuous),
                             innerPadding: innerPadding,
                             isOrigin: true)
            }
        }
    }
}
