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

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import moye.erauma.editor.Constants;
import moye.erauma.editor.EraUmaEditor;
import moye.erauma.editor.R;
import moye.erauma.editor.adapter.SaveDataAdapter;
import moye.erauma.editor.model.EditorItem;

public class ExFragment extends Fragment {
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

        updateEmptyStateView();
    }

    private void initEditorItems() {
        try {
            JSONObject item_hold = EraUmaEditor.save_data.getJSONObject("ex").getJSONObject(String.valueOf(EraUmaEditor.current_character_id));

            Iterator<String> keys = item_hold.keys();
            while (keys.hasNext()) {
                String key = keys.next();

                items.add(new EditorItem.Builder(Constants.EX_MAP.get(key), "ex/{id}/" + key, EditorItem.DataType.BOOLEAN)
                        .setLayoutType(EditorItem.LayoutType.DOUBLE)
                        .build());
            }
        }catch (Exception e){
            e.printStackTrace();
        }
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
