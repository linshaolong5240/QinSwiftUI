//
//  LoginView.swift
//  Qin (macOS)
//
//  Created by 林少龙 on 2021/7/3.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var store: Store
    private var settings: AppState.Settings { store.appState.settings }

    @State  private var email: String = ""
    @State  private var password: String = ""
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack(spacing: 20.0) {
                HStack {
                    NEUBackwardButton()
                    Spacer()
                }
                .overlay(
                    NEUNavigationBarTitleView("登录")
                )
                TextField("email", text: $email)
                    .textFieldStyle(NEUTextFieldStyle(label: NEUSFView(systemName: "envelope", size: .medium)))
                SecureField("password", text: $password)
                    .textFieldStyle(NEUTextFieldStyle(label: NEUSFView(systemName: "key", size: .medium)))
                Button(action: {
                    self.store.dispatch(.loginRequest(email: self.email, password: self.password))
                }) {
                    Text("登录")
                        .padding()
                }
                .buttonStyle(NEUButtonStyle(shape: Capsule()))
                if store.appState.settings.loginRequesting {
                    Text("正在登录...")
                }
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
#endif
