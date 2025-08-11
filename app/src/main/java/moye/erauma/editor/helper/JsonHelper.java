package moye.erauma.editor.helper;

import org.json.JSONException;
import org.json.JSONObject;

public class JsonHelper {
    @SuppressWarnings("unchecked")
    public static <T> T get(JSONObject root, String path, T defaultValue) {
        if (root == null) {
            return defaultValue;
        }

        try {
            String[] keys = path.split("/");
            JSONObject current = root;
            for (int i = 0; i < keys.length - 1; i++) {
                if (current.has(keys[i])) {
                    current = current.getJSONObject(keys[i]);
                } else {
                    return defaultValue;
                }
            }
            String finalKey = keys[keys.length - 1];
            if (current.has(finalKey)) {
                return (T) current.get(finalKey);
            }
        } catch (JSONException | ClassCastException e) {
            e.printStackTrace();
        }
        return defaultValue;
    }

    public static void put(JSONObject root, String path, Object value) {
        if (root == null) {
            return;
        }

        try {
            String[] keys = path.split("/");
            JSONObject current = root;
            for (int i = 0; i < keys.length - 1; i++) {
                String key = keys[i];
                if (!current.has(key) || !(current.get(key) instanceof JSONObject)) {
                    current.put(key, new JSONObject());
                }
                current = current.getJSONObject(key);
            }
            current.put(keys[keys.length - 1], value);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }
}
