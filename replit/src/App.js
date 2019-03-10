import React, { Component } from 'react';
import './App.css';
import { StoryView } from './StoryView';
import { createStory } from './Story';
import { LandingView } from './LandingView';
import { LoadInkView } from './LoadInkView';

import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import deepPurple from '@material-ui/core/colors/deepPurple';
import blue from '@material-ui/core/colors/blue';
import Button from '@material-ui/core/Button';
import { MuiThemeProvider, createMuiTheme } from '@material-ui/core/styles';

const theme = createMuiTheme({
    palette: {
        primary: deepPurple,
        secondary: blue,
    },
});

const appBarTitleStyles = {
    "flexGrow": 1
};

/*global inkjs*/

class App extends Component {
    constructor() {
        super();
        this.state = {
            inkStory: null,
            story: null,
            initialLoad: true,
            gameStarted: false,
            loadInkOpened: false,
        }
    }

    doContinue() {
        this.state.inkStory.Continue();
        this.setState({
            ...this.state,
            story: createStory(this.state.inkStory)
        })
    }

    choiceSelected(i) {
        this.state.inkStory.ChooseChoiceIndex(i);
        this.state.inkStory.Continue();
        this.setState({
            ...this.state,
            story: createStory(this.state.inkStory)
        });
    }

    async begin() {
        const response = await fetch("locadeserta.ink.json");
        const json = await response.text();
        const inkStory = new inkjs.Story(json);
        inkStory.Continue();
        this.setState({
            ...this.state,
            inkStory,
            story: createStory(inkStory),
            initialLoad: false,
            gameStarted: true,
        });


    }

    onStartAgain() {
        this.setState({
            ...this.state,
            inkStory: null,
            story: null,
            initialLoad: true,
            gameStarted: false,
        });
    }

    onOpenDialog() {
        this.setState({
            ...this.state,
            loadInkOpened: true
        });
    }

    onCloseDialog() {
        this.setState({
            ...this.state,
            loadInkOpened: false
        });
    }

    loadUserInkJson(json) {
        const inkStory = new inkjs.Story(json);
        inkStory.Continue();
        this.setState({
            ...this.state,
            inkStory,
            story: createStory(inkStory),
            initialLoad: false,
            gameStarted: true,
            loadInkOpened: false,
        });
    }

    render() {
        const { story, inkStory } = this.state;
        return (
            <MuiThemeProvider theme={theme}>
                <AppBar position="sticky">
                    <Toolbar>
                        <div style={appBarTitleStyles}>Дике Поле</div>
                        {
                            this.state.gameStarted ? <Button onClick={() => this.onStartAgain()}> Заново</Button> : <Button onClick={() => this.begin()}>Почати</Button>
                        }
                        <Button onClick={() => this.onOpenDialog()}>Своє</Button>
                    </Toolbar>
                </AppBar>
                <LoadInkView
                    open={this.state.loadInkOpened}
                    onInkAdded={(newInkJson) => this.loadUserInkJson(newInkJson)}
                    onClose={() => this.onCloseDialog()}/>
                {
                    inkStory !== null && <StoryView story={story}
                        onNext={() => this.doContinue()}
                        onChoiceSelected={(i) => {
                            this.choiceSelected(i)
                        }} />
                }
            </MuiThemeProvider>
        );
    }
}

export default App;
