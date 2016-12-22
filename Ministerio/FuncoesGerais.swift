//
//  FuncoesGerais.swift
//  Ministerio
//
//  Created by DEIVID LOUREIRO on 20/12/16.
//  Copyright © 2016 DEIVID LOUREIRO. All rights reserved.
//

import UIKit

class FuncoesGerais {
    
    var corRevisita = UIColor(colorLiteralRed: (111/255.0), green: (216/255.0), blue: (101/255.0), alpha: 1.0)
    
    func converterDataParaString(data: Date!) -> String {
        
        if data == nil{
            return ""
        }
        let formatterDate = DateFormatter()
        formatterDate.dateStyle = .full
        formatterDate.timeStyle = .short
        //coloca o mês com 3 letras
        formatterDate.dateFormat = formatterDate.dateFormat.replacingOccurrences(of: "MMMM", with: "MMM")
        return formatterDate.string(from: data)
        
        
        //converte a string em data
        //print(formatterDate.date(from: self.txtProximaVisita.text!) as Any)
    }
    
    func converterDataParaString(data: NSDate!) -> String{
        if data == nil{
            return ""
        }
        
        return self.converterDataParaString(data: data as Date)
    }
    
    func converterStringParaData(data: String!) -> Date! {
        
        if data == nil || data == ""{
            return nil
        }
        
        let formatterDate = DateFormatter()
        formatterDate.dateStyle = .full
        formatterDate.timeStyle = .short
        //coloca o mês com 3 letras
        formatterDate.dateFormat = formatterDate.dateFormat.replacingOccurrences(of: "MMMM", with: "MMM")
        return formatterDate.date(from: data)!
        
    }
    
    func mostrarAlertaSimples(titulo: String, mensagem: String) -> UIAlertController {
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        
        let acaoOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alerta.addAction(acaoOK)
        
        return alerta
    }
}
