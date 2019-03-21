import React from 'react';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import Card from '@material-ui/core/Card';
import CardMedia from '@material-ui/core/CardMedia';
import CardActions from '@material-ui/core/CardActions';
import CardContent from '@material-ui/core/CardContent';
import Button from '@material-ui/core/Button';
import { getLastGameName, hasLastGame } from './models/Settings';

const stylesRow = {
  float: "left",
  width: "100%",
  textAlign: "center"
};

const stylesColumn = {
  display: "table",
  minHeight: "10vh",
  padding: "0 20% 2rem 20%",
};

const stylesCardMedia = {
  height: "100%",
  maxHeight: "50px",
  width: "auto",
  paddingTop: '70%',
};

const containerStyle = {
  "height": "auto",
  "display": "grid",
  "minHeight": "91vh",
  "gridTemplateRows": "auto 8vh",
};

const continueGameStyle = {
  "gridRow": "1/2",
  "width": "90vw",
  "margin": "0 5% 0 5%"
};

const catalogStyle = {
  "gridRow": "2/3",
  "width": "90vw",
  "margin": "0 5% 0 5%"
};

const thirdStyle = {
  "gridRow": "3/4",
  "width": "90vw",
  "margin": "0 5% 0 5%"
};

export function LandingView(props) {
  const onContinueGame = () => {
    const lastGameName = getLastGameName();
    const inkStoryJSON = localStorage.getItem(lastGameName);
    props.onContinueGame(inkStoryJSON);
  };

  return (
    <div style={containerStyle}>
    <List>
      <ListItem >
        <Card style={continueGameStyle}>
         <CardMedia style={stylesCardMedia} image="images/cards/colored_boat_0.jpg"/>
          <CardContent>
            У вас є почата гра
          </CardContent>
          <CardActions>
            <Button disabled={!hasLastGame()} onClick={onContinueGame}>Продовжити</Button>
          </CardActions>
        </Card>
      </ListItem>
      <ListItem>
        <Card style={catalogStyle}>
          <CardMedia style={stylesCardMedia} image="images/cards/colored_boat_2.jpg"/>
          <CardContent>
            Доступні книжки для гри
          </CardContent>
          <CardActions>
            <Button onClick={props.onCatalogView}>Переглянути</Button>
          </CardActions>
        </Card>
      </ListItem>
      <ListItem>
        <Card style={thirdStyle}>
          <CardMedia style={stylesCardMedia} image="images/cards/colored_boat_1.jpg"/>
          <CardContent>
            Привіт
          </CardContent>
        </Card>
      </ListItem>
    </List>
    </div>
  );
}