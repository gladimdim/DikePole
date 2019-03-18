export function getBooks() {
  return JSON.parse(localStorage.getItem("books")) || [];
}

export function addBook(book) {
  const currentBooks = getBooks();
  currentBooks.push(book);
  resetBooks(currentBooks);
  return getBooks();
}

export function resetBooks(books) {
  localStorage.setItem("books", JSON.stringify(books));
  return getBooks();
}

export function removeBookByIndex(index) {
  const books = getBooks();
  books.splice(index, 1);
  resetBooks(books);
  return getBooks();
}

export function serializeBook(book) {
  return JSON.stringify(book);
};

export function deserializeBook(input) {
  return JSON.parse(input);
}
