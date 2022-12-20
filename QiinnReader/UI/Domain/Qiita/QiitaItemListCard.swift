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
                Text(item.title)
                    .font(.title3)
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top) {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.gray)
                            .rotationEffect(.degrees(270))
                        Text(tagsName)
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
        .background(.white)
        .cornerRadius(16)
    }
    
    private var tagsName: String {
        let titles = item.tags.map(\.name)
        let titlesStr = titles.joined(separator: ",")
        
        print(titles)
        print(titlesStr)
        
        return titlesStr
    }
}

struct QiitaItemListCard_Previews: PreviewProvider {
    static var previews: some View {
        QiitaItemListCard(item: QiitaModelExamples.createQiitaItemFactory())
    }
}

extension String {
    func getAttributedString() -> AttributedString {
        do {
            let attributedString = try AttributedString(markdown: self)
            return attributedString
        } catch {
            print("")
        }
        return AttributedString("Error parsing")
    }
}
