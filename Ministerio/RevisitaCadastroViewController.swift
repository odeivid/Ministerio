//
//  RevisitaCadastroViewController.swift
//  Ministerio
//
//  Created by DEIVID LOUREIRO on 15/12/16.
//  Copyright © 2016 DEIVID LOUREIRO. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class RevisitaCadastroViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtEndereco: UITextField!
    @IBOutlet weak var txtBairro: UITextField!
    @IBOutlet weak var txtCidadeEstado: UITextField!
    @IBOutlet weak var txtTerritorio: UITextField!
    @IBOutlet weak var txtTelefone: UITextField!
    @IBOutlet weak var txtProximaVisita: UITextField!
    @IBOutlet weak var swtEstudo: UISwitch!
    @IBOutlet weak var txtNotas: UITextView!
    @IBOutlet weak var sldFonte: UISlider!
    
    let revisitaNotasFonte = "RevisitaNotasFonte"
    var gerenciadorLocalizacao = CLLocationManager()
    var localizacaoBuscadaSimNao = false
    var latitude: Double = 0
    var longitude: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.alterarTamanhoFonteNotas(tamanho: self.recuperarTamanhoFonte())
        self.sldFonte.value = Float(self.recuperarTamanhoFonte())

        MapaGerenciador().configuraGerenciadorLocalizacao(mapaDelegate: self, gerenciadorLocalizacao: gerenciadorLocalizacao)
        
      /*  let coreData = CoreDataRevisita()
        
        let revisita = coreData.getRevisitas(ativoSimNao: true)[0]
        
        print(revisita.ativoSimNao as Any)
        */
        
        //if ==novo registo
        //self.txtNome.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //Coloca o DatePicker para seleciona a data e horário
        if textField == self.txtProximaVisita{
            let datePicker = UIDatePicker()
            datePicker.minuteInterval = 5
            self.txtProximaVisita.inputView = datePicker
            datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
        }
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        //converte a data em string
        let formatterDate = DateFormatter()
        formatterDate.dateStyle = .full
        formatterDate.timeStyle = .short
        //coloca o mês com 3 letras
        formatterDate.dateFormat = formatterDate.dateFormat.replacingOccurrences(of: "MMMM", with: "MMM")
        self.txtProximaVisita.text = formatterDate.string(from: sender.date)
        
        //converte a string em data
        //print(formatterDate.date(from: self.txtProximaVisita.text!) as Any)
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //verifica se app tem permissao de localizacao
        let alerta = MapaGerenciador().solicitarPermissaoLocalizacaoUsuario(manager: manager, status: status)
        if alerta != nil{
            present(alerta!, animated: true, completion: nil)
        }
        
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
                        
                        self.latitude = localizacaoUsuario.coordinate.latitude
                        self.longitude = localizacaoUsuario.coordinate.longitude
                        
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

    @IBAction func salvar(_ sender: Any) {
        
        let coreDataRevisita = CoreDataRevisita()
        
        let revisita = Revisita(context: coreDataRevisita.getContext())

        revisita.nome = self.txtNome.text
        revisita.endereco = self.txtEndereco.text
        revisita.bairro = self.txtBairro.text
        revisita.cidade = self.txtCidadeEstado.text
        revisita.territorio = self.txtTerritorio.text
        revisita.telefone = self.txtTelefone.text
        revisita.data = NSDate()
        revisita.estudoSimNao = self.swtEstudo.isOn
        revisita.notas = self.txtNotas.text
        revisita.latitude = self.latitude
        revisita.longitude = self.longitude
        
        coreDataRevisita.salvarRevisita(revisita: revisita)
        
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
