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
import moye.erauma.editor.fragment.characterInfo.AbilityFragment;
import moye.erauma.editor.fragment.characterInfo.AttrFragment;
import moye.erauma.editor.fragment.characterInfo.CallnameFragment;
import moye.erauma.editor.fragment.characterInfo.ExFragment;
import moye.erauma.editor.fragment.characterInfo.ExpFragment;

public class CharacterInfoActivity extends AppCompatActivity {

    private BottomNavigationView bottomNav;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_actor_info);

        bottomNav = findViewById(R.id.bottom_navigation);

        setupKeyboardListener();

        bottomNav.setOnItemSelectedListener(item -> {
            Fragment selectedFragment = null;
            int itemId = item.getItemId();

            if (itemId == R.id.nav_attr) {
                selectedFragment = new AttrFragment();
            }else if (itemId == R.id.nav_ability) {
                selectedFragment = new AbilityFragment();
            }else if (itemId == R.id.nav_exp) {
                selectedFragment = new ExpFragment();
            }else if (itemId == R.id.nav_ex) {
                selectedFragment = new ExFragment();
            }else if (itemId == R.id.nav_callname) {
                selectedFragment = new CallnameFragment();
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

        bottomNav.setSelectedItemId(R.id.nav_attr);
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