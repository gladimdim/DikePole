import React from 'react';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';

import Card from '@material-ui/core/Card';
import CardContent from '@material-ui/core/CardContent';

const containerStyle = {
  "height": "auto",
  "display": "grid",
  "minHeight": "100vh",
  "gridTemplateRows": "auto 80px",
//   "backgroundColor": "#8888"
};

const textStyle = {
    "margin": "1rem",
    "opacity": "0.8",
  "gridRow": "1 / 2",
  "fontSize": "3vh"

}

const textButtonStyle = {
    bottom: 0,
  position: "sticky",
  "gridRow": "2 / 3"
}

const ChoiceView = ({choices, onSelected}) => {
    const divs = choices.map(
        (choice, i) => <Button variant="contained" color="primary" onClick={() => onSelected(i)}>{choice}</Button>
    );
    return (<div style={textButtonStyle}>
      {divs}
    </div>);
}
export const StoryView = (props) => {
    const {story, onNext, onChoiceSelected} = props;
        return (
            <div style={containerStyle}>
                <Card elevation={5} style={textStyle}>
                <CardContent>
                    <Typography component="div" variant="headline">{story.currentText}</Typography>
                    </CardContent>
                </Card>
                {story.canContinue ? <Button variant="contained" color="primary" style={textButtonStyle} onClick={onNext}>Далі</Button> : 
                <ChoiceView style={textButtonStyle} onSelected={onChoiceSelected} choices={story.currentChoices.map(choice => choice.text)}/>}
            </div>
        );
}