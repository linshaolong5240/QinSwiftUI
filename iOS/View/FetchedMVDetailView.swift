//
//  FetchedMVDetailView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/12/9.
//

import SwiftUI
import KingfisherSwiftUI
import AVKit
import UIKit

struct FetchedMVDetailView: View {
    @State private var show: Bool = false
    
    let id: Int64

    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack(spacing: 10) {
                CommonNavigationBarView(id: id, title: "MV详情", type: .mv)
                    .onAppear {
                        DispatchQueue.main.async {
                            show = true
                        }
                    }
                if show {
                    FetchedResultsView(entity: MV.entity(), predicate: NSPredicate(format: "%K == \(id)", "id")) { (results: FetchedResults<MV>) in
                        if let mv = results.first {
                            MVDetailView(mv: mv)
                                .onAppear {
//                                    if results.first?.introduction == nil {
//                                        Store.shared.dispatch(.mvDetail(id: id))
//                                    }
                                }
                        }
//                        else {
//                            Text("Loading...")
//                                .onAppear {
//                                    Store.shared.dispatch(.mvDetail(id: id))
//                                }
//                            Spacer()
//                        }
                    }
                }else {
                    Text("loading")
                }
            }

        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct FetchedMVDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FetchedMVDetailView(id: 0)
    }
}
#endif

struct MVDetailView: View {
    @ObservedObject var mv: MV
    @State private var mvURL: URL?
    @State private var showPlayer: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                fetchMVURL()
            }) {
                KFImage(URL(string: mv.imgurl16v9 ?? ""))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Image(systemName: "play.circle")
                    )
            }
            .fullScreenCover(isPresented: $showPlayer, content: {
                AVPlayerView(url: $mvURL)
                    .edgesIgnoringSafeArea(.all)
        })
            Spacer()
        }
    }
    
    func fetchMVURL() {
        NeteaseCloudMusicApi.shared.mvUrl(id: mv.id) { (data, error) in
            guard error == nil else {
                return
            }
            guard data?["code"] as? Int == 200 else {
                return
            }
            guard let mvURLDict = data?["data"] as? [String: Any] else {
                return
            }
            if let mvURLJSONModel = mvURLDict.toData?.toModel(MVURLJSONModel.self) {
                if let url = URL(string: mvURLJSONModel.url) {
                    self.mvURL = url
                    self.showPlayer = true
                }
            }
        }
    }
}

struct AVPlayerView: UIViewControllerRepresentable {
    @Binding var url: URL?
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if url != nil {
            uiViewController.player = AVPlayer(url: url!)
            uiViewController.player?.play()
            Store.shared.dispatch(.PlayerPause)
        }
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
}
