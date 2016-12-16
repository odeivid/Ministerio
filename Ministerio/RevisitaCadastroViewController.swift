//
//  RevisitaCadastroViewController.swift
//  Ministerio
//
//  Created by DEIVID LOUREIRO on 15/12/16.
//  Copyright © 2016 DEIVID LOUREIRO. All rights reserved.
//

import UIKit

class RevisitaCadastroViewController: UIViewController {

    @IBOutlet weak var txtNotas: UITextView!
    @IBOutlet weak var sldFonte: UISlider!
    
    let revisitaNotasFonte = "RevisitaNotasFonte"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.alterarTamanhoFonteNotas(tamanho: self.recuperarTamanhoFonte())
        self.sldFonte.value = Float(self.recuperarTamanhoFonte())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: ACTIONS
    @IBAction func cancelar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func alterarFonteNotas(_ sender: Any) {
        let size = CGFloat(sldFonte.value)
        self.alterarTamanhoFonteNotas(tamanho: size)
        self.salvarTamanhoFonte(tamanho: size)
    }
    
    //MARK: FUNCOES
    
    func salvarTamanhoFonte(tamanho: CGFloat) {
        UserDefaults.standard.set(tamanho, forKey: self.revisitaNotasFonte)
    }
    
    func recuperarTamanhoFonte() -> CGFloat{
        if let tamanhoRecuperado = UserDefaults.standard.object(forKey: self.revisitaNotasFonte){
            return tamanhoRecuperado as! CGFloat
        }else{
            self.salvarTamanhoFonte(tamanho: 14)
            return 14
        }
    }
    
    func alterarTamanhoFonteNotas(tamanho: CGFloat) {
        txtNotas.font = UIFont(name: (txtNotas.font?.fontName)!, size: tamanho)
    }
}