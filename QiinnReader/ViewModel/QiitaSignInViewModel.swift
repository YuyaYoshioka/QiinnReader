//
//  QiitaSignInViewModel.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2023/01/07.
//

import Foundation
import AuthenticationServices
import Combine
import ArkanaKeys
import KeychainAccess

class QiitaSignInViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    private var qiitaAuthRepository: QiitaAuthRepository
    private var cancellables: [AnyCancellable] = []
    
    @Published var currentUser: QiitaAuthenticatedUser?

    init(qiitaAuthRepository: QiitaAuthRepository = QiitaAuthRepositoryImpl()) {
        self.qiitaAuthRepository = qiitaAuthRepository
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
    
    func signIn() {
        let signInPromise = Future<URL, Error> { completion in
            let authUrl = QiitaAuthenticationURLBuilder.url
            
            let authSession = ASWebAuthenticationSession(
                url: authUrl,
                callbackURLScheme: nil
            ) { (url, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url))
                }
            }
            
            authSession.presentationContextProvider = self
            authSession.prefersEphemeralWebBrowserSession = true
            authSession.start()
        }
         signInPromise.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print("error: \(error)")
            default:
                break
            }
        }, receiveValue: { [self] url in
            guard let code = self.retrieveCode(url) else {
                return
            }
            createAuthToken(code: code)
        })
         .store(in: &cancellables)
    }
    
    func getCurrentUser() {
        guard let accessToken = QiitaKeyChain.shared.getAuthToken() else {
            return
        }
        getAuthenticatedUser(accessToken: accessToken)
    }
    
    private func retrieveCode(_ url: URL) -> String? {
        let components: NSURLComponents? = getURLComonents(url)
        for item in components?.queryItems ?? [] {
            if item.name == "code" {
                return item.value?.removingPercentEncoding
            }
        }
        return nil
    }
    
    private func getURLComonents(_ url: URL) -> NSURLComponents? {
        var components: NSURLComponents? = nil
        components = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
        return components
    }
    
    private func createAuthToken(code: String) {
        IndicatorControl.shared.showLoading()
        qiitaAuthRepository.postData(code: code)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    if let apiError = error as? APIError {
                        print("error: \(apiError.description)")
                    }
                case .finished:
                    print("createAuthToken finished")
                }
            },
                  receiveValue: { [self] qiitaAccessToken in
                QiitaKeyChain.shared.setAuthToken(token: qiitaAccessToken.token)
                getAuthenticatedUser(accessToken: qiitaAccessToken.token)
            }
            )
            .store(in: &cancellables)
    }
    
    private func getAuthenticatedUser(accessToken: String) {
        IndicatorControl.shared.showLoading()
        qiitaAuthRepository.getAuthenticatedUser(accessToken: accessToken)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                IndicatorControl.shared.hideLoading()
                switch completion {
                case .failure(let error):
                    if let apiError = error as? APIError {
                        print("error: \(apiError.description)")
                    }
                case .finished:
                    print("getAuthenticatedUser finished")
                }
            },
                  receiveValue: { user in
                self.currentUser = user
            })
            .store(in: &cancellables)
    }
}

class QiitaAuthenticationURLBuilder {
    static var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "qiita.com"
        components.path = "/api/v2/oauth/authorize"
        components.queryItems = [
            "client_id": ArkanaKeys.Global().clientID,
            "client_secret": ArkanaKeys.Global().clientSecret,
            "scope": "read_qiita write_qiita"
        ].map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
}
