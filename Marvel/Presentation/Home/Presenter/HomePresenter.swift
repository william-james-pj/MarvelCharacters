//
//  HomePresenter.swift
//  Marvel
//
//  Created by Pinto Junior, William James on 21/06/22.
//

import Foundation
import Combine

enum FetchError: Error {
    case failed
}

protocol HomePresenterInterface: PresenterInterface {
    var router: HomeWireframeInterface? { get set }
    var interactor: HomeInteractorInterface? { get set }
    var view: HomeViewInterface? { get set }
    
    var seachText: CurrentValueSubject<String, Never> { get set }
    
    func featchByOffset()
    func interactorDidFetchCharacter(with result: Result<CharacterDataContainer, Error>, isByOffset: Bool)
}

class HomePresenter: HomePresenterInterface {
    // MARK: - Variables
    var router: HomeWireframeInterface?
    var interactor: HomeInteractorInterface? {
        didSet {
            interactor?.getCharacters()
        }
    }
    var view: HomeViewInterface?
    
    var offSet = 0
    var limit = 20
    var total = 0
    var isLoading: Bool = false
    
    var seachText = CurrentValueSubject<String, Never>("")
    var seachtCancellable: AnyCancellable? = nil
    
    // MARK: - Lifecycle
    init () {
        seachtCancellable = seachText
            .removeDuplicates()
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                if str == "" {
                    return
                }
                self.view?.setLoading(to: true)
                self.interactor?.getCharactersByName(str, offset: 0, isByOffset: false)
            })
    }
    
    // MARK: - Methods
    func interactorDidFetchCharacter(with result: Result<CharacterDataContainer, Error>, isByOffset: Bool) {
        switch result {
        case .success(let dataContainer):
            view?.update(with: dataContainer, isByOffset: isByOffset)
            self.total = dataContainer.total
            self.offSet = dataContainer.offset
        case .failure(let error):
            print(error.localizedDescription)
        }
        
        self.view?.setLoading(to: false)
        self.isLoading = false
    }
    
    func featchByOffset() {
        if isLoading {
            return
        }
        
        if total < offSet + limit { //Melhorar
            return
        }
        
        self.isLoading = true

        self.offSet += limit

        if self.seachText.value != "" {
            self.interactor?.getCharactersByName(self.seachText.value, offset: self.offSet, isByOffset: true)
            return
        }

        interactor?.getCharactersByOffset(offSet)
    }
}
