//
//  FuncoesGerais.swift
//  Ministerio
//
//  Created by DEIVID LOUREIRO on 20/12/16.
//  Copyright © 2016 DEIVID LOUREIRO. All rights reserved.
//

import UIKit

class FuncoesGerais {
    
    func converterDataParaString(data: Date) -> String {
        let formatterDate = DateFormatter()
        formatterDate.dateStyle = .full
        formatterDate.timeStyle = .short
        //coloca o mês com 3 letras
        formatterDate.dateFormat = formatterDate.dateFormat.replacingOccurrences(of: "MMMM", with: "MMM")
        return formatterDate.string(from: data)
        
        
        //converte a string em data
        //print(formatterDate.date(from: self.txtProximaVisita.text!) as Any)
    }
    
    func converterStringParaData(data: String) -> Date {
        let formatterDate = DateFormatter()
        formatterDate.dateStyle = .full
        formatterDate.timeStyle = .short
        //coloca o mês com 3 letras
        formatterDate.dateFormat = formatterDate.dateFormat.replacingOccurrences(of: "MMMM", with: "MMM")
        return formatterDate.date(from: data)!
        
    }
}
