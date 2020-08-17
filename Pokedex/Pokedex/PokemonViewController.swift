import UIKit

class PokemonViewController: UIViewController {
    var url: String!
    
    var isCaught = false
    var pokemonName = ""
    var pokemonID = 0

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var pokemonImage : UIImageView!
    @IBOutlet var pokemonDescription : UITextView!

    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""

        loadPokemon()
    }

    func loadPokemon() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)
                DispatchQueue.main.async {
                    self.navigationItem.title = self.capitalize(text: result.name)
                    self.nameLabel.text = self.capitalize(text: result.name)
                    self.numberLabel.text = String(format: "#%03d", result.id)
                    self.pokemonID = Int(result.id)
                    self.pokemonName = result.name
                    
                    if UserDefaults.standard.bool(forKey: self.pokemonName){
                        self.isCaught = true
                        self.catchButton.setTitle("Release", for: [])

                    }
                    else{
                        self.isCaught = false
                        self.catchButton.setTitle("Catch", for: [])
                    }
                    
                    
                    for typeEntry in result.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                }
                guard let imageURL = URL(string: result.sprites.front_default  ) else{
                    return
                }
                
                let imageData = try Data(contentsOf: imageURL)
                // UIImageView.image must be used from the main thread only
                DispatchQueue.main.async {
                    self.pokemonImage.image = UIImage(data: imageData)
                    
                }
                
                
                // Pokemon Description API call
                       
                       guard let descriptionURL = URL(string: String(format:"https://pokeapi.co/api/v2/pokemon-species/%d/", self.pokemonID)) else {
                           return
                       }
                       
                       URLSession.shared.dataTask(with: descriptionURL) { (data, response, error) in
                           guard let descriptionData = data else {
                               return
                           }
                           
                           do{
                               let description = try JSONDecoder().decode(PokemonDescription.self, from: descriptionData)
                            DispatchQueue.main.async {
                                self.pokemonDescription.text = description.flavor_text_entries[0].flavor_text
                            }
                                
                           } catch let error {
                               print(error)
                           }
                       }.resume()
                
                
            }
            catch let error {
                print(error)
            }
        }.resume()
        
       
    }
    
    @IBAction func toggleCatch()
    {
        isCaught = !isCaught
        
        UserDefaults.standard.set(isCaught, forKey:pokemonName)
        
        if UserDefaults.standard.bool(forKey:pokemonName){
            catchButton.setTitle("Release", for: [])
        }
        else{
            catchButton.setTitle("Catch", for: [])
        }
    }
}
