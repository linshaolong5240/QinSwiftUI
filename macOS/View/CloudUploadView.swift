//
//  CloudUploadView.swift
//  Qin (macOS)
//
//  Created by 林少龙 on 2021/7/10.
//

import SwiftUI
//size 12677747
//CloudUploadTokenResponse(code: 200, message: nil, result: Qin.CloudUploadTokenResponse.Result(bucket: "ymusic", docId: "-1", objectKey: "obj/w5zCgMODwrDDjD3DisKy/3874458085/17a2/7d10/59a3/30950d1ef143de0efa654687c825f363.mp3", resourceId: 3874458085, token: "UPLOAD 319a693f5570493584f7271dd787a68a:5wyFvgKmDzGV9ecmYFT1BquwnauHNvFIJ6c4DSnSQeU=:eyJSZWdpb24iOiJIWiIsIk9iamVjdCI6Im9iai93NXpDZ01PRHdyRERqRDNEaXNLeS8zODc0NDU4MDg1LzE3YTIvN2QxMC81OWEzLzMwOTUwZDFlZjE0M2RlMGVmYTY1NDY4N2M4MjVmMzYzLm1wMyIsIkV4cGlyZXMiOjE2MjU5NDY2NzMsIkJ1Y2tldCI6InltdXNpYyIsIlJlc291cmNlSWQiOjAsIk92ZXJXcml0ZSI6ZmFsc2V9"))
struct CloudUploadView: View {
    @State private var filePath: String = "/Users/linshaolong/Downloads/aHUOz的副本/aHUOz无损.mp3"
    @State private var fileURL: URL? = URL(fileURLWithPath: "/Users/linshaolong/Downloads/aHUOz的副本/aHUOz无损.mp3")
    
    var body: some View {
        ZStack {
            QinBackgroundView()
            VStack {
                TextField("Placeholder", text: $filePath)
                Button(action: {
                    if let url = fileURL {
                        Store.shared.dispatch(.cloudUploadCheckRequest(fileURL: url))
                    }
                }, label: {
                    Text("Upload")
                })
            }
        }
        .onDrop(of: [(kUTTypeFileURL as String)], delegate: self)
    }
}

extension CloudUploadView: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [(kUTTypeFileURL as String)]).first else { return false }
        
        itemProvider.loadItem(forTypeIdentifier: (kUTTypeFileURL as String), options: nil) {item, error in
            guard let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
            // Do something with the file url
            // remember to dispatch on main in case of a @State change
            DispatchQueue.main.async {
                fileURL = url
                filePath = url.path
            }
            print(url.path)
        }
        return true
    }
}

#if DEBUG
struct CloudUploadView_Previews: PreviewProvider {
    static var previews: some View {
        CloudUploadView()
    }
}
#endif
