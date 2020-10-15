//
//  LyricView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/10/12.
//

import SwiftUI

struct LyricView: View {
    @EnvironmentObject private var store: Store
    
    private var viewModel: LyricViewModel
    private let onelineMode: Bool

    init(_ viewModel: LyricViewModel, onelineMode: Bool = false) {
        self.viewModel = viewModel
        self.onelineMode = onelineMode
    }
    
    var body: some View {
        VStack {
            if onelineMode {
                Text(viewModel.lyric)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
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
