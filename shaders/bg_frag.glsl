// This is a direct translation of the original AGSL shader.
#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform float uAnimTime;

// Custom uniforms to match the original shader
uniform vec4 uBound;
uniform float uTranslateY;
uniform vec3 uPoints[4];
uniform vec4 uColors[4];
uniform float uAlphaMulti;
uniform float uNoiseScale;
uniform float uPointOffset;
uniform float uPointRadiusMulti;
uniform float uSaturateOffset;
uniform float uLightOffset;

out vec4 fragColor;

// Utility functions from the original shader
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

float hash(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.13);
    p3 += dot(p3, p3.yzx + 3.333);
    return fract((p3.x + p3.y) * p3.z);
}

float perlin(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main() {
    vec2 vUv = FlutterFragCoord().xy / uResolution;
    vec2 uv = vUv;
    uv -= vec2(0., uTranslateY);
    uv.xy -= uBound.xy;
    uv.xy /= uBound.zw;

    vec4 color = vec4(0.0);
    float noiseValue = perlin(vUv * uNoiseScale + vec2(-uAnimTime, -uAnimTime));

    for (int i = 0; i < 4; i++) {
        vec4 pointColor = uColors[i];
        pointColor.rgb *= pointColor.a;
        vec2 point = uPoints[i].xy;
        float rad = uPoints[i].z * uPointRadiusMulti;

        point.x += sin(uAnimTime + point.y) * uPointOffset;
        point.y += cos(uAnimTime + point.x) * uPointOffset;

        float d = distance(uv, point);
        float pct = smoothstep(rad, 0., d);

        color.rgb = mix(color.rgb, pointColor.rgb, pct);
        color.a = mix(color.a, pointColor.a, pct);
    }

    if (color.a > 0.0) {
        float oppositeNoise = smoothstep(0., 1., noiseValue);
        color.rgb /= color.a;
        vec3 hsv = rgb2hsv(color.rgb);
        hsv.y = mix(hsv.y, 0.0, oppositeNoise * uSaturateOffset);
        color.rgb = hsv2rgb(hsv);
        color.rgb += oppositeNoise * uLightOffset;
        color.a = clamp(color.a, 0., 1.);
        color.a *= uAlphaMulti;
    }

    fragColor = vec4(color.rgb * color.a, color.a);
}
