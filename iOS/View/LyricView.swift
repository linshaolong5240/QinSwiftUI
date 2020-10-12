//
//  LyricView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/10/12.
//

import SwiftUI

struct LyricView: View {
    @EnvironmentObject private var store: Store
    
    private var viewModel: LyricViewModel { store.appState.lyric.lyric }
    let isOneLine: Bool

    var body: some View {
        VStack {
            if isOneLine {
                Text(viewModel.lyric)
                    .fontWeight(.bold)
                    .foregroundColor(.secondTextColor)
                    .lineLimit(1)
            }else {
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(0..<viewModel.lyricParser.lyrics.count, id: \.self) { index in
                            Text(viewModel.lyricParser.lyrics[index])
                                .fontWeight(index == viewModel.index ? .bold : .none)
                                .foregroundColor(index == viewModel.index ? .orange : .secondTextColor)
                                .multilineTextAlignment(.center)
                                .id(index)
                        }
                    }
                    .onReceive(viewModel.$index, perform: { value in
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(value, anchor: .center)
                        }
                    })
                }
            }
        }
    }
}

#if DEBUG
struct LyricView_Previews: PreviewProvider {
    static var previews: some View {
        LyricView(isOneLine: false)
    }
}
#endif
