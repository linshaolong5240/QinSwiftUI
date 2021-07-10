//
//  CloudUploadView.swift
//  Qin (macOS)
//
//  Created by 林少龙 on 2021/7/10.
//

import SwiftUI

struct CloudUploadView: View {
    @State private var filePath: String = "/Users/linshaolong/Downloads/aHUOz/aHUOz.mp3"
    @State private var fileURL: URL? = URL(fileURLWithPath: "/Users/linshaolong/Downloads/aHUOz/aHUOz.mp3")
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                TextField("Placeholder", text: $filePath)
                Button(action: {
                    if let url = fileURL {
                        Store.shared.dispatch(.cloudUpload(fileURL: url))
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
