import React from 'react';

import Button from '@material-ui/core/Button';

const styles = {
    "width": "150px",
    "margin": "25% 0 0 35%",
    "boxShadow": "0 0 20px black"
};

export const LandingView = (props) => {
    const { onStart } = props;
    return (
        <Button color="primary" variant="contained" style={styles} onClick={onStart}>
            Почати
        </Button>
    )
}