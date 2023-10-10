//
//  ViewController.swift
//  Preco do bitcoin
//
//  Created by Enzo on 05/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var precoBitcoins: UILabel!
    
    
    @IBOutlet weak var botaoAtualizar: UIButton!
    
    
    @IBAction func atualizarPreco(_ sender: Any) {
        self.recuperarPrecoBitcoins()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.recuperarPrecoBitcoins()
    }
    
    func formatarPreco(preco: NSNumber ) -> String {
        
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_BR")
        
        if let precoFinal  = nf.string(from: preco)  {
            return precoFinal
        }
        
        
        return "0,00"
    }
    
    func recuperarPrecoBitcoins() {
        self.botaoAtualizar.setTitle("Atualizando..",  for:  .normal )
        if let url = URL(string: "https://blockchain.info/ticker") {
        
        let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
            if erro == nil {
                
                if let dadosRetorno = dados {
                    
                    
                    do {
                        
                        if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: Any] {
                            if let brl = objetoJson["BRL"] as? [String: Any] {
                                if let preco = brl["buy"] as? Double {
                                let precoFormatado = self.formatarPreco(preco: NSNumber(value: preco))
                                    DispatchQueue.main.async(execute: {
                                        self.precoBitcoins.text = "RS" + precoFormatado
                                        self.botaoAtualizar.setTitle("Atualizar",  for:  .normal )
                                        
                                    })
                                    
                                }
                       }
                            
                        }
                    }catch{
                        
                    }
                }
            print("Sucesso ao fazer a consulta do preco.")
            } else{
            print("Erro ao fazer   a consulta ddo preco.")
        }
                                                
        }
            tarefa.resume()
        }  /*fim IF*/

}
        
       
    }
    

