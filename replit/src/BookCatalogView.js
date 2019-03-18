import React, { useState, useEffect } from 'react';

import Dialog from '@material-ui/core/Dialog';
import Button from '@material-ui/core/Button';
import DialogTitle from '@material-ui/core/DialogTitle';
import DialogContent from '@material-ui/core/DialogContent';
import DialogActions from '@material-ui/core/DialogActions';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import DeleteIcon from '@material-ui/icons/Delete';
import ListItemSecondaryAction from '@material-ui/core/ListItemSecondaryAction';
import IconButton from '@material-ui/core/IconButton';

import { getBooks, addBook, removeBookByIndex } from './models/BooksModel';

async function downloadBook(serverBook) {
  const url = serverBook.url;
  const content = await fetch(url).then(response => response.text());
  addBook({name: serverBook.name, content});
}

export function BookCatalogView(props) {
  let [books, updateBooks] = useState([]);
  let [serverBooks, updateServerBooks] = useState([]);

  useEffect(() => {
    const localBooks = getBooks();
    updateBooks(localBooks);
  });

  useEffect(() => {
    async function loadServerBooks() {
      const result = await fetch("catalog.json").then((response => response.json()));
      updateServerBooks(result);
    }
    loadServerBooks();
  }, [])

  async function downloadBookAndUpdate(book) {
    await downloadBook(book);
    updateBooks(getBooks());
  }

  function removeLoadedBook(index) {
    const updatedBooks = removeBookByIndex(index);
    updateBooks(updatedBooks);
  }

  return (
    <Dialog open={props.open}>
      <DialogTitle>Вибір книги для початку або для завантаження</DialogTitle>
      <DialogContent>
        Завантажені книги:
        <List>
          {
            books.map((book, i) =>
            <ListItem key={i} button onClick={() => {
              props.onSelected(book)
            }}>
              {book.name}
               <ListItemSecondaryAction>
                  <IconButton aria-label="Delete" onClick={() => removeLoadedBook(i)}>
                  <DeleteIcon />
                </IconButton>
              </ListItemSecondaryAction>
            </ListItem> )
          }
        </List>
        Скачати книгу:
        <List>
          {
            serverBooks.map((book, i) =>
              <ListItem key={i} button onClick={
                () => downloadBookAndUpdate(book)}>{book.name}
              </ListItem>)
          }
        </List>
      </DialogContent>
      <DialogActions>
        <Button onClick={() => { props.onClose() }}>Скасувати</Button>
      </DialogActions>
    </Dialog>
  );
}