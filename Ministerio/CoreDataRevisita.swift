//
//  CoreDataRevisita.swift
//  Ministerio
//
//  Created by DEIVID LOUREIRO on 20/12/16.
//  Copyright © 2016 DEIVID LOUREIRO. All rights reserved.
//

import UIKit
import CoreData

class CoreDataRevisita {
    
    //recuperar contexto
    func getContext() -> NSManagedObjectContext{
        return ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
    }
    
    func getRevisitas(ativoSimNao: Bool) -> [Revisita] {
        
        do{
            let requisicao = Revisita.fetchRequest() as NSFetchRequest<Revisita>
            requisicao.predicate = NSPredicate(format: "ativoSimNao = %@", ativoSimNao as CVarArg)
            return try self.getContext().fetch(requisicao) as [Revisita]
        }catch{
            return []
        }
    }
    
    func salvarRevisita(revisita: Revisita) {
        do{
            let contexto = self.getContext()
            
            contexto.insert(revisita as NSManagedObject)
            
            try contexto.save()
            
        }catch{
            
        }
    }
    
    func criarObjetoRevisitaNoContexto(inserirNovoRegistroSimNao: Bool, latitude: Double!, longitude:Double!, bairro: String!, cidade: String!, endereco: String!, nome: String, notas: String!, telefone: String!, territorio: String!, ativoSimNao: Bool, estudoSimNao: Bool, data: NSDate, dataProximaVisita: NSDate!) -> Revisita {
        
        let revisita = Revisita(context: getContext())

        revisita.nome = nome
        revisita.endereco = endereco
        revisita.bairro = bairro
        revisita.cidade = cidade
        revisita.territorio = territorio
        revisita.telefone = telefone
        revisita.data = data
        revisita.dataProximaVisita = dataProximaVisita
        revisita.estudoSimNao = estudoSimNao
        revisita.notas = notas
        revisita.latitude = latitude
        revisita.longitude = longitude
        
        if inserirNovoRegistroSimNao == true{
            self.salvarRevisita(revisita: revisita)
        }
        
        return revisita
    }
    
    func atualizarObjetoRevisitaNoContexto(revisita: Revisita, latitude: Double!, longitude:Double!, bairro: String!, cidade: String!, endereco: String!, nome: String, notas: String!, telefone: String!, territorio: String!, ativoSimNao: Bool, estudoSimNao: Bool, data: NSDate, dataProximaVisita: NSDate!) {
        
        revisita.nome = nome
        revisita.endereco = endereco
        revisita.bairro = bairro
        revisita.cidade = cidade
        revisita.territorio = territorio
        revisita.telefone = telefone
        revisita.data = data
        revisita.dataProximaVisita = dataProximaVisita
        revisita.estudoSimNao = estudoSimNao
        revisita.notas = notas
        revisita.latitude = latitude
        revisita.longitude = longitude
        
        do{
            try getContext().save()
        }catch{
            print("erro ao atualizar revisita")
        }
    }
    
    func removerRevisita(revisita: Revisita) {
        do{
            let contexto = self.getContext()
            
            contexto.delete(revisita as NSManagedObject)
            
            try contexto.save()
            
        }catch{
            
        }
    }
    
    func inativarRevisita(revisita: Revisita) {
        
        revisita.ativoSimNao = false
        
        do{
            try getContext().save()
        }catch{
            print("erro ao atualizar revisita")
        }
    }
}
