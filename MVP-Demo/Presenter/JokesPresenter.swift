//
//  JokesPresenter.swift
//  MVP-Demo
//
//  Created by Manoj Shivhare on 23/09/23.
//

import Foundation

protocol JokesPresenterDelegate: AnyObject {
    func updtesJokes(joke: String)
    func showError(message: String)
}

class JokesPresenter{
    
    weak var delegate: JokesPresenterDelegate?
    
    func setViewDelegate(delegate: JokesPresenterDelegate) {
        self.delegate = delegate
    }
    
    func getJokes() {
        guard let url = URL(string: "https://geek-jokes.sameerkumar.website/api") else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) {[weak self] data, _ , error in
            guard let data = data, error == nil else { return }
            do{
                let joke = try JSONDecoder().decode(String.self, from: data)
                self?.delegate?.updtesJokes(joke: joke)
            }catch{
                self?.delegate?.showError(message: error.localizedDescription)
            }
        }.resume()
    }
}
