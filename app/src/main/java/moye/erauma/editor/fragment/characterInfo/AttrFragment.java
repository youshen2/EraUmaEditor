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
        items.add(new EditorItem.Builder("干劲", "cflag/{id}/40", EditorItem.DataType.CHOICE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(-2, "极差"),
                        new EditorItem.Choice(-1, "较差"),
                        new EditorItem.Choice(0, "一般"),
                        new EditorItem.Choice(1, "较佳"),
                        new EditorItem.Choice(2, "极佳")
                ))
                .build());


        items.add(EditorItem.createHeader("爱慕数值"));
        items.add(new EditorItem.Builder("好感度", "mark/{id}/0", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());
        items.add(new EditorItem.Builder("爱慕", "love/{id}", EditorItem.DataType.FLOAT)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .build());

        items.add(EditorItem.createHeader("适应性"));
        items.add(new EditorItem.Builder("草地", "cflag/{id}/30", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "G"),
                        new EditorItem.Choice(1, "F"),
                        new EditorItem.Choice(2, "E"),
                        new EditorItem.Choice(3, "D"),
                        new EditorItem.Choice(4, "C"),
                        new EditorItem.Choice(5, "B"),
                        new EditorItem.Choice(6, "A"),
                        new EditorItem.Choice(7, "S")
                ))
                .build());
        items.add(new EditorItem.Builder("泥地", "cflag/{id}/31", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "G"),
                        new EditorItem.Choice(1, "F"),
                        new EditorItem.Choice(2, "E"),
                        new EditorItem.Choice(3, "D"),
                        new EditorItem.Choice(4, "C"),
                        new EditorItem.Choice(5, "B"),
                        new EditorItem.Choice(6, "A"),
                        new EditorItem.Choice(7, "S")
                ))
                .build());
        items.add(new EditorItem.Builder("短距离", "cflag/{id}/32", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "G"),
                        new EditorItem.Choice(1, "F"),
                        new EditorItem.Choice(2, "E"),
                        new EditorItem.Choice(3, "D"),
                        new EditorItem.Choice(4, "C"),
                        new EditorItem.Choice(5, "B"),
                        new EditorItem.Choice(6, "A"),
                        new EditorItem.Choice(7, "S")
                ))
                .build());
        items.add(new EditorItem.Builder("英里", "cflag/{id}/33", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "G"),
                        new EditorItem.Choice(1, "F"),
                        new EditorItem.Choice(2, "E"),
                        new EditorItem.Choice(3, "D"),
                        new EditorItem.Choice(4, "C"),
                        new EditorItem.Choice(5, "B"),
                        new EditorItem.Choice(6, "A"),
                        new EditorItem.Choice(7, "S")
                ))
                .build());
        items.add(new EditorItem.Builder("中距离", "cflag/{id}/34", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "G"),
                        new EditorItem.Choice(1, "F"),
                        new EditorItem.Choice(2, "E"),
                        new EditorItem.Choice(3, "D"),
                        new EditorItem.Choice(4, "C"),
                        new EditorItem.Choice(5, "B"),
                        new EditorItem.Choice(6, "A"),
                        new EditorItem.Choice(7, "S")
                ))
                .build());
        items.add(new EditorItem.Builder("长距离", "cflag/{id}/35", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "G"),
                        new EditorItem.Choice(1, "F"),
                        new EditorItem.Choice(2, "E"),
                        new EditorItem.Choice(3, "D"),
                        new EditorItem.Choice(4, "C"),
                        new EditorItem.Choice(5, "B"),
                        new EditorItem.Choice(6, "A"),
                        new EditorItem.Choice(7, "S")
                ))
                .build());
        items.add(new EditorItem.Builder("逃马", "cflag/{id}/36", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "G"),
                        new EditorItem.Choice(1, "F"),
                        new EditorItem.Choice(2, "E"),
                        new EditorItem.Choice(3, "D"),
                        new EditorItem.Choice(4, "C"),
                        new EditorItem.Choice(5, "B"),
                        new EditorItem.Choice(6, "A"),
                        new EditorItem.Choice(7, "S")
                ))
                .build());
        items.add(new EditorItem.Builder("先马", "cflag/{id}/37", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "G"),
                        new EditorItem.Choice(1, "F"),
                        new EditorItem.Choice(2, "E"),
                        new EditorItem.Choice(3, "D"),
                        new EditorItem.Choice(4, "C"),
                        new EditorItem.Choice(5, "B"),
                        new EditorItem.Choice(6, "A"),
                        new EditorItem.Choice(7, "S")
                ))
                .build());
        items.add(new EditorItem.Builder("差马", "cflag/{id}/38", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "G"),
                        new EditorItem.Choice(1, "F"),
                        new EditorItem.Choice(2, "E"),
                        new EditorItem.Choice(3, "D"),
                        new EditorItem.Choice(4, "C"),
                        new EditorItem.Choice(5, "B"),
                        new EditorItem.Choice(6, "A"),
                        new EditorItem.Choice(7, "S")
                ))
                .build());
        items.add(new EditorItem.Builder("追马", "cflag/{id}/39", EditorItem.DataType.CHOICE)
                .setLayoutType(EditorItem.LayoutType.DOUBLE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "G"),
                        new EditorItem.Choice(1, "F"),
                        new EditorItem.Choice(2, "E"),
                        new EditorItem.Choice(3, "D"),
                        new EditorItem.Choice(4, "C"),
                        new EditorItem.Choice(5, "B"),
                        new EditorItem.Choice(6, "A"),
                        new EditorItem.Choice(7, "S")
                ))
                .build());
        items.add(EditorItem.createHeader("角色信息"));
        items.add(new EditorItem.Builder("性别", "cflag/{id}/0", EditorItem.DataType.CHOICE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(0, "女性"),
                        new EditorItem.Choice(1, "男性"),
                        new EditorItem.Choice(2, "扶她")
                ))
                .build());
        items.add(new EditorItem.Builder("阴茎尺寸", "cflag/{id}/4", EditorItem.DataType.CHOICE)
                .setChoices(Arrays.asList(
                        new EditorItem.Choice(1, "可怜"),
                        new EditorItem.Choice(2, "寒酸"),
                        new EditorItem.Choice(3, "健壮"),
                        new EditorItem.Choice(4, "凶恶"),
                        new EditorItem.Choice(5, "骇人")
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
