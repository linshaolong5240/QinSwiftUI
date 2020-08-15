//
//  TestView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/26.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct TestView: View {
    @State private var isShowingDetailView = false

    var body: some View {
        VStack {
            ZStack {
                ZStack {
                    Color.white
                        Color.orange
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: .white, radius: 5, x: 10, y: 10)
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: -10, y: -10)
    //                    .padding(10)
    //                    .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                .shadow(color: .white, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: -10, y: -10)
                .shadow(color: Color.black.opacity(0.15), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 10, y: 10)
                Image("cover")
                    .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            NEUImageView(url: "", size: .small, innerShape: RoundedRectangle(cornerRadius: 12, style: .continuous), outerShape: RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
//            Color.backgroundColor
            BackgroundView()
            TestView()
        }
    }
}


struct Test1View: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        HStack {
            Button(action: {
               self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "gobackward").padding()
            }
            .navigationBarHidden(true)
            Spacer()
        }
        ScrollView {
            LazyVStack {
                ForEach(0 ..< 50) { item in
                    HStack {
                        Text("test 1")
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("test 1")
            .navigationBarBackButtonHidden(true)
        }
    }
}
