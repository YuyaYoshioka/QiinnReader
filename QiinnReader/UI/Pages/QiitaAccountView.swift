//
//  QiitaAccountView.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2023/01/15.
//

import SwiftUI

struct QiitaAccountView: View {
    @StateObject var viewModel = QiitaSignInViewModel()

    var body: some View {
        VStack {
            if let user = viewModel.currentUser {
                Text(user.id)
            } else {
                Button {
                    viewModel.signIn()
                } label: {
                    Text("ログイン")
                }
            }
        }
        .onAppear {
            if viewModel.currentUser == nil {
                viewModel.getCurrentUser()
            }
        }
    }
}

struct QiitaAccountView_Previews: PreviewProvider {
    static var previews: some View {
        QiitaAccountView()
    }
}
