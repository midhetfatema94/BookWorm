//
//  ContentView.swift
//  BookWorm
//
//  Created by Waveline Media on 12/20/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: Student.entity(), sortDescriptors: []) var students: FetchedResults<Student>

    var body: some View {
        List {
            ForEach(students) { student in
                Text("Student: \(student.name ?? "Unknown")")
            }
        }
        
        Button("Add") {
            let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
            let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]

            let chosenFirstName = firstNames.randomElement()!
            let chosenLastName = lastNames.randomElement()!

            let student = Student(context: self.viewContext)
            student.id = UUID()
            student.name = "\(chosenFirstName) \(chosenLastName)"
            
            try? self.viewContext.save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
