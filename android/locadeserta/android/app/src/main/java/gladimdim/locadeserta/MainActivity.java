package gladimdim.locadeserta;

import android.content.res.AssetFileDescriptor;
import android.media.MediaPlayer;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import com.bladecoder.ink.runtime.Choice;
import com.bladecoder.ink.runtime.InkList;
import com.bladecoder.ink.runtime.InkListItem;
import com.bladecoder.ink.runtime.Story;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "gladimdim.locadeserta/Ink";
    private Story story;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, Result result) {
                        if (methodCall.method.equals("Init")) {
                            story = _loadStory(methodCall.argument("text"));
                            result.success("success");
                        } else if (methodCall.method.equals("getInventory")) {
                            InkList inventory;
                            try {
                                inventory = (InkList) story.getVariablesState().get("Inventory");
                                result.success(inventory.entrySet());
                            } catch (Exception e) {
                                result.error("EXCEPTION", e.toString(), null);
                            }
                        } else if (methodCall.method.equals("restoreState")) {
                          String json = methodCall.argument("text");
                          try {
                              story.getState().loadJson(json);
                              result.success("success");
                          } catch (Exception e) {
                              result.error("EXCEPTION", e.toString(), null);
                          }
                        } else if (methodCall.method.equals("canContinue")) {
                            boolean canContinue;
                            try {
                                canContinue = story.canContinue();
                                result.success(canContinue);
                            } catch (Exception e) {
                                result.error("EXCEPTION", e.toString(), null);
                            }
                        } else if (methodCall.method.equals("Continue")) {
                            String currentNext;
                            try {
                                currentNext = story.Continue();
                                result.success(currentNext);
                            } catch (Exception e) {
                                result.error("EXCEPTION", e.toString(), null);
                            }
                        } else if (methodCall.method.equals("getCurrentText")) {
                            String currentText;
                            try {
                                currentText = story.getCurrentText();
                                result.success(currentText);
                            } catch (Exception e) {
                                result.error("EXCEPTION", e.toString(), null);
                            }
                        } else if (methodCall.method.equals("getCurrentChoices")) {
                            ArrayList choices = new ArrayList();
                            for (Choice c : story.getCurrentChoices()) {
                                choices.add((c.getText()));
                            }
                            result.success(choices);
                        } else if (methodCall.method.equals("chooseChoiceIndex")) {
                            try {
                                story.chooseChoiceIndex(methodCall.argument("index"));
                                result.success(story.getCurrentText());
                            } catch (Exception e) {
                                result.error("EXCEPTION", e.toString(), null);
                            }
                        } else if (methodCall.method.equals("getCurrentTags")) {
                            try {
                                List<String> tags = story.getCurrentTags();
                                result.success(tags);
                            } catch (Exception e) {
                                result.error("EXCEPTION", e.toString(), null);
                            }
                        } else if (methodCall.method.equals("playSound")) {
                            AssetFileDescriptor descriptor;
                            MediaPlayer m = new MediaPlayer();
                            try {
                                descriptor = getAssets().openFd("sounds/khoreya/kiriye.mp3");
                                m.setDataSource(descriptor.getFileDescriptor(), descriptor.getStartOffset(), descriptor.getLength());
                                descriptor.close();
                                m.prepare();
                                m.setVolume(1f, 1f);
                                m.setLooping(true);
                                m.start();
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        } else if (methodCall.method.equals("saveState")) {
                            try {
                                String stateJson = story.getState().toJson();
                                result.success(stateJson);
                            } catch (Exception e) {
                                result.error("EXCEPTION", e.toString(), null);
                            }
                        }
                        else {
                            result.notImplemented();
                        }
                    }
                }
        );
    }

    Story _loadStory(Object text) {
        try {
            story = new Story(text.toString());
        } catch (Exception e) {
            return null;
        }
        return story;
    }

    Story _restoreStory(String json) {
        try {
            story.getState().loadJson(json);
        } catch (Exception e) {
            return null;
        }
        return story;
    }
}
