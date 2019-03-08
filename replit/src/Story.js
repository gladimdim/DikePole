export const createStory = (inkStory) => {
    return {
        currentText: inkStory.currentText,
        canContinue: inkStory.canContinue,
        currentChoices: inkStory.currentChoices,
    };
};