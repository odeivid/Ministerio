//
//  RevisitaCadastroViewController.swift
//  Ministerio
//
//  Created by DEIVID LOUREIRO on 15/12/16.
//  Copyright © 2016 DEIVID LOUREIRO. All rights reserved.
//

import UIKit
import MapKit

class RevisitaCadastroViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtEndereco: UITextField!
    @IBOutlet weak var txtBairro: UITextField!
    @IBOutlet weak var txtCidadeEstado: UITextField!
    @IBOutlet weak var txtTerritorio: UITextField!
    @IBOutlet weak var txtTelefone: UITextField!
    @IBOutlet weak var txtProximaVisita: UITextField!
    @IBOutlet weak var txtNotas: UITextView!
    @IBOutlet weak var sldFonte: UISlider!
    
    let revisitaNotasFonte = "RevisitaNotasFonte"
    var gerenciadorLocalizacao = CLLocationManager()
    var localizacaoBuscadaSimNao = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.alterarTamanhoFonteNotas(tamanho: self.recuperarTamanhoFonte())
        self.sldFonte.value = Float(self.recuperarTamanhoFonte())

        self.configuraGerenciadorLocalizacao()
        
        //if ==novo registo
        //self.txtNome.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtNome{
            self.txtEndereco.becomeFirstResponder()
        }else if textField == self.txtEndereco{
            self.txtBairro.becomeFirstResponder()
        }else if textField == self.txtBairro{
            self.txtCidadeEstado.becomeFirstResponder()
        }else if textField == self.txtCidadeEstado{
            self.txtTerritorio.becomeFirstResponder()
        }else if textField == self.txtTerritorio{
            self.txtTelefone.becomeFirstResponder()
        }else if textField == self.txtTelefone{
            self.txtProximaVisita.becomeFirstResponder()
        }else if textField == self.txtProximaVisita{
            self.txtNotas.becomeFirstResponder()
        }
        else{
            self.txtEndereco.resignFirstResponder()
        }
        
        return true

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Verifica se ja foi busca a localização e se é um novo registro
        if self.localizacaoBuscadaSimNao == false{
            
            let localizacaoUsuario = locations.last!
            
            //Endereço
            CLGeocoder().reverseGeocodeLocation(localizacaoUsuario) { (detalhesLocal, erro) in
                if erro == nil{
                    
                    //marca variavel = true para nao buscar novamente
                    self.localizacaoBuscadaSimNao = true
                    
                    if let dadosLocal = detalhesLocal?.first{
                        
                        //rua
                        var thoroughfare = ""
                        if dadosLocal.thoroughfare != nil {
                            thoroughfare = dadosLocal.thoroughfare!
                        }
                        
                        //numero
                        var subThoroughfare = ""
                        if dadosLocal.thoroughfare != nil {
                            subThoroughfare = dadosLocal.subThoroughfare!
                        }
                        
                        //bairro
                        var subLocality = ""
                        if dadosLocal.subLocality != nil {
                            subLocality = dadosLocal.subLocality!
                        }
                        
                        //cidade
                        var locality = ""
                        if dadosLocal.locality != nil {
                            locality = dadosLocal.locality!
                        }
                        
                        //estado
                        var administrativeArea = ""
                        if dadosLocal.administrativeArea != nil {
                            administrativeArea = dadosLocal.administrativeArea!
                        }
                        
                        self.txtEndereco.text = thoroughfare + ", " + subThoroughfare
                        self.txtBairro.text = subLocality
                        self.txtCidadeEstado.text = locality + " / " + administrativeArea
                        
                    }
                    
                }else{
                    print("erro")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: ACTIONS
    
    @IBAction func cancelar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

 
    @IBAction func fazerLigacao(_ sender: Any) {
        if txtTelefone.text != nil {
            if let phoneURL = NSURL(string: "tel:" + txtTelefone.text!) {
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(phoneURL as URL)
                }
            }
        }
    }
    
    @IBAction func alterarFonteNotas(_ sender: Any) {
        let size = CGFloat(sldFonte.value)
        self.alterarTamanhoFonteNotas(tamanho: size)
        self.salvarTamanhoFonte(tamanho: size)
    }
    
    
    //MARK: METODOS
    
    func configuraGerenciadorLocalizacao() {
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
    }
    
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
