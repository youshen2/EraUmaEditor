package moye.erauma.editor.fragment;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import moye.erauma.editor.EraUmaEditor;
import moye.erauma.editor.R;
import moye.erauma.editor.adapter.SaveDataAdapter;
import moye.erauma.editor.model.EditorItem;

public class GlobalFragment extends Fragment {
    private View view;
    private SaveDataAdapter adapter;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_global, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        this.view = view;

        RecyclerView recyclerView = view.findViewById(R.id.recyclerView);

        List<EditorItem> items = new ArrayList<>();
        items.add(new EditorItem.Builder("当前声望", "flag/15", EditorItem.DataType.INT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("当前马币", "flag/16", EditorItem.DataType.INT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("当前年", "flag/1", EditorItem.DataType.INT)
                .build());
        items.add(new EditorItem.Builder("当前月", "flag/2", EditorItem.DataType.INT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("当前周", "flag/3", EditorItem.DataType.INT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setPrefix("第")
                .setSuffix("周")
                .build());
        items.add(new EditorItem.Builder("当前回合数", "flag/0", EditorItem.DataType.INT)
                .build());
        items.add(new EditorItem.Builder("大舞台", "flag/28", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "否"),
                        new EditorItem.Choice(1, "是")
                ))
                .build());
        items.add(new EditorItem.Builder("强制BE", "flag/27", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "否"),
                        new EditorItem.Choice(1, "是")
                ))
                .build());

        adapter = new SaveDataAdapter(items);
        recyclerView.setLayoutManager(new LinearLayoutManager(getContext()));
        recyclerView.setAdapter(adapter);
    }

    private void update_ui(){
        try {
            if (EraUmaEditor.save_data == null) {
                view.findViewById(R.id.empty_text).setVisibility(View.VISIBLE);
                view.findViewById(R.id.scroll_view).setVisibility(View.GONE);
            }
            else {
                view.findViewById(R.id.empty_text).setVisibility(View.GONE);
                view.findViewById(R.id.scroll_view).setVisibility(View.VISIBLE);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public void onHiddenChanged(boolean hidden) {
        super.onHiddenChanged(hidden);
        update_ui();
    }
}
