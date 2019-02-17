package gladimdim.locadeserta;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import com.bladecoder.ink.runtime.Choice;
import com.bladecoder.ink.runtime.Story;

import java.io.BufferedReader;
import java.io.IOError;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import io.flutter.app.FlutterActivity;
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
                            result.error("EXCEPTION",e.toString(), null);
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
                        List choices = new ArrayList();
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
                    }
                    else {
                        result.notImplemented();
                    }
                }
            }
    );
  }

  Story _loadStory(Object text) {
      if (story != null) {
          return story;
      }
      try {
          story = new Story(text.toString());
      } catch (Exception e) {
          return null;
      }
      return story;
  }
}
