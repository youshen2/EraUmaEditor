package moye.erauma.editor.fragment.main;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.DecelerateInterpolator;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.google.android.material.card.MaterialCardView;

import moye.erauma.editor.R;
import moye.erauma.editor.ui.BgEffectPainter;

public class AboutFragment extends Fragment {

    private View backgroundEffectView;
    private BgEffectPainter bgEffectPainter;
    private final Handler animationHandler = new Handler(Looper.getMainLooper());
    private float startTime;
    private Runnable runnableBgEffect;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_about, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        TextView versionText = view.findViewById(R.id.about_app_version);
        versionText.setText(getAppVersion());

        setupClickListeners(view);

        initializeBackgroundEffect(view);

        startEntryAnimation(view);
    }

    @Override
    public void onResume() {
        super.onResume();
        if (runnableBgEffect != null) {
            startTime = System.nanoTime();
            animationHandler.post(runnableBgEffect);
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        animationHandler.removeCallbacks(runnableBgEffect);
    }

    private void initializeBackgroundEffect(View view) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            return;
        }

        backgroundEffectView = view.findViewById(R.id.about_background_effect_view);
        bgEffectPainter = new BgEffectPainter(requireContext());

        runnableBgEffect = new Runnable() {
            @Override
            public void run() {
                bgEffectPainter.setAnimTime((((float) System.nanoTime()) - startTime) / 1.0E9f);
                bgEffectPainter.setResolution(new float[]{backgroundEffectView.getWidth(), backgroundEffectView.getHeight()});
                bgEffectPainter.updateMaterials();
                backgroundEffectView.setRenderEffect(bgEffectPainter.getRenderEffect());
                animationHandler.postDelayed(this, 16L);
            }
        };

        backgroundEffectView.post(() -> {
            bgEffectPainter.showRuntimeShader(requireContext(), backgroundEffectView);
            startTime = System.nanoTime();
            animationHandler.post(runnableBgEffect);
        });
    }

    private void startEntryAnimation(View view) {
        View headerContent = view.findViewById(R.id.header_content);
        MaterialCardView aboutCard = view.findViewById(R.id.about_card);

        headerContent.setTranslationY(-300f);
        headerContent.setAlpha(0f);

        aboutCard.setTranslationY(300f);
        aboutCard.setAlpha(0f);

        headerContent.animate()
                .translationY(0f)
                .alpha(1f)
                .setInterpolator(new DecelerateInterpolator(1.5f))
                .setDuration(600)
                .start();

        aboutCard.animate()
                .translationY(0f)
                .alpha(0.6f)
                .setInterpolator(new DecelerateInterpolator(1.5f))
                .setDuration(600)
                .setStartDelay(200)
                .start();
    }

    private void animateListItems(View... views) {
        for (int i = 0; i < views.length; i++) {
            View view = views[i];
            view.setAlpha(0f);
            view.animate()
                    .alpha(1f)
                    .setDuration(400)
                    .setStartDelay(i * 100)
                    .setInterpolator(new DecelerateInterpolator())
                    .start();
        }
    }

    private void setupClickListeners(View view) {
        view.findViewById(R.id.item_developer).setOnClickListener(v -> {
            Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("https://space.bilibili.com/394675616"));
            startActivity(browserIntent);
        });

        view.findViewById(R.id.item_share).setOnClickListener(v -> {
            Intent shareIntent = new Intent(Intent.ACTION_SEND);
            shareIntent.setType("text/plain");
            String shareBody = "养马太累了？看看“风灵月影”吧: " + getString(R.string.app_name) + "\nhttps://github.com/youshen2/EraUmaEditor/releases";
            shareIntent.putExtra(Intent.EXTRA_SUBJECT, getString(R.string.app_name));
            shareIntent.putExtra(Intent.EXTRA_TEXT, shareBody);
            startActivity(Intent.createChooser(shareIntent, "分享"));
        });

        view.findViewById(R.id.item_open_source).setOnClickListener(v -> {
            Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("https://github.com/youshen2/EraUmaEditor"));
            startActivity(browserIntent);
        });
    }

    private String getAppVersion() {
        try {
            PackageInfo pInfo = requireContext().getPackageManager().getPackageInfo(requireContext().getPackageName(), 0);
            return "Version " + pInfo.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return "Version N/A";
        }
    }
}
