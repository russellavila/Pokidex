//
//  MainViewController.swift
//  Pokidex
//
//  Created by Consultant on 5/4/22.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var mainTableView: UITableView = {
        let tableview = UITableView(frame: .zero)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.dataSource = self
        tableview.delegate = self
        tableview.prefetchDataSource = self
        tableview.backgroundColor = .magenta
        tableview.register(PokeCell.self, forCellReuseIdentifier: PokeCell.reuseId)
        return tableview
    }()
    
    var nextOffset = 0
    let networkManager = NetworkManager()
    var pages: [BasicData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.fetchPokemonPage()
    }

    private func setUpUI() {
        self.view.backgroundColor = .black
        self.view.addSubview(self.mainTableView)
        
        self.mainTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.mainTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.mainTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        self.mainTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }
    
    func fetchPokemonPage() {
        self.networkManager.fetchPokemon(offset: self.nextOffset) { [self] result in
            switch result {
            case .success(let page):
                if (self.nextOffset < 150){
                    self.pages.append(contentsOf: page.results)
                }
                
                if (self.nextOffset >= 150){
                    self.pages.append(contentsOf: page.results)
                    self.pages.removeSubrange(151...self.pages.count - 1)
                }
                print("fetch up to " + pages[pages.count - 1].name + " " + pages[pages.count - 1].url)
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
            case .failure(let err):
                print("Error: \(err.localizedDescription)")
                self.presentErrorAlert(title: "NetworkError", message: err.localizedDescription)
            }
        }
    }

}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokeCell.reuseId, for: indexPath) as? PokeCell else {
            return UITableViewCell()
        }
        
        cell.configure(index: indexPath.row, result: self.pages[indexPath.row])
        return cell
    }
}

extension MainViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        let lastIndexPath = IndexPath(row: self.pages.count - 1, section: 0)
        guard indexPaths.contains(lastIndexPath) else { return }
        
        if (self.nextOffset < 150){
            self.nextOffset += 30
            self.fetchPokemonPage()
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "NewViewController") as? NewViewController else { return }
        vc.pokemonData = pages
        vc.indexInt = mainTableView.indexPathForSelectedRow?.row
        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
}

