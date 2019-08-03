//
//  NoteListViewController.swift
//  Notes
//
//  Created by user on 20.07.2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit


class NoteListViewController: UIViewController {

    @IBOutlet weak var notesTable: UITableView!
    var selectedNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notesTable.register(UINib(nibName: "NoteViewCell", bundle: nil),
                           forCellReuseIdentifier: "note")
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    @IBAction func addNote(_ sender: UIButton) {
        selectedNote = nil
        performSegue(withIdentifier: "GoToNote", sender: self)
    }
    
    
    @IBAction func editNote(_ sender: UIButton) {
        notesTable.isEditing = !notesTable.isEditing
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let loadNotesOperation = LoadNotesOperation(
            notebook: notebook,
            backendQueue: backendQueue,
            dbQueue: dbQueue
        )
        commonQueue.addOperation(loadNotesOperation)
        // необходимо реализовать индикатор загрузки
        let updateUI = BlockOperation {
            self.notesTable.reloadData()
        }
        OperationQueue.main.addOperation(updateUI)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? NoteViewController {
            controller.editingNote = selectedNote
        }
    }
    
}

extension NoteListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return notebook.getNotes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath) as! NoteViewCell
        let note = notebook.getNotes[indexPath.section]
        cell.noteTitleLabel?.text = note.title
        cell.noteTextLabel?.text = note.content
        cell.noteColor.backgroundColor = note.color
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            
            let removeOperation = RemoveNoteOperation(note: notebook.getNotes[indexPath.section],
                                                      notebook: notebook,
                                                      backendQueue: backendQueue,
                                                      dbQueue: dbQueue)
            commonQueue.addOperation(removeOperation)
            // необходимо реализовать индикатор загрузки
            let updateUI = BlockOperation {
                self.notesTable.reloadData()
            }
            OperationQueue.main.addOperation(updateUI)
            
//            notebook.remove(with: note.uid)
//            notesTable.reloadData()
        }
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNote = notebook.notes[indexPath.section]
        performSegue(withIdentifier: "GoToNote", sender: self)
    }
}
