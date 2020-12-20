//
//  AddBookView.swift
//  BookWorm
//
//  Created by Waveline Media on 12/20/20.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) var presentationMode

    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    @State private var showingValidationAlert = false
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section {
                    RatingView(rating: $rating)

                    TextField("Write a review", text: $review)
                }

                Section {
                    Button("Save") {
                        if validateData() {
                            let newBook = Book(context: self.moc)
                            newBook.title = self.title
                            newBook.author = self.author
                            newBook.rating = Int16(self.rating)
                            newBook.genre = self.genre
                            newBook.review = self.review
                            newBook.date = Date()

                            try? self.moc.save()
                            
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            showingValidationAlert = true
                        }
                    }
                }
            }
            .navigationBarTitle("Add Book")
            .alert(isPresented: $showingValidationAlert) {
                Alert(title: Text("Validation Error"), message: Text("There are some fields missing in the book's data"), dismissButton: .default(Text("Okay")))
            }
        }
    }
    
    func validateData() -> Bool {
        if title.isEmpty ||
            author.isEmpty ||
            rating <= 0 ||
            genre.isEmpty ||
            review.isEmpty {
            return false
        }
        return true
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
