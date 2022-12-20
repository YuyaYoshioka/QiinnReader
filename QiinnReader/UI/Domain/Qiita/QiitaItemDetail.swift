//
//  QiitaItemDetail.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/21.
//

import SwiftUI
import SwiftyMarkdown

struct QiitaItemDetail: View {
    let item: QiitaItem

    var body: some View {
        ScrollView {
            Text("\(md)")
        }
    }
    
    private var md: NSAttributedString {
        let md = SwiftyMarkdown(string: item.body)
        md.underlineLinks = true
        
        return md.attributedString()
    }
}

struct QiitaItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        QiitaItemDetail(item: QiitaModelExamples.createQiitaItemFactory())
    }
}
