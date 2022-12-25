//
//  ProgressIcon.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/25.
//

import SwiftUI

struct ProgressIcon: View {
    var body: some View {
        ProgressView()
            .padding()
            .background(.secondary)
            .cornerRadius(4)
    }
}

struct ProgressIcon_Previews: PreviewProvider {
    static var previews: some View {
        ProgressIcon()
    }
}
