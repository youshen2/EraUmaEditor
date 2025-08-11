package moye.erauma.editor.fragment.main;

import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageButton;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.google.android.material.card.MaterialCardView;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import moye.erauma.editor.EraUmaEditor;
import moye.erauma.editor.R;
import moye.erauma.editor.adapter.CharacterAdapter;
import moye.erauma.editor.model.CharacterItem;

public class CharacterFragment extends Fragment {

    private RecyclerView recyclerView;
    private CharacterAdapter adapter;
    private List<CharacterItem> originalCharacterList = new ArrayList<>();

    private FloatingActionButton fabSearch;
    private MaterialCardView searchBarContainer;
    private EditText searchEditText;
    private ImageButton closeSearchButton;
    private View rootView;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_character, container, false);
        return rootView;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        initializeViews(view);

        setupRecyclerView();

        setupListeners();

        updateEmptyStateView();
    }

    private void initializeViews(View view) {
        recyclerView = view.findViewById(R.id.recyclerView);
        fabSearch = view.findViewById(R.id.fab_search);
        searchBarContainer = view.findViewById(R.id.search_bar_container);
        searchEditText = view.findViewById(R.id.search_edit_text);
        closeSearchButton = view.findViewById(R.id.close_search_button);
    }

    private void setupRecyclerView() {
        recyclerView.setLayoutManager(new LinearLayoutManager(getContext()));
        recyclerView.setHasFixedSize(true);

        loadCharacterData();

        adapter = new CharacterAdapter(getContext(), originalCharacterList);
        recyclerView.setAdapter(adapter);
    }

    private void setupListeners() {
        fabSearch.setOnClickListener(v -> showSearchUI());

        closeSearchButton.setOnClickListener(v -> hideSearchUI());

        searchEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) { }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                filter(s.toString());
            }

            @Override
            public void afterTextChanged(Editable s) { }
        });
    }

    private void showSearchUI() {
        fabSearch.hide();
        searchBarContainer.setVisibility(View.VISIBLE);
        searchEditText.requestFocus();
        InputMethodManager imm = (InputMethodManager) getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.showSoftInput(searchEditText, InputMethodManager.SHOW_IMPLICIT);
    }

    private void hideSearchUI() {
        InputMethodManager imm = (InputMethodManager) getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(getView().getWindowToken(), 0);

        searchEditText.setText("");
        searchBarContainer.setVisibility(View.GONE);
        fabSearch.show();
        adapter.filterList(originalCharacterList);
    }

    private void filter(String query) {
        List<CharacterItem> filteredList = new ArrayList<>();
        if (query.isEmpty()) {
            filteredList.addAll(originalCharacterList);
        } else {
            for (CharacterItem character : originalCharacterList) {
                if (character.getName().toLowerCase(Locale.ROOT).contains(query.toLowerCase(Locale.ROOT))) {
                    filteredList.add(character);
                }
            }
        }
        adapter.filterList(filteredList);
    }

    private void loadCharacterData() {
        try {
            JSONObject item_hold = EraUmaEditor.save_data.getJSONObject("callname");

            Iterator<String> keys = item_hold.keys();
            while (keys.hasNext()) {
                String key = keys.next();
                JSONObject value = item_hold.getJSONObject(key);
                originalCharacterList.add(new CharacterItem(key, value.getString("-1")));
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
            fabSearch.setVisibility(isDataLoaded ? View.VISIBLE : View.GONE);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}