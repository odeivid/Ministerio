//
//  RevistasListagemTableViewController.swift
//  Ministerio
//
//  Created by DEIVID LOUREIRO on 20/12/16.
//  Copyright © 2016 DEIVID LOUREIRO. All rights reserved.
//

import UIKit

class RevistasListagemTableViewController: UITableViewController, UISearchResultsUpdating {

    let segueRevisitaNome = "verRevisita"
    var revisitas: [Revisita] = []
    var revisitasFiltradas: [Revisita] = []
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.carregarRevisitas()
        
        //set up searchbar
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchResultsUpdater = self
        searchController.disablesAutomaticKeyboardDismissal = false
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.carregarTabela()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return revisitasFiltradas.count
        }else{
            return revisitas.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)

        if searchController.isActive && searchController.searchBar.text != "" {
            cell.textLabel?.text = revisitasFiltradas[indexPath.row].nome
        }else{
            cell.textLabel?.text = revisitas[indexPath.row].nome
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //abre uma segue com um identificador, por código
        performSegue(withIdentifier: segueRevisitaNome, sender: indexPath.row)
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let revisita = self.revisitas[indexPath.row]
            
            CoreDataRevisita().removerRevisita(revisita: revisita)
            
            self.carregarTabela()
        }
    }
    
    //essa funcao precisa existir para nao dar erro ao herdar
    func updateSearchResults(for searchController: UISearchController) {
        revisitasFiltradas.removeAll(keepingCapacity: false)
        
        //filter
        revisitasFiltradas = revisitas.filter{
            item in
            (item.nome?.lowercased().contains(searchController.searchBar.text!.lowercased()))!
        }
        
        tableView.reloadData()
        
    }

    // MARK: - Navigation
    //metodo sempre executado qdo for abrir uma segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueRevisitaNome{
            let revisitaViewController = segue.destination as! RevisitaCadastroViewController
            
            //verifica se o sender é um inteiro. Se for é porque foi chamado ao selecionar um índice
            if let indiceSelecionado = sender as? Int{
                revisitaViewController.revisita = revisitas[indiceSelecionado]
            }else{
                revisitaViewController.revisita =  nil;
            }
        }
        
    }
    
    // MARK: - METODOS
    func carregarRevisitas() {
        revisitas = CoreDataRevisita().getRevisitas(ativoSimNao: true)
    }
    
    func carregarTabela() {
        self.revisitas = CoreDataRevisita().getRevisitas(ativoSimNao: true)
        tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


}
