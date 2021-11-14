//
//  QinKFImageView.swift
//  Qin
//
//  Created by 林少龙 on 2021/11/14.
//

import SwiftUI
import Kingfisher
import struct Kingfisher.DownsamplingImageProcessor

enum QinKFImageType: Int, CaseIterable, Identifiable {
    var id: Int { rawValue }
    case little
    case small
    case medium
    case large
    
    var length: CGFloat {
        switch self {
        case .little:   return 60
        case .small:    return 110
        case .medium:   return 130
        case .large:    return 300
        }
    }
    
    var cornerRadius: CGFloat { length / 4 }
    var borderWidth: CGFloat { length / 10 }
}

struct QinKFImageView: View {
    
    let urlString: String?
    let type: QinKFImageType

    init(_ urlString: String?, type: QinKFImageType) {
        self.urlString = urlString
        self.type = type
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
                            .frame(width: type.length,
                                   height: type.length)
                    }
                )
                .setProcessor(DownsamplingImageProcessor(size: CGSize(width: type.length, height: type.length)))
              .fade(duration: 0.25)
              .onProgress { receivedSize, totalSize in  }
              .onSuccess { result in  }
              .onFailure { error in }
              .resizable()
              .renderingMode(.original)
              .aspectRatio(contentMode: .fill)
              .modifier(NEUBorderModifier(shape: RoundedRectangle(cornerRadius: type.cornerRadius, style: .continuous), borderWidth: type.borderWidth, style: .unevenness))
              .frame(width: type.length, height: type.length)
        } else {
            Image("PlaceholderImage")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: type.length,
                       height: type.length)
                .modifier(NEUBorderModifier(shape: RoundedRectangle(cornerRadius: type.cornerRadius, style: .continuous), borderWidth: type.borderWidth, style: .unevenness))
                .frame(width: type.length,
                       height: type.length)
        }
    }
}

#if DEBUG
fileprivate struct QinImageBorderDEBUGView: View {
    
    var body: some View {
        ZStack {
            QinBackgroundView()
            VStack(spacing: 30) {
                ForEach(QinKFImageType.allCases) { item in
                    HStack(spacing: 20) {
                        QinKFImageView(nil, type: item)
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
