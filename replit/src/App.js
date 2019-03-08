import React, { Component } from 'react';
import './App.css';
import { StoryView } from './StoryView';
import { createStory } from './Story';
import { LandingView } from './LandingView';
/*global inkjs*/

class App extends Component {
    constructor() {
        super();
        this.state = {
            inkStory: null,
            story: null,
            initialLoad: true,
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
            initialLoad: false
        });
    }

    render() {
        const {story, inkStory} = this.state;
        if (this.state.initialLoad) {
            return (<LandingView onStart={() => this.begin()}/>);
        }
        return (inkStory !== null ?
            <StoryView story={story}
                onNext={() => this.doContinue()}
                onChoiceSelected={(i) => {
                    this.choiceSelected(i)
                }}
            /> : <div>Not yet!</div>);
    }
}

export default App;
