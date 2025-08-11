package moye.erauma.editor.fragment.main;

import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.google.android.material.appbar.MaterialToolbar;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;

import moye.erauma.editor.EraUmaEditor;
import moye.erauma.editor.R;

public class OverviewFragment extends Fragment {
    private static String currentFileName = null;
    private final ActivityResultLauncher<String> saveFileLauncher = registerForActivityResult(
            new ActivityResultContracts.CreateDocument("*/*"),
            uri -> {
                if (uri != null) {
                    saveJsonToFile(uri);
                }
            }
    );
    private View view;
    private final ActivityResultLauncher<String[]> openFileLauncher = registerForActivityResult(
            new ActivityResultContracts.OpenDocument(),
            uri -> {
                if (uri != null) {
                    readFile(uri);
                }
            }
    );

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_overview, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        this.view = view;

        MaterialToolbar topAppBar = view.findViewById(R.id.topAppBar);

        topAppBar.setOnMenuItemClickListener(item -> {
            int itemId = item.getItemId();

            if (itemId == R.id.load_file) {
                openFile();
                return true;
            } else if (itemId == R.id.save_file) {
                saveFile();
                return true;
            }

            return false;
        });

        update_ui();
    }

    private void update_ui() {
        try {
            if (EraUmaEditor.save_data == null) {
                view.findViewById(R.id.empty_text).setVisibility(View.VISIBLE);
                view.findViewById(R.id.scroll_view).setVisibility(View.GONE);
            } else {
                view.findViewById(R.id.empty_text).setVisibility(View.GONE);
                view.findViewById(R.id.scroll_view).setVisibility(View.VISIBLE);
                ((TextView) view.findViewById(R.id.currentFileText)).setText(currentFileName);
                ((TextView) view.findViewById(R.id.currentFileVersion)).setText(EraUmaEditor.save_data.getInt("version") + "(" + EraUmaEditor.save_data.getInt("code") + ")");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void openFile() {
        Toast.makeText(getContext(), "选择sav目录下.sav文件", Toast.LENGTH_SHORT).show();
        openFileLauncher.launch(new String[]{"*/*"});
    }

    private void readFile(Uri uri) {
        try {
            String fileName = getFileNameFromUri(uri);
            if (fileName != null) {
                currentFileName = fileName;
            }

            String fileContent = readTextFromUri(uri);
            EraUmaEditor.save_data = new JSONObject(fileContent);
            update_ui();
        } catch (IOException e) {
            Toast.makeText(requireContext(), "无法读取存档文件", Toast.LENGTH_SHORT).show();
        } catch (JSONException e) {
            Toast.makeText(requireContext(), "存档文件无效", Toast.LENGTH_SHORT).show();
        }
    }

    private String getFileNameFromUri(Uri uri) {
        String fileName = null;
        if (uri.getScheme().equals("content")) {
            try (android.database.Cursor cursor = requireContext().getContentResolver().query(uri, null, null, null, null)) {
                if (cursor != null && cursor.moveToFirst()) {
                    int nameIndex = cursor.getColumnIndex(android.provider.OpenableColumns.DISPLAY_NAME);
                    if (nameIndex != -1) {
                        fileName = cursor.getString(nameIndex);
                    }
                }
            }
        }

        if (fileName == null) {
            fileName = uri.getLastPathSegment();
        }

        return fileName;
    }

    private String readTextFromUri(Uri uri) throws IOException {
        StringBuilder stringBuilder = new StringBuilder();
        try (InputStream inputStream = requireContext().getContentResolver().openInputStream(uri);
             BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line).append('\n');
            }
        }
        return stringBuilder.toString();
    }

    private void saveFile() {
        if (EraUmaEditor.save_data == null) {
            Toast.makeText(requireContext(), "请先加载一个存档", Toast.LENGTH_SHORT).show();
            return;
        }

        String fileName = currentFileName != null ? currentFileName : "save1.sav";
        saveFileLauncher.launch(fileName);
    }

    private void saveJsonToFile(Uri uri) {
        try (OutputStream outputStream = requireContext().getContentResolver().openOutputStream(uri)) {
            if (outputStream != null && EraUmaEditor.save_data != null) {
                byte[] bytes = EraUmaEditor.save_data.toString().getBytes(StandardCharsets.UTF_8);
                outputStream.write(bytes);
                Toast.makeText(requireContext(), "存档保存成功", Toast.LENGTH_SHORT).show();

                String newFileName = getFileNameFromUri(uri);
                if (newFileName != null) {
                    currentFileName = newFileName;
                }
            }
        } catch (IOException e) {
            Toast.makeText(requireContext(), "保存文件失败", Toast.LENGTH_SHORT).show();
            e.printStackTrace();
        }
    }
}
