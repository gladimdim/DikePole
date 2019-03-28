import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import Card from '@material-ui/core/Card';
import CardContent from '@material-ui/core/CardContent';
import Menu from '@material-ui/core/Menu';
import MenuItem from '@material-ui/core/MenuItem';

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
    (choice, i) => <MenuItem style={dialogChoicesViewStyle} key={i} variant="contained" color="primary" onClick={() => onSelected(i)}>{choice}</MenuItem>
  );
  return (<div>
    {divs}
  </div>);
}

export function StoryView(props) {
  const [inkStory] = useState(props.inkStory);
  const [story, updateStory] = useState(createStory(props.inkStory));
  const [showOptionsView, updateShowOptionsView] = useState(false);
  const [anchorEl, updateAnchorEl] = useState(null);

  const divStoryRef = React.createRef();

  useEffect(() => {
    ReactDOM.findDOMNode(divStoryRef.current).scrollIntoView();
  })
  
  function doContinue() {
    inkStory.Continue();
    updateStory(createStory(inkStory));
  }

  function onChoiceSelected(i) {
    const root = document.querySelector("#root");
    const random = Math.floor(Math.random() * Math.floor(10));
    root.setAttribute('style', `background: url(images/background/boat_${random}.jpg) no-repeat center center fixed; background-color: white; min-height: 100vh`);
    inkStory.ChooseChoiceIndex(i);
    inkStory.Continue();
    updateStory(createStory(inkStory));
    updateAnchorEl(null);
    updateShowOptionsView(false);
  }

  function showOptionsDialog(anchor) {
    updateAnchorEl(anchor);
    updateShowOptionsView(true);
  }

  function onChoiceViewClosed() {
    updateAnchorEl(null);
    updateShowOptionsView(false);
  }

  return (
    <div style={containerStyle} >
      <Card elevation={5} style={textStyle}>
        <CardContent ref={divStoryRef}>
          <Typography component="div" variant="headline">{story.currentText}</Typography>
        </CardContent>
      </Card>
      {
        story.canContinue ? <Button variant="contained" color="primary" style={textButtonStyle} onClick={() => { doContinue()}}>Далі</Button> :
        <Button variant="contained" color="secondary" style={textButtonStyle} onClick={(e) => showOptionsDialog(e.currentTarget)}>Зробити вибір</Button>
      }
      {  showOptionsView && <Menu
            id="simple-menu"
            anchorEl={anchorEl}
            open={showOptionsView}
            onClose={onChoiceViewClosed}
          >
            <ChoiceView onSelected={onChoiceSelected} choices={story.currentChoices.map(choice => choice.text)}/>
          </Menu>
      }
    </div>
  );
}