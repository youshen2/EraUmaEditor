package moye.erauma.editor.ui;

/*
 * 动态背景的代码来自HyperCeiler
 * 感谢HyperCeiler提供的帮助
 */

/*
 * This file is part of HyperCeiler.

 * HyperCeiler is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.

 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.

 * Copyright (C) 2023-2025 HyperCeiler Contributions
 */

import android.content.Context;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.RenderEffect;
import android.graphics.RuntimeShader;
import android.os.Build;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.RequiresApi;

import java.io.InputStream;
import java.util.Scanner;

import moye.erauma.editor.R;

@RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
public class BgEffectPainter {
    private final RuntimeShader mBgRuntimeShader;
    private float[] uResolution;
    private float uAnimTime = 0.0f;
    private float[] uBound;

    private final boolean isLunarNewYearThemeView = false;

    public BgEffectPainter(Context context) {
        Resources resources = context.getResources();
        String shaderCode = loadShader(resources, R.raw.bg_frag);
        if (shaderCode == null) {
            mBgRuntimeShader = null;
            Log.e("BgEffectPainter", "Failed to load shader code.");
            return;
        }
        mBgRuntimeShader = new RuntimeShader(shaderCode);
        initializeDefaultUniforms();
    }

    private void initializeDefaultUniforms() {
        if (mBgRuntimeShader == null) return;
        mBgRuntimeShader.setFloatUniform("uTranslateY", 0.0f);
        mBgRuntimeShader.setFloatUniform("uPoints", new float[]{0.67f, 0.42f, 1.0f, 0.69f, 0.75f, 1.0f, 0.14f, 0.71f, 0.95f, 0.14f, 0.27f, 0.8f});
        mBgRuntimeShader.setFloatUniform("uColors", new float[]{0.57f, 0.76f, 0.98f, 1.0f, 0.98f, 0.85f, 0.68f, 1.0f, 0.98f, 0.75f, 0.93f, 1.0f, 0.73f, 0.7f, 0.98f, 1.0f});
        mBgRuntimeShader.setFloatUniform("uNoiseScale", 1.5f);
        mBgRuntimeShader.setFloatUniform("uPointOffset", 0.1f);
        mBgRuntimeShader.setFloatUniform("uPointRadiusMulti", 1.0f);
        mBgRuntimeShader.setFloatUniform("uSaturateOffset", 0.2f);
        mBgRuntimeShader.setFloatUniform("uLightOffset", 0.1f);
        mBgRuntimeShader.setFloatUniform("uAlphaOffset", 0.5f);
        mBgRuntimeShader.setFloatUniform("uAlphaMulti", 1.0f);
    }

    public RenderEffect getRenderEffect() {
        if (mBgRuntimeShader == null) return null;
        return RenderEffect.createRuntimeShaderEffect(mBgRuntimeShader, "uTex");
    }

    public void updateMaterials() {
        if (mBgRuntimeShader == null) return;
        mBgRuntimeShader.setFloatUniform("uAnimTime", uAnimTime);
        mBgRuntimeShader.setFloatUniform("uResolution", uResolution);
    }

    public void setAnimTime(float time) {
        uAnimTime = time;
    }

    public void setResolution(float[] resolution) {
        this.uResolution = resolution;
    }

    public void showRuntimeShader(Context context, View view) {
        if (mBgRuntimeShader == null) return;
        calcAnimationBound(context, view);

        int nightModeFlags = context.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK;
        if (nightModeFlags == Configuration.UI_MODE_NIGHT_YES) {
            setPhoneDark(this.uBound);
        } else {
            setPhoneLight(this.uBound);
        }
    }

    private void setColors(float[] fArr) { mBgRuntimeShader.setFloatUniform("uColors", fArr); }
    private void setPoints(float[] fArr) { mBgRuntimeShader.setFloatUniform("uPoints", fArr); }
    private void setBound(float[] fArr) { this.uBound = fArr; mBgRuntimeShader.setFloatUniform("uBound", fArr); }
    private void setLightOffset(float f) { mBgRuntimeShader.setFloatUniform("uLightOffset", f); }
    private void setSaturateOffset(float f) { mBgRuntimeShader.setFloatUniform("uSaturateOffset", f); }

    private void setPhoneLight(float[] fArr) {
        setLightOffset(0.1f);
        setSaturateOffset(0.2f);
        setPoints(new float[]{0.67f, 0.42f, 1.0f, 0.69f, 0.75f, 1.0f, 0.14f, 0.71f, 0.95f, 0.14f, 0.27f, 0.8f});
        if (isLunarNewYearThemeView) {
            setColors(new float[]{1.0f, 0.83f, 0.68f, 1.0f, 0.92f, 0.56f, 0.47f, 1.0f, 0.98f, 0.74f, 0.72f, 1.0f, 1.0f, 0.62f, 0.53f, 1.0f});
        } else {
            setColors(new float[]{0.57f, 0.76f, 0.98f, 1.0f, 0.98f, 0.85f, 0.68f, 1.0f, 0.98f, 0.75f, 0.93f, 1.0f, 0.73f, 0.7f, 0.98f, 1.0f});
        }
        setBound(fArr);
    }

    private void setPhoneDark(float[] fArr) {
        setLightOffset(-0.1f);
        setSaturateOffset(0.2f);
        setPoints(new float[]{0.63f, 0.5f, 0.88f, 0.69f, 0.75f, 0.8f, 0.17f, 0.66f, 0.81f, 0.14f, 0.24f, 0.72f});
        if (isLunarNewYearThemeView) {
            setColors(new float[]{0.58f, 0.4f, 0.28f, 1.0f, 0.48f, 0.12f, 0.1f, 1.0f, 0.56f, 0.28f, 0.12f, 1.0f, 0.46f, 0.16f, 0.11f, 1.0f});
        } else {
            setColors(new float[]{0.0f, 0.31f, 0.58f, 1.0f, 0.53f, 0.29f, 0.15f, 1.0f, 0.46f, 0.06f, 0.27f, 1.0f, 0.16f, 0.12f, 0.45f, 1.0f});
        }
        setBound(fArr);
    }

    private void calcAnimationBound(Context context, View view) {
        float animationAreaHeight = 530 * context.getResources().getDisplayMetrics().density;

        if (view.getParent() instanceof ViewGroup) {
            ViewGroup parent = (ViewGroup) view.getParent();
            float parentHeight = parent.getHeight();
            float parentWidth = parent.getWidth();

            if (parentHeight > 0 && parentWidth > 0) {
                float heightRatio = animationAreaHeight / parentHeight;
                this.uBound = new float[]{0.0f, 1.0f - heightRatio, 1.0f, heightRatio};
                return;
            }
        }
        this.uBound = new float[]{0.0f, 0.5f, 1.0f, 0.5f};
    }

    private String loadShader(Resources resources, int resId) {
        try (InputStream inputStream = resources.openRawResource(resId);
             Scanner scanner = new Scanner(inputStream).useDelimiter("\\A")) {
            return scanner.hasNext() ? scanner.next() : "";
        } catch (Exception e) {
            Log.e("BgEffectPainter", "Could not read shader file.", e);
            return null;
        }
    }
}
