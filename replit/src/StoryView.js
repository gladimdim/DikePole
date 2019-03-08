import React from 'react';

const containerStyle = {
  "width": "100vw",
  "height": "auto",
  "minHeight": "100vh",
  "display": "grid",
  "gridTemplateRows": "5% auto 80px",
  "backgroundColor": "#8888"
};

const textStyle = {
  "gridRow": "2 / 3",
  "fontSize": "3vh"
}

const textButtonStyle = {
  "gridRow": "3 / 4"
}

const ChoiceView = ({choices, onSelected}) => {
    const divs = choices.map(
        (choice, i) => <button key={i} onClick={() => onSelected(i)}>{choice}</button>
    );
    return (<div style={textButtonStyle}>
      {divs}
    </div>);
}
export const StoryView = (props) => {
    const {story, onNext, onChoiceSelected} = props;
        return (
            <div style={containerStyle}>
                <div style={textStyle}>{story.currentText}</div>
                {story.canContinue ? <button style={textButtonStyle} onClick={onNext}>Далі</button> : 
                <ChoiceView style={textButtonStyle} onSelected={onChoiceSelected} choices={story.currentChoices.map(choice => choice.text)}/>}
            </div>
        );
}