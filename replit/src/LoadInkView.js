import React, {Component} from 'react';
import Dialog from '@material-ui/core/Dialog';
import Button from '@material-ui/core/Button';
import DialogTitle from '@material-ui/core/DialogTitle';
import DialogContent from '@material-ui/core/DialogContent';
import DialogActions from '@material-ui/core/DialogActions';
import TextField from '@material-ui/core/TextField';

export class LoadInkView extends Component {
    constructor(props) {
        super(props);
        this.state = {
            inputInkJson: null
        };
    }

    onTextFieldChange(value) {
        this.setState({
            ...this.state,
            inputInkJson: value
        })
    }
    render() {
        return (
            <Dialog
                open={this.props.open}
            >
            <DialogTitle>Завантажити свій файл Ink</DialogTitle>
            <DialogContent>
                <TextField multiline variant="outlined" rowsMax="15" placeholder="Вставте сюди свій інкі" onChange={(event) => this.onTextFieldChange(event.target.value)}>
                </TextField>
            </DialogContent>
            <DialogActions>
                <Button onClick={() => this.props.onInkAdded(this.state.inputInkJson)}>Завантажити</Button>
                <Button onClick={this.props.onClose}>Закрити</Button>
            </DialogActions>
            </Dialog>
        );
    }
}