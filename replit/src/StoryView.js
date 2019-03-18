import React, { Component } from 'react';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import Card from '@material-ui/core/Card';
import CardContent from '@material-ui/core/CardContent';

import { createStory } from './models/Story';

const containerStyle = {
  "height": "auto",
  "display": "grid",
  "minHeight": "91vh",
  "gridTemplateRows": "auto 8vh",
};

const textStyle = {
  "margin": "1rem",
  "opacity": "0.8",
  "gridRow": "1 / 2",
  "fontSize": "3vh",
  "height": "78vh",
  "overflow": "auto"
}

const dialogChoicesViewStyle = {
  "margin": "0.25rem"
}

const textButtonStyle = {
  bottom: 0,
  position: "sticky",
  "gridRow": "2 / 3"
}

const ChoiceView = ({ choices, onSelected }) => {
  const divs = choices.map(
    (choice, i) => <Button style={dialogChoicesViewStyle} key={i} variant="contained" color="primary" onClick={() => onSelected(i)}>{choice}</Button>
  );
  return (<div>
    {divs}
  </div>);
}

export class StoryView extends Component {
  constructor(props) {
    super(props);

    this.state = {
      inkStory: props.inkStory,
      story: createStory(props.inkStory)
    };
  }

  doContinue() {
    this.state.inkStory.Continue();
    this.setState({
      ...this.state,
      story: createStory(this.state.inkStory)
    })
  }

  onChoiceSelected(i) {
    const root = document.querySelector("#root");
    const random = Math.floor(Math.random() * Math.floor(10));
    root.setAttribute('style', `background: url(images/background/boat_${random}.jpg) no-repeat center center fixed; background-color: white; min-height: 100vh`);
    this.state.inkStory.ChooseChoiceIndex(i);
    this.state.inkStory.Continue();
    this.setState({
      ...this.state,
      story: createStory(this.state.inkStory)
    });
  }

  render() {
    const { story } = this.state;
    return (
      <div style={containerStyle}>
        <Card elevation={5} style={textStyle}>
          <CardContent>
            <Typography component="div" variant="headline">{story.currentText}</Typography>
          </CardContent>
        </Card>
        {
          story.canContinue ? <Button variant="contained" color="primary" style={textButtonStyle} onClick={() => { this.doContinue()}}>Далі</Button> :
            <ChoiceView onSelected={this.onChoiceSelected.bind(this)} choices={story.currentChoices.map(choice => choice.text)} />
        }
      </div>
    );
  }
}