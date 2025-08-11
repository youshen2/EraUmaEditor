package moye.erauma.editor.activity;

import android.os.Bundle;
import android.view.View;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.fragment.app.Fragment;
import androidx.transition.Fade;

import com.google.android.material.bottomnavigation.BottomNavigationView;

import moye.erauma.editor.R;
import moye.erauma.editor.fragment.CharacterFragment;
import moye.erauma.editor.fragment.GlobalFragment;
import moye.erauma.editor.fragment.ItemFragment;
import moye.erauma.editor.fragment.OverviewFragment;

public class MainActivity extends AppCompatActivity {

    private BottomNavigationView bottomNav;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        bottomNav = findViewById(R.id.bottom_navigation);

        setupKeyboardListener();

        bottomNav.setOnItemSelectedListener(item -> {
            Fragment selectedFragment = null;
            int itemId = item.getItemId();

            if (itemId == R.id.nav_overview) {
                selectedFragment = new OverviewFragment();
            } else if (itemId == R.id.nav_character) {
                selectedFragment = new CharacterFragment();
            } else if (itemId == R.id.nav_item) {
                selectedFragment = new ItemFragment();
            } else if (itemId == R.id.nav_global) {
                selectedFragment = new GlobalFragment();
            }

            if (selectedFragment != null) {
                selectedFragment.setEnterTransition(new Fade());
                selectedFragment.setExitTransition(new Fade());

                getSupportFragmentManager().beginTransaction()
                        .replace(R.id.fragment_container, selectedFragment)
                        .commit();
            }
            return true;
        });

        bottomNav.setSelectedItemId(R.id.nav_overview);
    }

    private void setupKeyboardListener() {
        View rootView = findViewById(android.R.id.content);
        ViewCompat.setOnApplyWindowInsetsListener(rootView, (v, insets) -> {
            int imeHeight = insets.getInsets(WindowInsetsCompat.Type.ime()).bottom;
            if (imeHeight > 0) {
                bottomNav.setVisibility(View.GONE);
            } else {
                bottomNav.setVisibility(View.VISIBLE);
            }
            return insets;
        });
    }
}