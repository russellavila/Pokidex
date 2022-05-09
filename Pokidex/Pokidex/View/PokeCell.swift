//
//  PokeCell.swift
//  Pokidex
//
//  Created by Consultant on 5/4/22.
//

import UIKit

class PokeCell: UITableViewCell {

    static let reuseId = "\(PokeCell.self)"
    
    var imageURL : String?
    
    lazy var pokeNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Some Name"
        label.numberOfLines = 0
        label.backgroundColor = .white
        return label
    }()
    
    lazy var elementLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Element: "
        label.numberOfLines = 0
        label.backgroundColor = .white
        return label
    }()
    
    lazy var pokeImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    var networkManager = NetworkManager()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        self.contentView.backgroundColor = .white
        
        self.contentView.addSubview(self.pokeImageView)
        
        let vStackLeft = UIStackView(frame: .zero)
        vStackLeft.translatesAutoresizingMaskIntoConstraints = false
        vStackLeft.axis = .vertical
        vStackLeft.spacing = 8
        
        let topBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        let bottomBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)

        vStackLeft.addArrangedSubview(topBuffer)
        vStackLeft.addArrangedSubview(self.pokeNameLabel)
        vStackLeft.addArrangedSubview(self.pokeImageView)
        vStackLeft.addArrangedSubview(bottomBuffer)
        
        let vStackRight = UIStackView(frame: .zero)
        vStackRight.translatesAutoresizingMaskIntoConstraints = false
        vStackRight.axis = .vertical
        vStackRight.spacing = 8
        
        vStackRight.addArrangedSubview(self.elementLabel)
        
        let hStack = UIStackView(frame: .zero)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.spacing = 8
        
        hStack.addArrangedSubview(vStackLeft)
        hStack.addArrangedSubview(vStackRight)
        
        self.contentView.addSubview(hStack)
        
        hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        hStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true

        self.pokeImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.pokeImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        topBuffer.heightAnchor.constraint(equalTo: bottomBuffer.heightAnchor).isActive = true
        
    }
    
    func configure(index: Int, result: BasicData) {
        self.reset()
        self.pokeNameLabel.text = result.name
        
        networkManager.fetchPokemonInfo(urlPath: result.url) { result in
            switch result {
            case .success(let page):
                DispatchQueue.main.async {
                    for i in 0 ..< page.types.count{
                        self.elementLabel.text?.append(" " + page.types[i].type.name)
                        
                    }
                    
                    if (page.types[0].type.name == "grass"){
                        self.backgroundView = UIImageView(image: UIImage(named: "grass"))
                    }
                    
                    if (page.types[0].type.name == "bug"){
                        self.backgroundView = UIImageView(image: UIImage(named: "bug"))
                        //self.backgroundColor = .yellow
                    }
                    
                    if (page.types[0].type.name == "electric"){
                        self.backgroundView = UIImageView(image: UIImage(named: "electric"))
                    }
                    
                    if (page.types[0].type.name == "fire"){
                        self.backgroundView = UIImageView(image: UIImage(named: "fire"))
                    }
                    
                    if (page.types[0].type.name == "water"){
                        self.backgroundView = UIImageView(image: UIImage(named: "water"))
                    }
                    
                    if (page.types[0].type.name == "normal"){
                        self.backgroundView = UIImageView(image: UIImage(named: "normal"))
                    }
                    
                    if (page.types[0].type.name == "poison"){
                        self.backgroundView = UIImageView(image: UIImage(named: "poison"))
                    }
                    
                    if (page.types[0].type.name == "psychic"){
                        self.backgroundView = UIImageView(image: UIImage(named: "psychic"))
                    }
                    
                    if (page.types[0].type.name == "fairy"){
                        self.backgroundView = UIImageView(image: UIImage(named: "fairy"))
                    }
                    
                    if (page.types[0].type.name == "fighting"){
                        self.backgroundView = UIImageView(image: UIImage(named: "fighting"))
                    }
                    
                    if (page.types[0].type.name == "rock"){
                        self.backgroundView = UIImageView(image: UIImage(named: "rock"))
                    }
                    
                    if (page.types[0].type.name == "ground"){
                        self.backgroundView = UIImageView(image: UIImage(named: "ground"))
                    }
                    
                    if (page.types[0].type.name == "ghost"){
                        self.backgroundView = UIImageView(image: UIImage(named: "ghost"))
                    }
                    
                    self.imageURL = page.sprites.front_default
                    
                    if let imageData = ImageCache.shared.getImageData(key: self.imageURL ?? "") {
                        print("Point: ImageCache Data")
                        self.pokeImageView.image = UIImage(data: imageData)
                        return
                    }
                    
                    self.networkManager.fetchImageData(imagePath: page.sprites.front_default ?? " ", completion: { result in
                        switch result {
                        case .success(let imageData):
                            
                            ImageCache.shared.setImageData(key: page.sprites.front_default ?? "", data: imageData)
                            
                            DispatchQueue.main.async {
                                self.pokeImageView.image = UIImage(data: imageData)
                            }
                        case .failure(let err):
                            print(err)
                        }
                    })
                }
            case .failure(let err):
                print("Error: \(err.localizedDescription)")
                
            }
        }
        
    }
    
    private func reset() {
        self.pokeNameLabel.text = "undefined"
        self.elementLabel.text = "Element: "
        self.pokeImageView.image = nil
        self.contentView.backgroundColor = .clear
        self.backgroundView = nil
    }
}
