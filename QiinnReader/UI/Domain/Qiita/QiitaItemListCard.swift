//
//  QiitaItemListItem.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/18.
//

import SwiftUI

struct QiitaItemListCard: View {
    let item: QiitaItem
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: item.user.profileImageUrl)) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.crop.circle").resizable()
            }
            .clipShape(Circle())
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("@\(item.user.id)")
                    Text(CustomDateFormatter.createDateStrFromISO8601DateString(iSO8601DateString:  item.updatedAt))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                NavigationLink {
                    QiitaItemDetail(item: item)
                } label: {
                    Text(item.title)
                        .foregroundColor(.primary)
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                }
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top) {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.gray)
                            .rotationEffect(.degrees(270))
                        Text(item.createTagNames())
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.footnote)
                    }
                    HStack {
                        Image(systemName: "heart")
                        Text("\(item.likesCount)")
                            .font(.footnote)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .cornerRadius(16)
    }
}

struct QiitaItemListCard_Previews: PreviewProvider {
    static var previews: some View {
        QiitaItemListCard(item: QiitaModelExamples.createQiitaItemFactory())
    }
}
