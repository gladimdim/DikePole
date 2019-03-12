import React, { Component } from 'react';
import Dialog from '@material-ui/core/Dialog';
import Button from '@material-ui/core/Button';
import DialogTitle from '@material-ui/core/DialogTitle';
import DialogContent from '@material-ui/core/DialogContent';
import DialogActions from '@material-ui/core/DialogActions';

export class SavedGamesView extends Component {
    constructor(props) {
        super(props);
        this.state = {
            games: []
        }
    }

    componentDidMount() {
        let store = window.localStorage.getItem("savedGames");
        if (store !== null) {
            store = JSON.parse(store);
            this.setState({
                ...this.state,
                games: store
            })
        }
    }

    render() {
        return (
            <Dialog open={this.props.open}>
                <DialogTitle>Список збережених ігор</DialogTitle>
                <DialogContent>
                    <div>
                        {
                            this.state.games.map((game) => <div>{game.name}</div>)
                        }
                    </div>
                </DialogContent>
                <DialogActions>
                    <Button onClick={this.props.onCancel}>Скасувати</Button>
                </DialogActions>
            </Dialog>

        );
    }
}

/*
window.localStorage.setItem("savedGames", JSON.stringify([{"name": "123"}, {"name": "1000"}]))
*/