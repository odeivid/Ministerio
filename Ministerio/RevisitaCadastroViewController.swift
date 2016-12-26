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
    
    @IBOutlet weak var mapa: MKMapView!
    
    let revisitaNotasFonte = "RevisitaNotasFonte"
    var gerenciadorLocalizacao = CLLocationManager()
    var localizacaoBuscadaSimNao = false
    var latitude: Double = 0
    var longitude: Double = 0
    
    var revisita: Revisita!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alterarTamanhoFonteNotas(tamanho: self.recuperarTamanhoFonte())
        self.sldFonte.value = Float(self.recuperarTamanhoFonte())
        
        self.mapa.delegate = self
        MapaGerenciador().configuraGerenciadorLocalizacao(mapaDelegate: self, gerenciadorLocalizacao: gerenciadorLocalizacao)
        
        self.criarReconhecimentoGesto()
        
        //se é uma revisita carregada
        if revisita != nil{
            self.carregarRevisita(revisitaCarregar: revisita)
        }else{
            self.txtNome.becomeFirstResponder()
        }
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
        self.txtProximaVisita.text = FuncoesGerais().converterDataParaString(data: sender.date, style: .full)
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
        
        //centraliza
        MapaGerenciador().centralizarNaLocalizacao(gerenciadorLocalizacao: gerenciadorLocalizacao, mapa: self.mapa)
        
        //Verifica se ja foi busca a localização e se é um novo registro
        if self.localizacaoBuscadaSimNao == false && self.revisita == nil{
            
            let localizacaoUsuario = locations.last!
            
            //Endereço
            self.preencherEnderecoPorLocalizacao(localizacao: localizacaoUsuario)
            
        }else{
            //se é uma revista salva, adiciona a anotacao
            if revisita != nil && self.mapa.annotations.count == 0{
                self.mapa.addAnnotation(RevisitaAnotacao(revisita: revisita))
            }
            
            gerenciadorLocalizacao.stopUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //se for anotacao da localizacao do usuario, retorna nil para manter o icon padrao
        if annotation  is MKUserLocation{
            return nil
        }
        //reusa o pin
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        //se for estudo pinta de verde
        if revisita != nil{
            if revisita.estudoSimNao {
                pin.pinTintColor = FuncoesGerais().corRevisita
            }
        }
        pin.canShowCallout = true
        pin.isDraggable = true
        
        //if let logo = UIImage(named: "logo-apps-foundation-small.jpg") {
        //  pin.detailCalloutAccessoryView = UIImageView(image: logo)
        //}
        
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        switch newState {
        case .starting:
            print("starting")
        case .dragging:
            print("dragging")
        case .ending, .canceling:
            print("ending")
            self.latitude = (view.annotation?.coordinate.latitude)!
            self.longitude = (view.annotation?.coordinate.longitude)!
        default:
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        //regular o zoom para mostrar no mapa as annotacoes
        MapaGerenciador().zoomToFitMapAnnotations(aMapView: self.mapa)
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
        
        if txtNome.text == ""{
            let alerta = FuncoesGerais().mostrarAlertaSimples(titulo: "Preenchimento", mensagem: "O campo nome é obrigatório")
            present(alerta, animated: true, completion: nil)
            
            return
        }
        
        let dataProximaVista = FuncoesGerais().converterStringParaData(data: txtProximaVisita.text!) as NSDate?
        
        
        if revisita == nil{//Novo registro
            //Funcao que cria e salva revisita
            _ = CoreDataRevisita().criarObjetoRevisitaNoContexto(inserirNovoRegistroSimNao: true, latitude: self.latitude, longitude: self.longitude, bairro: self.txtBairro.text, cidade: self.txtCidadeEstado.text, endereco: self.txtEndereco.text, nome: self.txtNome.text!, notas: self.txtNotas.text, telefone: self.txtTelefone.text, territorio: self.txtTerritorio.text, ativoSimNao: true, estudoSimNao: self.swtEstudo.isOn, data: NSDate(), dataProximaVisita: dataProximaVista)
        }else{ //Atualizar
            CoreDataRevisita().atualizarObjetoRevisitaNoContexto(revisita: self.revisita, latitude: self.latitude, longitude: self.longitude, bairro: self.txtBairro.text, cidade: self.txtCidadeEstado.text, endereco: self.txtEndereco.text, nome: self.txtNome.text!, notas: self.txtNotas.text, telefone: self.txtTelefone.text, territorio: self.txtTerritorio.text, ativoSimNao: true, estudoSimNao: self.swtEstudo.isOn, data: NSDate(), dataProximaVisita: dataProximaVista)
        }
        
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
    
    @IBAction func centralizarLocalizacaoUsuario(_ sender: Any) {
        //muda o trankingMode
        MapaGerenciador().mudarTrackingMode(mapa: self.mapa)
    }
    
    
    /*
    @IBAction func mudarTipoMapa(_ sender: Any) {
        self.mapa.showsTraffic = false
        
        switch (sender as! UISegmentedControl).selectedSegmentIndex {
        case 0:
            self.mapa.mapType = .standard
        case 1:
            self.mapa.mapType = .standard
            self.mapa.showsTraffic = true
        default: // or case 2
            self.mapa.mapType = .hybrid
        }
    }*/
    
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
    
    
    func carregarRevisita(revisitaCarregar: Revisita) {
        
        self.txtNome.text = revisitaCarregar.nome
        self.txtEndereco.text = revisitaCarregar.endereco
        self.txtBairro.text = revisitaCarregar.bairro
        self.txtCidadeEstado.text = revisitaCarregar.cidade
        self.txtTerritorio.text = revisitaCarregar.territorio
        self.txtTelefone.text = revisitaCarregar.telefone
        
        self.swtEstudo.isOn = revisitaCarregar.estudoSimNao
        self.txtNotas.text = revisitaCarregar.notas
        self.latitude = revisitaCarregar.latitude
        self.longitude = revisitaCarregar.longitude
        
        if revisita.dataProximaVisita != nil{
            self.txtProximaVisita.text = FuncoesGerais().converterDataParaString(data: revisita.dataProximaVisita!, style: .full)
        }
    }
    
    func preencherEnderecoPorLocalizacao(localizacao: CLLocation) {
        
        CLGeocoder().reverseGeocodeLocation(localizacao) { (detalhesLocal, erro) in
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
                    /*var subThoroughfare = ""
                     if dadosLocal.thoroughfare != nil {
                     subThoroughfare = dadosLocal.subThoroughfare!
                     }*/
                    
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
                    
                    self.txtEndereco.text = thoroughfare + ", " //+ subThoroughfare
                    self.txtBairro.text = subLocality
                    self.txtCidadeEstado.text = locality + " / " + administrativeArea
                    
                    self.latitude = localizacao.coordinate.latitude
                    self.longitude = localizacao.coordinate.longitude
                    
                    print(self.mapa.annotations.count)
                    
                    if self.mapa.annotations.count == 1 {
                        if self.mapa.annotations[0] is MKUserLocation{
                            MapaGerenciador().criarAnotacao(mapa: self.mapa, titulo: thoroughfare, latitude: self.latitude, longitude: self.longitude)
                        }
                    }
                }
                
            }else{
                print("erro: " + (erro?.localizedDescription)!)
            }
        }
    }
    
    func criarReconhecimentoGesto() {
        
        //cria um reconhecedor de gesto e passa a funcao executado quando o gesto acontecer
        let reconhecedorGesto = UILongPressGestureRecognizer(target: self, action: #selector(RevisitaCadastroViewController.marcar(gesture:)))
        reconhecedorGesto.minimumPressDuration = 2 //duracao de tempo do gesto pressionado
        
        mapa.addGestureRecognizer(reconhecedorGesto) //atribui o gesto ao mapa
    }
    
    func marcar(gesture: UIGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.began{ //captura apenas o gesto qdo ele inicia
            
            //recuperar o ponto que foi clicado
            let pontoSelecionado = gesture.location(in: self.mapa) //pega o ponto selecionado dentro do mapa
            let coordenadas = mapa.convert(pontoSelecionado, toCoordinateFrom: self.mapa)
            
            print("gesto")
            let localizacao = CLLocation(latitude: coordenadas.latitude, longitude: coordenadas.longitude)
            
            //apagar anotacoes que nao sejam UserLocation
            var anotacoesRemover: [MKAnnotation] = []
            for var anotacao in self.mapa.annotations {
                if !(anotacao is MKUserLocation){
                    anotacoesRemover.append(anotacao)
                }
            }
            self.mapa.removeAnnotations(anotacoesRemover)
            
            self.preencherEnderecoPorLocalizacao(localizacao: localizacao)
            
        }
    }
    
    
    
}
