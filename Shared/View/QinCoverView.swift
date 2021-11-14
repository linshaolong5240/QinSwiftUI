//
//  QinCoverView.swift
//  Qin
//
//  Created by 林少龙 on 2021/11/14.
//

import SwiftUI
import Kingfisher
import struct Kingfisher.DownsamplingImageProcessor

enum QinCoverShape: Int, CaseIterable, Codable {
    case circle, rectangle
    var systemName: String {
        switch self {
        case .circle:
            return "circle"
        case .rectangle:
            return "rectangle"
        }
    }
}

enum QinCoverSize: Int, CaseIterable, Identifiable {
    var id: Int { rawValue }
    case little
    case small
    case medium
    case large
    
    var size: CGSize {
        switch self {
        case .little:   return CGSize(width: 60, height: 60)
        case .small:    return CGSize(width: 110, height: 110)
        case .medium:   return CGSize(width: 110, height: 110)
        case .large:    return CGSize(width: 110, height: 110)
        }
    }
    
    var minLength: CGFloat { min(size.width, size.height) }
    
    var cornerRadius: CGFloat { minLength / 4 }
    var borderWidth: CGFloat { minLength / 10 }
}

struct QinCoverStyle {
    var size: QinCoverSize
    var shape: QinCoverShape
    var type: NEUBorderStyle = .unevenness
    
    var cornerRadius: CGFloat { size.minLength / 4 }
    var borderWidth: CGFloat {
        switch shape {
        case .circle:       return size.minLength / 15
        case .rectangle:    return size.minLength / 10
        }
    }
}

struct QinCoverView: View {
    
    let urlString: String?
    let style: QinCoverSize

    init(_ urlString: String?, style: QinCoverSize) {
        self.urlString = urlString
        self.style = style
    }
    
    var body: some View {
        if let urlString = urlString {
            KFImage(URL(string: urlString))
                .placeholder(
                    {
                        Image("PlaceholderImage")
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: style.minLength,
                                   height: style.minLength)
                    }
                )
                .setProcessor(DownsamplingImageProcessor(size: CGSize(width: style.minLength, height: style.minLength)))
              .fade(duration: 0.25)
              .onProgress { receivedSize, totalSize in  }
              .onSuccess { result in  }
              .onFailure { error in }
              .resizable()
              .renderingMode(.original)
              .aspectRatio(contentMode: .fill)
              .modifier(NEUBorderModifier(shape: RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous), borderWidth: style.borderWidth, style: .unevenness))
              .frame(width: style.minLength, height: style.minLength)
        } else {
            Image("PlaceholderImage")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: style.minLength,
                       height: style.minLength)
                .modifier(NEUBorderModifier(shape: RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous), borderWidth: style.borderWidth, style: .unevenness))
                .frame(width: style.minLength,
                       height: style.minLength)
        }
    }
}

#if DEBUG
fileprivate struct QinImageBorderDEBUGView: View {
    
    var body: some View {
        ZStack {
            QinBackgroundView()
            VStack(spacing: 30) {
                let urlString: String? = "https://p2.music.126.net/-SbVXET_BMXEDRqRGlbfLA==/1296324209218955.jpg"
//                let urlString: String? = nil
                ForEach(QinCoverSize.allCases) { item in
                    HStack(spacing: 20) {
                        QinCoverView(urlString, style: item)
                    }
                }
            }
        }
    }
}

struct QinImageBorderView_Previews: PreviewProvider {
    static var previews: some View {
        QinImageBorderDEBUGView()
            .preferredColorScheme(.light)
        QinImageBorderDEBUGView()
            .preferredColorScheme(.dark)
    }
}
#endif
