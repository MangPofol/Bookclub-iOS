//
//  BookOptionSelectViewModel.swift
//  BookClub_iOS
//
//  Created by Lee Nam Jun on 2021/09/29.
//

import Foundation
import RxSwift
import RxCocoa

class BookOptionSelectViewModel {
    var isAddingBook: Observable<(BookListType, BookModel)?>
    var categorySelected = BehaviorSubject<BookListType>(value: .NOW)
    
    var selectedBook: Book
    
    init(addButtonTapped: Signal<()>, selectedBook: Book) {
        self.selectedBook = selectedBook
        isAddingBook = addButtonTapped
            .asObservable()
            .withLatestFrom(categorySelected)
            .flatMap { type -> Observable<(BookListType, BookModel)?> in
                let book = BookToCreate(name: selectedBook.bookModel.name, isbn: selectedBook.bookModel.isbn, category: type.rawValue)
                return BookServices.createBook(bookToCreate: book).map { value -> (BookListType, BookModel)? in
                    if value != nil {
                        return (type, value!)
                    } else {
                        return nil
                    }
                }
            }
    }
}
