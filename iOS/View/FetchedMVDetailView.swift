//
//  FetchedMVDetailView.swift
//  Qin (iOS)
//
//  Created by teenloong on 2020/12/9.
//

import SwiftUI
import Kingfisher
import AVKit
import UIKit
import NeteaseCloudMusicAPI

struct FetchedMVDetailView: View {
    @State private var show: Bool = false
    
    let id: Int

    var body: some View {
        ZStack {
            QinBackgroundView()
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
       NCM.requestPublisher(action: NCMMVURLAction(id: Int(mv.id)))
            .sink { completion in
                if case .failure(let error) = completion {
                    Store.shared.dispatch(.error(.error(error)))
                }
            } receiveValue: { mvURLResponse in
//                store.dispatch(.mvDetaillRequestDone(result: .success(id)))
                mvURL = URL(string: mvURLResponse.data.url)
                showPlayer = true
            }.store(in: &Store.shared.cancells)
    }
}

struct AVPlayerView: UIViewControllerRepresentable {
    @Binding var url: URL?
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if url != nil {
            uiViewController.player = AVPlayer(url: url!)
            uiViewController.player?.play()
            Store.shared.dispatch(.playerPause)
        }
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
}
