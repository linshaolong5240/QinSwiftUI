//
//  DiscoverPlaylistViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/12.
//

import Combine

struct PlaylistCatalogue: Identifiable {
    public var id: Int
    public let name: String
    public let subs: [String]
}

extension CommonPlaylist: Identifiable {
    
}

class DiscoverPlaylistViewModel: ObservableObject {
    var cancell = AnyCancellable({})
        
    @Published var requesting = false
    var catalogue: [PlaylistCatalogue]
    @Published var playlists = [CommonPlaylist]()
    
    init(catalogue: [PlaylistCatalogue]) {
        self.catalogue = catalogue
    }
    
    func playlistRequest(cat: String) {
        cancell = NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: PlaylistListAction(parameters: .init(cat: cat, order: .hot, limit: 30, offset: 0 * 30, total: true)))
            .sink { completion in
                if case .failure(let error) = completion {
                    Store.shared.dispatch(.error(AppError.neteaseCloudMusic(error: error)))
                }
            } receiveValue: {[weak self] playlistListResponse in
                self?.playlists = playlistListResponse.playlists
            }
    }
}
