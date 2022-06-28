//
//  SeeCharacterInteractor.swift
//  Marvel
//
//  Created by Pinto Junior, William James on 27/06/22.
//

import Foundation
import CryptoKit

protocol SeeCharacterInteractorInterface: InteractorInterface {
    var presenter: SeeCharacterPresenterInterface? { get set }
    
    func getComic(_ id: Int)
    func getSerie(_ id: Int)
}

class SeeCharacterInteractor: SeeCharacterInteractorInterface {
    // MARK: - Constrants
    fileprivate let urlBase = "https://gateway.marvel.com:443/v1/public/characters"
    
    // MARK: - Variables
    var presenter: SeeCharacterPresenterInterface?
    
    // MARK: - Methods
    func getComic(_ id: Int) {
        let (ts, publicKey, hash) = getParameters()
        
        guard let url = URL(string: "\(urlBase)/\(id)/comics?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)") else {
            return
        }
        
        fetchDataByUrl(url, title: "Comic")
    }
    
    func getSerie(_ id: Int) {
        let (ts, publicKey, hash) = getParameters()
        
        guard let url = URL(string: "\(urlBase)/\(id)/series?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)") else {
            return
        }
        
        fetchDataByUrl(url, title: "Serie")
    }
    
    fileprivate func fetchDataByUrl(_ url: URL, title: String) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                self?.presenter?.interactorDidFetch(with: .failure(FetchError.failed), title: title)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ContentAPIResult.self, from: data)
                self?.presenter?.interactorDidFetch(with: .success(response.data), title: title)
            }
            catch {
                self?.presenter?.interactorDidFetch(with: .failure(error), title: title)
            }
        }
        
        task.resume()
    }
    
    fileprivate func getParameters() -> (ts: String, publicKey: String, hash: String) {
        let publicKey = "486c02520bfbd17df0aca6ceec62a4b4"
        let privateKey = "f8aff51f1b424b9e9819c649f2a8e2b3cd3cb0de"
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        
        return (ts, publicKey, hash)
    }
    
    fileprivate func MD5(data: String) -> String {
        let digest = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
