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
    
    init(viewModel: Album) {
        self.configuration = DescriptionConfiguration(viewModel: viewModel)
    }
    
    init(viewModel: Artist) {
        self.configuration = DescriptionConfiguration(viewModel: viewModel)
    }
    
    init(viewModel: PlaylistViewModel) {
        self.configuration = DescriptionConfiguration(viewModel: viewModel)
    }
    
    @State private var showMoreDescription: Bool = false

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                NEUCoverView(url: configuration.picUrl, coverShape: .rectangle, size: .medium)
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
    var description: String
    var id: Int
    var name: String
    var picUrl: String

    init(picUrl: String, name: String, description: String, id: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.picUrl = picUrl
    }

    init(viewModel: Album) {
        self.picUrl = viewModel.picUrl ?? ""
        self.name = viewModel.name ?? ""
        self.description = viewModel.introduction ?? ""
        self.id = Int(viewModel.id)
    }
    
    init(viewModel: Artist) {
        self.picUrl = viewModel.picUrl ?? ""
        self.name = viewModel.name ?? ""
        self.description = ""//viewModel.description
        self.id = Int(viewModel.id)
    }
    
    init(viewModel: PlaylistViewModel) {
        self.picUrl = viewModel.coverImgUrl
        self.name = viewModel.name
        self.description = viewModel.description
        self.id = viewModel.id
    }
}

#if DEBUG
struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView(configuration: DescriptionConfiguration(picUrl: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1602189927688&di=3f64d8e667c95aef44b1ab729dfb39f6&imgtype=0&src=http%3A%2F%2Fimge.kugou.com%2Fstdmusic%2F20150720%2F20150720162823338587.jpg",
                                                                name: "aliez",
                                                                description: "description",
                                                                id: 0))
    }
}
#endif
