import React from 'react';

const styles = {
    "width": "150px",
    "margin": "25% 0 0 35%",
    "backgroundColor": "white",
    "boxShadow": "0 0 20px black"
};

export const LandingView = (props) => {
    const { onStart } = props;
    return (
        <button style={styles} onClick={onStart}>
            Почати
        </button>
    )
}