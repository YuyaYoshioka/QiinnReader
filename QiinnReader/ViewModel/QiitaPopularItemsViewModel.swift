//
//  QiitaPopularItemsViewModel.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/26.
//

import Foundation
import Combine

final class QiitaPopularItemsViewModel: ObservableObject {
    private var qiitaPopularItemsRepository: QiitaPopularItemsRepository
    private var cancellable: AnyCancellable?
    
    @Published var items: [QiitaPopularItem] = []
    
    init(qiitaPopularItemsRepository: QiitaPopularItemsRepository = QiitaPopularItemsRepositoryImpl()) {
        self.qiitaPopularItemsRepository = qiitaPopularItemsRepository
    }
    
    func loadData() {
        IndicatorControl.shared.showLoading()
        cancellable = qiitaPopularItemsRepository.loadData()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                IndicatorControl.shared.hideLoading()
                
                switch completion {
                case .failure(let error):
                    if let apiError = error as? APIError {
                        print("error: \(apiError.description)")
                    }
                    print(error)
                case .finished:
                    print("QiitaPopularItemsViewModel.loadData finished")
                }
            },
              receiveValue: { data in
                let parser = QiitaPopularItemsXMLParser(data: data)
                parser.execute()
                self.items = parser.items
            })
    }
}

final class QiitaPopularItemsXMLParser: NSObject, XMLParserDelegate {
    var items: [QiitaPopularItem] = []

    private let data: Data
    
    private var currentElementName = ""
    private var isStartEntry = false
    private var id = ""
    private var published = ""
    private var updated = ""
    private var link = ""
    private var title = ""
    private var content = ""
    private var name = ""
    
    init(data: Data) {
        self.data = data
    }

    func execute() {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = elementName
        switch elementName {
        case "feed":
            items = []
        case "entry":
            isStartEntry = true
        case "link":
            link = attributeDict["href"] ?? ""
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if !isStartEntry {
            return
        }
        
        if currentElementName == "entry" {
            id = ""
            published = ""
            updated = ""
            title = ""
            content = ""
            name = ""
        }

        
        let element = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if element.isEmpty {
            return
        }
        
        switch currentElementName {
        case "id":
            id += element
        case "published":
            published += element
        case "updated":
            updated += element
        case "title":
            title += element
        case "content":
            content += element
        case "name":
            name += element
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "entry" {
            let entry = QiitaPopularItem.Entry(
                id: id,
                published: published,
                updated: updated,
                link: link,
                title: title,
                content: content
            )
            let author = QiitaPopularItem.Author(name: name)
            let item = QiitaPopularItem(entry: entry, author: author)
            items.append(item)
        }
        
        if elementName == "feed" {
            isStartEntry = false
        }
    }
}
