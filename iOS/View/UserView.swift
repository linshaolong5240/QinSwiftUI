//
//  UserView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/14.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct UserView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var store: Store
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State  var email: String = ""
    @State  var password: String = ""
    private var settings: AppState.Settings { store.appState.settings }
    
    var body: some View {
        ZStack {
            BackgroundView()
                .onTapGesture{
                    UIApplication.shared.endEditing()
                }
            VStack(spacing: 20.0) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        NEUButtonView(systemName: "chevron.backward", size: .medium)
                    }
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                    Spacer()
                    Text("用户")
                    Spacer()
                    Button(action: {
                    }) {
                        NavigationLink(destination: SettingsView()) {
                            NEUButtonView(systemName: "gear", size: .medium)
                        }
                    }
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }
                if store.appState.settings.loginUser == nil {
                    TextField("email", text: $email)
                        .textFieldStyle(NEUTextFieldStyle(label: NEUButtonView(systemName: "envelope")))
                        .autocapitalization(.none)
                    SecureField("password", text: $password)
                        .textFieldStyle(NEUTextFieldStyle(label: NEUButtonView(systemName: "key")))
                        .autocapitalization(.none)
                    Button(action: {
                        self.store.dispatch(.login(email: self.email, password: self.password))
                    }) {
                        Text("登录")
                            .padding()
                    }
                    .buttonStyle(NEUButtonStyle(shape: Capsule()))
                    if store.appState.settings.loginRequesting {
                        Text("正在登录。。。。")
                    }
                    if (store.appState.settings.loginError != nil) {
                        Text("\(store.appState.settings.loginError!.localizedDescription)")
                    }
                }else {
                    NEUImageView(url: settings.loginUser!.profile.avatarUrl, size: .medium, innerShape: RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/), outerShape: RoundedRectangle(cornerRadius: 30, style: .continuous))
                    Text("uid: \(String(settings.loginUser!.uid))")
                    Text("csrf: \(settings.loginUser!.csrf)")
                    Text("Logout")
                        .padding()
                        .background(colorScheme == .light ? Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)) : Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)))
                        .clipShape(Capsule())
                        .modifier(NEUShadow())
                        .onTapGesture {
                            self.store.dispatch(.logout)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
            .environmentObject(Store.shared)
            .environment(\.colorScheme, .light)
    }
}
#endif
