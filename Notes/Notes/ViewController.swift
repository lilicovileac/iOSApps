//
//  ViewController.swift
//  Notes
//
//  Created by Liliana Covileac on 05/08/2020.
//  Copyright © 2020 Liliana Covileac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var notes : [Note] = []
    
    @IBAction func createNote(){
        let _ = NoteManager.main.create()
        reload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].contents
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NoteSegue"{
            if let destination = segue.destination as? NoteViewController {
                destination.note = notes[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    // swipe to DELETE
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete", handler: {(action, swipeButtonView, completion) in
            NoteManager.main.delete(note: self.notes[indexPath.row])
            self.reload()
            completion(true)
        })])
    }
    
    func reload()
    {
        notes = NoteManager.main.getAllNotes()
        self.tableView.reloadData()
    }
    
}

