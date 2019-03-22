import React, { useState } from 'react';
import Dialog from '@material-ui/core/Dialog';
import Button from '@material-ui/core/Button';
import DialogTitle from '@material-ui/core/DialogTitle';
import DialogContent from '@material-ui/core/DialogContent';
import DialogActions from '@material-ui/core/DialogActions';
import TextField from '@material-ui/core/TextField';

import { serializeInkStory } from './models/SavedGameModel';
import { setLastGameName } from './models/Settings';

function saveGame(name, inkStory) {
  const sValue = serializeInkStory(inkStory);
  localStorage.setItem(name, sValue);
  const games = localStorage.getItem("savedGames");

  let jsonGames = games ? JSON.parse(games) : [];

  if (jsonGames.filter((game) => game.name === name).length === 0) {
    jsonGames.push({ name });
  }
  localStorage.setItem("savedGames", JSON.stringify(jsonGames));
}

export function SaveGameView(props) {
  const [inkStory] = useState(props.inkStory);
  let [gameName, updateGameName] = useState("Дике Поле");
  return (
    <Dialog open={props.open}>
      <DialogTitle>
        Зберегти гру
      </DialogTitle>
      <DialogContent>
        <TextField value={gameName} onChange={(event) => {
          updateGameName(event.target.value);
        }}></TextField>
      </DialogContent>
      <DialogActions>
        <Button onClick={() => { setLastGameName(gameName); saveGame(gameName, inkStory); props.onCancel() }}>Зберегти</Button>
        <Button onClick={() => { props.onCancel() }}>Скасувати</Button>
      </DialogActions>
    </Dialog>
  );
}