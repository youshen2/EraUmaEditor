package moye.erauma.editor.fragment.main;

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

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import moye.erauma.editor.EraUmaEditor;
import moye.erauma.editor.R;
import moye.erauma.editor.adapter.SaveDataAdapter;
import moye.erauma.editor.model.EditorItem;

public class GlobalFragment extends Fragment {
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
        ((CollapsingToolbarLayout) view.findViewById(R.id.collapsing_toolbar)).setTitle(getResources().getString(R.string.title_global));

        recyclerView = view.findViewById(R.id.recyclerView);

        if (items.isEmpty()) {
            initEditorItems();
        }

        adapter = new SaveDataAdapter(items);
        recyclerView.setLayoutManager(new LinearLayoutManager(getContext()));
        recyclerView.setAdapter(adapter);

        updateEmptyStateView();
    }

    private void initEditorItems() {
        items.add(new EditorItem.Builder("当前声望", "flag/15", EditorItem.DataType.INT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("当前马币", "flag/16", EditorItem.DataType.INT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("当前回合数", "flag/0", EditorItem.DataType.INT)
                .setDescription("时间回溯！")
                .build());
        items.add(new EditorItem.Builder("当前年份", "flag/1", EditorItem.DataType.INT)
                .build());
        items.add(new EditorItem.Builder("当前月", "flag/2", EditorItem.DataType.INT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("当前周", "flag/3", EditorItem.DataType.INT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setPrefix("第")
                .setSuffix("周")
                .build());

        items.add(EditorItem.createHeader("基础开关"));
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
        items.add(new EditorItem.Builder("筛除训练室活动", "flag/60", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
        items.add(new EditorItem.Builder("筛除外出活动", "flag/61", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
        items.add(new EditorItem.Builder("筛除樱花赏指令", "flag/70", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
        items.add(new EditorItem.Builder("筛除菊花赏指令", "flag/71", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
        items.add(new EditorItem.Builder("读档对话", "flag/127", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
        items.add(new EditorItem.Builder("彩蛋机制", "flag/129", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());

        items.add(EditorItem.createHeader("养成开关"));
        items.add(new EditorItem.Builder("极端行为限制", "flag/110", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
        items.add(new EditorItem.Builder("回合声望惩罚", "flag/111", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
        items.add(new EditorItem.Builder("回合好感惩罚", "flag/112", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
        items.add(new EditorItem.Builder("回合爱慕惩罚", "flag/113", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
        items.add(new EditorItem.Builder("压力获取", "flag/125", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
        items.add(new EditorItem.Builder("不忠惩罚", "flag/126", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());

        items.add(EditorItem.createHeader("性爱开关"));
        items.add(new EditorItem.Builder("筛除sm指令", "flag/72", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
        items.add(new EditorItem.Builder("筛除爱抚指令", "flag/73", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
        items.add(new EditorItem.Builder("筛除零奶乳交", "flag/74", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
        items.add(new EditorItem.Builder("筛除请求指令", "flag/75", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
        items.add(new EditorItem.Builder("筛除强制指令", "flag/76", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
        items.add(new EditorItem.Builder("马跳结果显示简报", "flag/77", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "关"),
                        new EditorItem.Choice(1, "开")
                ))
                .build());
    }

    private void updateEmptyStateView() {
        if (rootView == null) return;

        try {
            boolean isDataLoaded = EraUmaEditor.save_data != null;
            rootView.findViewById(R.id.empty_text).setVisibility(isDataLoaded ? View.GONE : View.VISIBLE);
            rootView.findViewById(R.id.recyclerView).setVisibility(isDataLoaded ? View.VISIBLE : View.GONE);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onHiddenChanged(boolean hidden) {
        super.onHiddenChanged(hidden);
        if (!hidden) {
            updateEmptyStateView();
            if (adapter != null) {
                adapter.refreshAllItems();
            }
        }
    }
}
