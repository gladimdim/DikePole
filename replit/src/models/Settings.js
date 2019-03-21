export const getSettings = () => {
  const settings = JSON.parse(localStorage.getItem("settings")) || {};
  return settings;
};

export const hasLastGame = () => {
  const settings = getSettings();
  return !!settings.lastGameName;
};

export const getLastGameName = () => {
  const settings = getSettings();
  return settings.lastGameName;
}

export const setSettings = (settings) => {
  localStorage.setItem("settings", JSON.stringify(settings));
}

export const setLastGameName = (name) => {
  const settings = getSettings();
  settings.lastGameName = name;
  setSettings(settings);
}