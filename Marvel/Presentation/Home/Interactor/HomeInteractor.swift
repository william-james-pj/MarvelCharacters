//
//  HomeInteractor.swift
//  Marvel
//
//  Created by Pinto Junior, William James on 21/06/22.
//

import Foundation
import CryptoKit

protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    
    func getCharacters()
    func getCharactersByName(_ name: String, offset: Int, isByOffset: Bool)
    func getCharactersByOffset(_ offset: Int)
}

class HomeInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    fileprivate let urlBase = "https://gateway.marvel.com:443/v1/public/characters?"
    
    func getCharacters() {
        let (ts, publicKey, hash) = getParameters()
        
        guard let url = URL(string: "\(urlBase)ts=\(ts)&apikey=\(publicKey)&hash=\(hash)") else {
            return
        }
        
        fetchDataByUrl(url)
    }
    
    func getCharactersByName(_ name: String, offset: Int, isByOffset: Bool) {
        let (ts, publicKey, hash) = getParameters()
        
        guard let url = URL(string: "\(urlBase)nameStartsWith=\(name)&offset=\(offset)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)") else {
            return
        }
        
        fetchDataByUrl(url, isByOffset: isByOffset)
    }
    
    func getCharactersByOffset(_ offset: Int) {
        let (ts, publicKey, hash) = getParameters()
        
        guard let url = URL(string: "\(urlBase)offset=\(offset)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)") else {
            return
        }
        
        fetchDataByUrl(url, isByOffset: true)
    }
    
    fileprivate func getParameters() -> (ts: String, publicKey: String, hash: String) {
        let publicKey = "486c02520bfbd17df0aca6ceec62a4b4"
        let privateKey = "f8aff51f1b424b9e9819c649f2a8e2b3cd3cb0de"
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        
        return (ts, publicKey, hash)
    }
    
    fileprivate func fetchDataByUrl(_ url: URL, isByOffset: Bool = false) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                self?.presenter?.interactorDidFetchCharacter(with: .failure(FetchError.failed), isByOffset: isByOffset)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(APIResult.self, from: data)
                self?.presenter?.interactorDidFetchCharacter(with: .success(response.data), isByOffset: isByOffset)
            }
            catch {
                self?.presenter?.interactorDidFetchCharacter(with: .failure(error), isByOffset: isByOffset)
            }
        }
        
        task.resume()
    }
    
    fileprivate func MD5(data: String) -> String {
        let digest = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
