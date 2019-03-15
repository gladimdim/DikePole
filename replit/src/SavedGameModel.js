/*global inkjs*/

export function serializeInkStory(inkStory) {
  return JSON.stringify({
    inkStory: inkStory.ToJsonString(),
    state: inkStory.state.ToJson()
  });
}

export function deserialize(sInput) {
  const obj = JSON.parse(sInput);
  const inkStory = new inkjs.Story(obj.inkStory);
  inkStory.state.LoadJson(obj.state);
  return inkStory;
}
