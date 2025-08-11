package moye.erauma.editor;

import android.app.Application;
import android.content.Context;

import org.json.JSONObject;

public class EraUmaEditor extends Application {
    public static JSONObject save_data = null;
    public static int current_character_id = 0;

    public static Context context;

    @Override
    public void onCreate() {
        super.onCreate();
        if (getApplicationContext() != null) context = getApplicationContext();
    }
}
