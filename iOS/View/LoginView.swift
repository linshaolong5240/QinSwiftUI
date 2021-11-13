//
//  LoginView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/10/15.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var store: Store
    private var settings: AppState.Settings { store.appState.settings }

    @State  private var email: String = ""
    @State  private var password: String = ""
    
    var body: some View {
        ZStack {
            QinBackgroundView()
            VStack(spacing: 20.0) {
                HStack {
                    QinBackwardButton()
                    Spacer()
                }
                .overlay(
                    QinNavigationBarTitleView("登录")
                )
                TextField("email", text: $email)
                    .textFieldStyle(NEUDefaultTextFieldStyle(label: Image(systemName: "envelope").foregroundColor(.mainText)))
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                SecureField("password", text: $password)
                    .textFieldStyle(NEUDefaultTextFieldStyle(label: Image(systemName: "key").foregroundColor(.mainText)))
                    .autocapitalization(.none)
                    .keyboardType(.asciiCapable)
                Button(action: {
                    self.store.dispatch(.loginRequest(email: self.email, password: self.password))
                }) {
                    Text("登录")
                        .padding()
                }
                .buttonStyle(NEUDefaultButtonStyle(shape: Capsule()))
                if store.appState.settings.loginRequesting {
                    Text("正在登录...")
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
        LoginView()
            .environmentObject(Store.shared)
            .preferredColorScheme(.light)
        LoginView()
            .environmentObject(Store.shared)
            .preferredColorScheme(.dark)

    }
}
#endif
