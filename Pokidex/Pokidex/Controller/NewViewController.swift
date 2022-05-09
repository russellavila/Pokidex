//
//  NewView.swift
//  Pokidex
//
//  Created by Consultant on 5/9/22.
//

import UIKit

class NewViewController: UIViewController {

    var indexInt: Int?
    var pokemonData: [BasicData] = []
    var networkManager = NetworkManager()
    
    lazy var pokeNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Some Name"
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.font = UIFont(name: "MegaMan-2", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    lazy var abilityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ability: " + "\n\n"
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.font = UIFont(name: "MegaMan-2", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var movesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Moves: \n\n"
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.font = UIFont(name: "MegaMan-2", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
        }()
    
    lazy var contentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        
        self.pokeNameLabel.text = pokemonData[indexInt ?? 0].name + "\n"
        
        networkManager.fetchPokemonInfo(urlPath: pokemonData[indexInt ?? 0].url) { result in
            switch result {
                case .success(let page):
                    DispatchQueue.main.async {
                        for i in 0 ..< page.abilities.count{
                            self.abilityLabel.text?.append(" " + page.abilities[i].ability.name + "\n\n")
                            
                        }
                        
                        for i in 0 ..< page.moves.count{
                            self.movesLabel.text?.append(" " + page.moves[i].move.name + "\n\n")
                            
                        }
                    }
                    
                case .failure(let err):
                    print("Error: \(err.localizedDescription)")
                    
                }
            }
        }
    
    private func setUpUI() {
        
        let vStack = UIStackView(frame: .zero)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.alignment = .center
        
        let topBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        let bottomBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        
        view.addSubview(scrollView)
                
        scrollView.addSubview(contentView)
                
        contentView.addSubview(vStack)
        vStack.addArrangedSubview(topBuffer)
        vStack.addArrangedSubview(self.pokeNameLabel)
        vStack.addArrangedSubview(self.abilityLabel)
        vStack.addArrangedSubview(self.movesLabel)
        vStack.addArrangedSubview(bottomBuffer)
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
                
        topBuffer.heightAnchor.constraint(equalTo: bottomBuffer.heightAnchor).isActive = true
        
    }
}
            

   

   

