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
        return label
    }()
    
    lazy var abilityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ability: " + "\n"
        label.numberOfLines = 0
        label.backgroundColor = .white
        return label
    }()
    
    lazy var movesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Moves: " + "\n"
        label.numberOfLines = 0
        label.backgroundColor = .white
        return label
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        
        self.pokeNameLabel.text = pokemonData[indexInt ?? 0].name
        
        networkManager.fetchPokemonInfo(urlPath: pokemonData[indexInt ?? 0].url) { result in
            switch result {
                case .success(let page):
                    DispatchQueue.main.async {
                        for i in 0 ..< page.abilities.count{
                            self.abilityLabel.text?.append(" " + page.abilities[i].ability.name + "\n")
                            
                        }
                        
                        for i in 0 ..< page.moves.count{
                            self.movesLabel.text?.append(" " + page.moves[i].move.name + "\n")
                            
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
        
        let topBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        let bottomBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)

        vStack.addArrangedSubview(topBuffer)
        vStack.addArrangedSubview(self.pokeNameLabel)
        vStack.addArrangedSubview(self.abilityLabel)
        vStack.addArrangedSubview(self.movesLabel)
        vStack.addArrangedSubview(bottomBuffer)
        
        self.view.addSubview(vStack)
       
       
        
        vStack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
        vStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        vStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
        vStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true

        
        topBuffer.heightAnchor.constraint(equalTo: bottomBuffer.heightAnchor).isActive = true
        
    }
}
            

   

   

