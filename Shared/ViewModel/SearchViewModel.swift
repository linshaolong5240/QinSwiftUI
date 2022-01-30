//
//  SearchViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2021/12/20.
//

import Foundation
import Combine
import CloudKit

class SearchViewModel: ObservableObject {
    struct SearchResult {
        var songs: [QinSong] = []
        var hasMore: Bool = false
    }
    
    var cancellableSet: Set<AnyCancellable> = []
    @Published var key: String
    @Published var searchType: NCMSearchType = .song
    @Published var result: SearchResult = .init()
    @Published var requesting: Bool = false
    
    private var limit: Int = 100
    private var offset: Int = 0

    init(key: String = "") {
        self.key = key
    }
    
    func reset() {
        key = ""
    }
    
    func search() {
        guard !key.isEmpty else { return }
        searchRequest(key: key,type: searchType)
    }
    
    private func searchRequest(key: String, type: NCMSearchType) {
            switch type {
            case .song:
                SearchSongRequest(key: key, type: type)
            case .album:
                break
            case .artist:
                break
            case .playlist:
                break
            case .user:
                break
            case .mv:
                break
            case .lyric:
                break
            case .fm:
                break
            case .vedio:
                break
            }
    }
    
    private func SearchSongRequest(key: String, type: NCMSearchType) {
        NCM.requestPublisher(action: NCMSearchSongAction(.init(s: key, type: type, limit: limit, offset: offset * limit))).sink { completion in
            if case .failure(let error) = completion {
                Store.shared.dispatch(.error(.error(error)))
            }
        } receiveValue: {[weak self] response in
            guard let weakSelf = self else { return }
            guard response.isSuccess, let result = response.result else {
                Store.shared.dispatch(.error(.neteaseCloudMusic(code: response.code, message: response.message)))
                return
            }
            weakSelf.result = .init(songs: result.songs?.map(QinSong.init) ?? [], hasMore: result.hasMore ?? false)
        }.store(in: &cancellableSet)
    }
}
