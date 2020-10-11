//
//  SwiftUI+Extension.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/12.
//

import SwiftUI

#if DEBUG
struct SwiftUI_Extension: View {
    let data = ["Albemarle", "Brandywine", "Chesapeake", "asdsad", "sfdgd", "dfgd", "fbnbvb"]//Array(repeating: "asdasdasd", count: 50)
    var body: some View {
        VStack {
            MultilineHStack(data) { item in
                Text(item)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .background(Color.blue)
            MultilineHStack(data) { item in
                Text(item)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .background(Color.green)
            Text("testest")
            Spacer()
        }
    }
}

struct SwiftUI_Extension_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUI_Extension()
    }
}
#endif


struct MultilineHStack<Data: RandomAccessCollection,  Content: View>: View where Data.Element: Hashable {
    let data: Data
    let HSpacing: CGFloat
    let VSpacing: CGFloat
    let content: (Data.Element) -> Content
    @State private var totalHeight = CGFloat.zero
    
    init(_ data: Data, HSpacing: CGFloat = 10, VSpacing: CGFloat = 10, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.HSpacing = HSpacing
        self.VSpacing = VSpacing
        self.content = content
    }
    
    var body: some View {
        var width: CGFloat = .zero
        var height: CGFloat = .zero
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(data, id: \.self) { item in
                    content(item)
                        .alignmentGuide(.leading, computeValue: { dimension in
                            if abs(width + dimension.width) > geometry.size.width {
                                width = 0
                                height += dimension.height + VSpacing
                            }
                            let result = width
                            if item == data.last {
                                width = 0
                            }else {
                                width += dimension.width + HSpacing
                            }
                            return -result
                        })
                        .alignmentGuide(.top, computeValue: { dimension in
                            let result = height
                            if item == data.last {
                                height = 0
                            }
                            return -result
                        })
                }
            }
            .background(viewHeightReader($totalHeight))
        }
        .frame(height: totalHeight)
    }
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

struct MultilineHStackScrollable<Data: RandomAccessCollection,  Content: View>: View where Data.Element: Hashable {
    let data: Data
    let geometry: GeometryProxy
    let HSpacing: CGFloat
    let VSpacing: CGFloat
    let content: (Data.Element) -> Content

    init(_ data: Data, geometry: GeometryProxy, HSpacing: CGFloat = 10, VSpacing: CGFloat = 10, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.geometry = geometry
        self.HSpacing = HSpacing
        self.VSpacing = VSpacing
        self.content = content
    }
    var body: some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        ZStack(alignment: .topLeading) {
            ForEach(data, id: \.self) { item in
                content(item)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if abs(width + dimension.width) > geometry.size.width {
                            width = 0
                            height += dimension.height + VSpacing
                        }
                        let result = width
                        if item == data.last {
                            width = 0
                        }else {
                            width += dimension.width + HSpacing
                        }
                        return -result
                    })
                    .alignmentGuide(.top, computeValue: { dimension in
                        let result = height
                        if item == data.last {
                            height = 0
                        }
                        return -result
                    })
            }
        }
    }
}
