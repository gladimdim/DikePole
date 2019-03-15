import React, { Component } from 'react';

import './App.css';
import { StoryView } from './StoryView';
import { LoadInkView } from './LoadInkView';
import { SavedGamesView } from './SavedGamesView';
import { SaveGameView } from './SaveGameView';
import { deserialize } from './SavedGameModel';

import Menu from '@material-ui/core/Menu';
import MenuItem from '@material-ui/core/MenuItem';
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
      savedGamesOpened: false,
      settingsMenuOpened: false,
      anchorEl: null,
      saveGameOpened: false,
    }
  }

  async begin() {
    const response = await fetch("locadeserta.ink.json");
    const json = await response.text();
    const inkStory = new inkjs.Story(json);
    inkStory.Continue();
    this.setState({
      ...this.state,
      inkStory,
      initialLoad: false,
      gameStarted: true,
    });
  }

  onStartAgain() {
    this.setState({
      ...this.state,
      inkStory: null,
      initialLoad: true,
      gameStarted: false,
    });
  }

  onOpenDialog() {
    this.setState({
      ...this.state,
      loadInkOpened: true
    }, () => {
      this.handleSettingsMenuClose();
    });
  }

  onCloseDialog() {
    this.setState({
      ...this.state,
      loadInkOpened: false
    });
  }

  onSavedGamesCloseDialog() {
    this.setState({
      ...this.state,
      savedGamesOpened: false
    });
  }

  loadUserInkJson(json) {
    const inkStory = new inkjs.Story(json);
    inkStory.Continue();
    this.setState({
      ...this.state,
      inkStory,
      initialLoad: false,
      gameStarted: true,
      loadInkOpened: false,
    });
  }

  onOpenSavedGamesDialog() {
    this.setState({
      ...this.state,
      savedGamesOpened: true
    }, () => {
      this.handleSettingsMenuClose();
    })
  }

  onOpenSaveGameDialog() {
    this.setState({
      ...this.state,
      saveGameOpened: true
    }, () => {
      this.handleSettingsMenuClose();
    });
  }

  onGameSelected(gameJsonString) {
    const inkStory = deserialize(gameJsonString);
    this.setState({
      inkStory,
      savedGamesOpened: false,
      initialLoad: false,
      gameStarted: true,
    });
  }

  onSettingsMenuOpen(anchorEl) {
    this.setState({
      ...this.state,
      settingsMenuOpened: true,
      anchorEl
    });
  }

  handleSettingsMenuClose() {
    this.setState({
      ...this.state,
      settingsMenuOpened: false,
      anchorEl: null
    })
  }

  onSaveGameDialogClose() {
     this.setState({
      ...this.state,
      saveGameOpened: false
    }, (state) => {
      this.handleSettingsMenuClose();
    });
  }

  render() {
    const { inkStory } = this.state;
    return (
      <MuiThemeProvider theme={theme}>
        <AppBar position="sticky">
          <Toolbar>
            <div style={appBarTitleStyles}>Дике Поле</div>
            <Button
              onClick={(event) => { this.onSettingsMenuOpen(event.currentTarget) }}
              color="inherit"
            >
              Меню
            </Button>
          </Toolbar>
        </AppBar>
        {
          this.state.savedGamesOpened &&
          <SavedGamesView
            open={this.state.savedGamesOpened}
            onGameSelected={this.onGameSelected.bind(this)}
            onCancel={() => { this.onSavedGamesCloseDialog() }}
          />
        }
        {
          this.state.saveGameOpened && this.state.inkStory &&
            <SaveGameView inkStory={this.state.inkStory} open={this.state.saveGameOpened} onCancel={() => {this.onSaveGameDialogClose()}}/>
        }
        <LoadInkView
          open={this.state.loadInkOpened}
          onInkAdded={(newInkJson) => this.loadUserInkJson(newInkJson)}
          onClose={() => this.onCloseDialog()} />
        {
          inkStory !== null && <StoryView inkStory={this.state.inkStory} />
        }
        {
          this.state.settingsMenuOpened && <Menu
            id="simple-menu"
            anchorEl={this.state.anchorEl}
            open={Boolean(this.state.settingsMenuOpened)}
            onClose={() => this.handleSettingsMenuClose()}
          >
            {
              this.state.gameStarted ? <MenuItem onClick={() => this.onStartAgain()}>Заново</MenuItem> : <MenuItem onClick={() => this.begin()}>Почати</MenuItem>
              }
            <MenuItem onClick={() => { this.onOpenDialog() }}>Своє</MenuItem>
            <MenuItem onClick={() => { this.onOpenSavedGamesDialog() }}>Збережені</MenuItem>
            {this.state.gameStarted && <MenuItem onClick={() => { this.onOpenSaveGameDialog();}}>Зберегти</MenuItem>}
          </Menu>
        }
      </MuiThemeProvider>
    );
  }
}

export default App;
