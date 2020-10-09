//
//  DescriptionView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/9.
//

import SwiftUI

struct DescriptionView: View {
    private let configuration: DescriptionConfiguration
    
    init(configuration: DescriptionConfiguration) {
        self.configuration = configuration
    }
    
    init(viewModel: AlbumDetailViewModel) {
        self.configuration = DescriptionConfiguration(viewModel: viewModel)
    }
    
    init(viewModel: ArtistDetailViewModel) {
        self.configuration = DescriptionConfiguration(viewModel: viewModel)
    }
    
    init(viewModel: PlaylistViewModel) {
        self.configuration = DescriptionConfiguration(viewModel: viewModel)
    }
    
    @State private var showMoreDescription: Bool = false

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                NEUCoverView(url: configuration.coverUrl, coverShape: .rectangle, size: .medium)
                Text("Id:\(String(configuration.id))")
                    .foregroundColor(.secondTextColor)
            }
            VStack(alignment: .leading) {
                Text(configuration.name)
                    .fontWeight(.bold)
                    .lineLimit(showMoreDescription ? nil : 1)
                    .foregroundColor(.mainTextColor)
                Text(configuration.description)
                    .foregroundColor(.secondTextColor)
                    .lineLimit(showMoreDescription ? nil : 5)
            }
            .onTapGesture{
                showMoreDescription.toggle()
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct DescriptionConfiguration {
    var coverUrl: String
    var name: String
    var description: String
    var id: Int
    
    init(coverUrl: String, name: String, description: String, id: Int) {
        self.coverUrl = coverUrl
        self.name = name
        self.description = description
        self.id = id
    }

    init(viewModel: AlbumDetailViewModel) {
        self.coverUrl = viewModel.coverUrl
        self.name = viewModel.name
        self.description = viewModel.description
        self.id = viewModel.id
    }
    
    init(viewModel: ArtistDetailViewModel) {
        self.coverUrl = viewModel.coverUrl
        self.name = viewModel.name
        self.description = viewModel.description
        self.id = viewModel.id
    }
    
    init(viewModel: PlaylistViewModel) {
        self.coverUrl = viewModel.coverImgUrl
        self.name = viewModel.name
        self.description = viewModel.description
        self.id = viewModel.id
    }
}

#if DEBUG
struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView(configuration: DescriptionConfiguration(coverUrl: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1602189927688&di=3f64d8e667c95aef44b1ab729dfb39f6&imgtype=0&src=http%3A%2F%2Fimge.kugou.com%2Fstdmusic%2F20150720%2F20150720162823338587.jpg",
                                                                name: "aliez",
                                                                description: "description",
                                                                id: 0))
    }
}
#endif
