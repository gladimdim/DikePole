import React, { useState, useEffect } from 'react';
import Dialog from '@material-ui/core/Dialog';
import Button from '@material-ui/core/Button';
import DialogTitle from '@material-ui/core/DialogTitle';
import DialogContent from '@material-ui/core/DialogContent';
import DialogActions from '@material-ui/core/DialogActions';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';

export function SavedGamesView(props) {
  const [games, updateGames] = useState([]);
  useEffect(() => {
    let store = window.localStorage.getItem("savedGames");
    if (store !== null) {
        store = JSON.parse(store);
        updateGames(store);
    }
  });

  return (
      <Dialog open={props.open}>
          <DialogTitle>Список збережених ігор</DialogTitle>
          <DialogContent>
              <List>
                  {
                      games.map((game, i) =>
                        <ListItem key={i} button onClick={() => {
                          props.onGameSelected(localStorage.getItem(games[i].name));
                        }}>{game.name}</ListItem>)
                  }
              </List>
          </DialogContent>
          <DialogActions>
              <Button onClick={props.onCancel}>Скасувати</Button>
          </DialogActions>
      </Dialog>

  );
}

/*
window.localStorage.setItem("savedGames", JSON.stringify([{"name": "123"}, {"name": "1000"}]))
*/