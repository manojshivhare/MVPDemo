//
//  ViewController.swift
//  MVP-Demo
//
//  Created by Manoj Shivhare on 23/09/23.
//

import UIKit

class ViewController: UIViewController {
    
    private var jokesArr = [String]()
    private var timer = Timer()
    
    private let jokeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let presenter = JokesPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add tablview into view
        view.addSubview(jokeTableView)
        jokeTableView.frame = view.frame
        jokeTableView.dataSource = self
        
        //loacl data
        fetchLocalSavedData()
        
        //setup presenter
        presenter.setViewDelegate(delegate: self)
        
        //setup timer
        scheduledTimerWithTimeInterval()
    }
    
    deinit {
      NotificationCenter.default.removeObserver(self)
    }
    
    private func fetchLocalSavedData(){
        if let dataArr = UserDefaults.standard.value(forKey: "jokes") as? [String] {
            jokesArr = dataArr
            jokeTableView.reloadData()
        }
    }
    
    private func scheduledTimerWithTimeInterval(){
        //Timer schedule for every one minute
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(callApi), userInfo: nil, repeats: true)
    }
    
    @objc private func callApi(){
        presenter.getJokes()
    }
    
    private func saveData() {
        UserDefaults.standard.set(jokesArr, forKey: "jokes")
    }
}

extension ViewController: JokesPresenterDelegate{
    func updtesJokes(joke: String) {
        if jokesArr.count == 10{
            jokesArr.removeAll()
        }
        
        DispatchQueue.main.async {[weak self] in
            self?.jokesArr.append(joke)
            self?.jokeTableView.reloadData()
            self?.saveData()
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = jokesArr[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

