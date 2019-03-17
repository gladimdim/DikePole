import React, { useState } from 'react';
import Dialog from '@material-ui/core/Dialog';
import Button from '@material-ui/core/Button';
import DialogTitle from '@material-ui/core/DialogTitle';
import DialogContent from '@material-ui/core/DialogContent';
import DialogActions from '@material-ui/core/DialogActions';
import Input from '@material-ui/core/Input';

export function LoadInkView(props) {
  var [fileName, updateFileName] = useState();

  return (
    <Dialog
      open={props.open}
    >
      <DialogTitle>Завантажити свій файл Ink</DialogTitle>
      <DialogContent>
        <Input type="file" variant="outlined" placeholder="Вставте сюди свій інкі"
          onChange={(event) => updateFileName(event.target.files[0])}>
        </Input>
      </DialogContent>
      <DialogActions>
        <Button onClick={() => {
          const fileReader = new FileReader();
          fileReader.onload = (file) => {
            debugger;
            props.onInkAdded(file.currentTarget.result);
          };
          fileReader.readAsText(fileName);
        }}>Завантажити</Button>
        <Button onClick={props.onClose}>Закрити</Button>
      </DialogActions>
    </Dialog>
  );
}