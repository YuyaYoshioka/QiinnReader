//
//  QiitaPopularItemListCard.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/28.
//

import SwiftUI

struct QiitaPopularItemListCard: View {
    let item: QiitaPopularItem
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "person.crop.circle")
                .resizable()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("@\(item.author.name)")
                    Text(CustomDateFormatter.createDateStrFromISO8601DateString(iSO8601DateString: item.entry.updated))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                NavigationLink {
                    QiitaItemDetail(qiitaItemViewModel: QiitaItemViewModel(), qiitaItemID: item.createID())
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.entry.title)
                            .foregroundColor(.primary)
                            .font(.title3)
                            .multilineTextAlignment(.leading)
                        Text(item.entry.content)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct QiitaPopularItemListCard_Previews: PreviewProvider {
    static var previews: some View {
        QiitaPopularItemListCard(item: QiitaModelExamples.createQiitaPopularItemFactory())
    }
}
