package moye.erauma.editor.fragment.characterInfo;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.google.android.material.appbar.CollapsingToolbarLayout;
import com.google.android.material.appbar.MaterialToolbar;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import moye.erauma.editor.EraUmaEditor;
import moye.erauma.editor.R;
import moye.erauma.editor.adapter.SaveDataAdapter;
import moye.erauma.editor.model.EditorItem;

public class AttrFragment extends Fragment {
    List<EditorItem> items = new ArrayList<>();
    private View rootView;
    private SaveDataAdapter adapter;
    private RecyclerView recyclerView;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_info, container, false);
        return rootView;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        try {
            ((CollapsingToolbarLayout) view.findViewById(R.id.collapsing_toolbar)).setTitle("正在编辑 " + EraUmaEditor.save_data.getJSONObject("callname").getJSONObject(String.valueOf(EraUmaEditor.current_character_id)).getString("-1"));
            MaterialToolbar toolbar = view.findViewById(R.id.collapsing_appbar);
            toolbar.setNavigationIcon(R.drawable.ic_arrow_back);

            toolbar.setNavigationOnClickListener(v -> {
                getActivity().finish();
            });
        }catch (Exception e){e.printStackTrace();}

        recyclerView = view.findViewById(R.id.recyclerView);

        if (items.isEmpty()) {
            initEditorItems();
        }

        adapter = new SaveDataAdapter(items);
        recyclerView.setLayoutManager(new LinearLayoutManager(getContext()));
        recyclerView.setAdapter(adapter);
    }

    private void initEditorItems() {
        items.add(EditorItem.createHeader("基础数值（当前回合有效）"));
        items.add(new EditorItem.Builder("体力", "base/{id}/0", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("最大体力", "maxbase/{id}/0", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("精力", "base/{id}/1", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("最大精力", "maxbase/{id}/1", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());

        items.add(EditorItem.createHeader("能力数值"));
        items.add(new EditorItem.Builder("速度", "base/{id}/5", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("最大速度", "maxbase/{id}/5", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("耐力", "base/{id}/6", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("最大耐力", "maxbase/{id}/6", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("力量", "base/{id}/7", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("最大力量", "maxbase/{id}/7", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("根性", "base/{id}/8", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("最大根性", "maxbase/{id}/8", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("智力", "base/{id}/9", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("最大智力", "maxbase/{id}/9", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());

        items.add(EditorItem.createHeader("爱慕数值"));
        items.add(new EditorItem.Builder("好感度", "mark/{id}/0", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("爱慕", "love/{id}", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());

        items.add(EditorItem.createHeader("角色信息"));
        items.add(new EditorItem.Builder("阴茎尺寸", "cflag/{id}/4", EditorItem.DataType.INT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "小杯"),
                        new EditorItem.Choice(1, "中杯"),
                        new EditorItem.Choice(2, "大杯"),
                        new EditorItem.Choice(3, "特大杯")
                ))
                .build());
    }

    @Override
    public void onHiddenChanged(boolean hidden) {
        super.onHiddenChanged(hidden);
        if (!hidden) {
            if (adapter != null) {
                adapter.refreshAllItems();
            }
        }
    }
}
