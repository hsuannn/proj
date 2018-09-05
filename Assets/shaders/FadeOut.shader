Shader "Sprites/FadeOut"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,0.5)
        _FadeEnd ("Fade End (fade range)", Float) = 0.4
        _FadeOrigin ("Fade Origin (offset)", Float) = 0.18
        _FadeStart ("Fade Start (height)", Float) = 0.0
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
    }
 
    SubShader
    {
        Tags
        { 
            "Queue"="Transparent" 
            "IgnoreProjector"="True" 
            "RenderType"="Transparent" 
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }
 
        Cull Off
        Lighting Off
        ZWrite Off
        Fog { Mode Off }
        Blend SrcAlpha OneMinusSrcAlpha
 
        
        CGPROGRAM
        #pragma surface surf Lambert alpha vertex:vert
        //#pragma fragment frag
        #pragma multi_compile DUMMY PIXELSNAP_ON
        #include "UnityCG.cginc"

        fixed4 _Color;

        struct Input
        {
            float2 uv_MainTex;
            fixed4 color;
        };

        float _FadeStart;
        float _FadeEnd;
        float _FadeOrigin;
        
        void vert (inout appdata_full v, out Input o)
        {
            #if defined(PIXELSNAP_ON) && !defined(SHADER_API_FLASH)
            v.vertex = UnityPixelSnap (v.vertex);
            #endif
            v.normal = float3(0,0,-1);
            o.color = v.color * _Color;
            o.uv_MainTex = v.vertex.xy / v.vertex.w;

            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.color = _Color;
        }

        sampler2D _MainTex;

        void surf (Input IN, inout SurfaceOutput o)
        {
            float r = _FadeEnd - _FadeStart;
            float a = clamp((abs(IN.uv_MainTex.y - _FadeOrigin) - _FadeStart), 0, r) / r;
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * IN.color;
            o.Albedo = c.rgb;
            o.Alpha = c.a-a;
        }

    ENDCG
    }
}

