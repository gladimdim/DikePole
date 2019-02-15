import React, { Component } from 'react';
import * as ink from 'inkjs';

export class Story extends Component {
    constructor(props) {
        super(props);
        this.state = {
            currentText: null,
            story: undefined
        };
    }

    async componentDidMount() {
        const response = await fetch("story.json");
        const text = await response.text();
        this.setState((state, props) => {
            const story = new ink.Story(text);
            return {
                story,
                currentText: story.Continue()
            }
        });
    }

    _optionSelected(index) {
        this.state.story.ChooseChoiceIndex(index);
        this.setState((state, _opts) => {
            return {
                ...state,
                currentText: state.story.Continue()
            }
        });
    }

    _continue() {
        this.setState({
            ...this.state,
            currentText: this.state.story.Continue()
        });
    }

    render() {
        if (this.state == null || this.state.story === undefined) {
            return (<div>Loading...</div>);
        }
        return (
            <div>
                <div>{this.state.currentText}</div>
                {this.state.story.currentChoices.length > 0 ?
                    <div name="options">
                        {this.state.story.currentChoices.map((choice => {
                            return <button key={choice.index} onClick={() => this._optionSelected(choice.index)}>{choice.text}</button>
                        }))}
                    </div>
                    : <button onClick={() => this._continue()}>Далі</button>
                }
            </div>
        );
    }
}