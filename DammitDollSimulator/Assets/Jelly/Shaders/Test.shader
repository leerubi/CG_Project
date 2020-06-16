//Shader "Instanced/InstancedParticle" {
//    Properties{
//        _Colour("Colour", COLOR) = (1, 1, 1, 1)
//        _Size("Size", float) = 0.035
//        _MainTex("Texture", 2D) = "white" {}
//    }
//
//        SubShader{
//            Pass {
//        //Tags { "LightMode"="ForwardBase" "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }
//        ZWrite Off
//        Blend SrcAlpha OneMinusSrcAlpha
//
//        CGPROGRAM
//
//        #pragma glsl
//        #pragma vertex vert
//        #pragma fragment frag
//        #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
//        #pragma target 4.5
//
//        #include "UnityCG.cginc"
//
//        // matches the structure of our data on the CPU side
//        //struct Particle {
//        //    float2 x;
//        //    float2 v;
//        //    float4 C;
//        //    float mass;
//        //    float padding;
//        //};
//
//        struct Particle {
//            float3 x;
//            float3 v;
//            float3x3 C;
//            float mass;
//            float padding;
//        };
//
//        struct v2f {
//            float4 pos : SV_POSITION;
//            float2 uv : TEXCOORD0;
//        };
//
//        float _Size;
//        fixed4 _Colour;
//        sampler2D _MainTex;
//
//        StructuredBuffer<Particle> particle_buffer;
//
//        v2f vert(appdata_full v, uint instanceID : SV_InstanceID) {
//            // take in data from the compute buffer, filled with data each frame in SimRenderer
//            // offsetting and scaling it from the (0...grid_res, 0...grid_res) resolution of our sim into a nicer range for rendering
//            //float4 data = float4((particle_buffer[instanceID].x.xy - float2(32, 32)) * 0.1, 0, 1.0);
//            float4 data = float4((particle_buffer[instanceID].x.xyz - float3(32, 32, 32)) * 0.1, 1.0);
//
//            // Scaling vertices by our base size param (configurable in the material) and the mass of the particle
//            float3 localPosition = v.vertex.xyz * (_Size * data.w);
//            float3 worldPosition = data.xyz + localPosition;
//
//            // project into camera space
//            v2f o;
//            o.pos = mul(UNITY_MATRIX_VP, float4(worldPosition, 1.0f));
//
//            int grid_res = 16;
//            int x = instanceID / (grid_res * grid_res);
//            int y = (instanceID - (x * grid_res * grid_res)) / grid_res;
//            int z = instanceID - (x * grid_res * grid_res) - (y * grid_res);
//            o.uv = float3(x / (float)grid_res, y / (float)grid_res, z / (float)grid_res);
//
//            return o;
//        }
//
//        fixed4 frag(v2f i) : SV_Target {
//            fixed4 col = tex2D(_MainTex, i.uv);
//            return col;
//            //return _Colour;
//        }
//
//        ENDCG
//    }
//    }
//}

Shader "Instanced/InstancedParticle" {
    Properties{
        _Colour("Colour", COLOR) = (1, 1, 1, 1)
        _Size("Size", float) = 0.035
    }

        SubShader{
            Pass {
        Tags { "LightMode"="ForwardBase" "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        CGPROGRAM

        #pragma glsl
        #pragma vertex vert
        #pragma fragment frag
        #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
        #pragma target 4.5

        #include "UnityCG.cginc"

        struct Particle {
            float3 x;
            float3 v;
            float3x3 C;
            float mass;
            float padding;
            int colorNum;
        };

        struct v2f {
            float4 pos : SV_POSITION;
            fixed4 color : COLOR;
        };

        float _Size;
        float4 _Colour;
        sampler2D _MainTex;

        StructuredBuffer<Particle> particle_buffer;

        v2f vert(appdata_full v, uint instanceID : SV_InstanceID) {
            // take in data from the compute buffer, filled with data each frame in SimRenderer
            // offsetting and scaling it from the (0...grid_res, 0...grid_res) resolution of our sim into a nicer range for rendering
            //float4 data = float4((particle_buffer[instanceID].x.xy - float2(32, 32)) * 0.1, 0, 1.0);
            float4 data = float4((particle_buffer[instanceID].x.xyz - float3(32, 32, 32)) * 0.1, 1.0);

            // Scaling vertices by our base size param (configurable in the material) and the mass of the particle
            float3 localPosition = v.vertex.xyz * (_Size * data.w);
            float3 worldPosition = data.xyz + localPosition;

            // project into camera space
            v2f o;
            o.pos = mul(UNITY_MATRIX_VP, float4(worldPosition, 1.0f));
            o.color = float4(0.843f, 0.392f, 0.224f, 1.0f);
            
            const int yellow = 0;
            const int brown = 1;
            const int green = 2;

            if (particle_buffer[instanceID].colorNum == yellow)
            {
                // yellow shirts
                o.color = float4(0.918f, 0.659f, 0.149f, 1.0f);
            }
            else if (particle_buffer[instanceID].colorNum == brown)
            {
                // brown body
                o.color = float4(0.843f, 0.392f, 0.224f, 1.0f);
            }
            else if (particle_buffer[instanceID].colorNum == green)
            {
                // green pants
                o.color = float4(0.0f, 0.627f, 0.275f, 1.0f);
            }

            return o;
        }

        fixed4 frag(v2f i) : SV_Target {

            // _Colour = float4(0.918f, 0.659f, 0.149f, 1.0f);



            return i.color;
        }

        ENDCG
    }
    }
}

//Shader "Instanced/InstancedParticle"
//{
//	Properties
//	{
//		_MainTex("Albedo (RGB)", 2D) = "white" {}
//		_Color("Color", Color) = (1,1,1,1)
//	}
//		SubShader
//		{
//			Tags { "RenderType" = "Opaque" }
//
//			CGPROGRAM
//
//			#pragma surface surf Lambert noambient
//
//			sampler2D _MainTex;
//			float4 _Color;
//			struct Input
//			{
//				float2 uv_MainTex;
//			};
//
//
//		void surf(Input IN, inout SurfaceOutput o)
//		{
//			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
//			o.Albedo = c.rgb;
//
//		}
//		ENDCG
//		}
//			FallBack "Diffuse"
//}

//Shader "Instanced/InstancedParticle"
//{
//	Properties
//	{
//		_MainTex("Albedo (RGB)", 2D) = "white" {}
//		_Color("Color", Color) = (1,1,1,1)
//		_SpecColor("SpecColor", Color) = (1,1,1,1)
//	}
//		SubShader
//		{
//			Tags { "RenderType" = "Opaque" }
//
//			CGPROGRAM
//
//			#pragma surface surf BlinnPhong noambient
//
//			sampler2D _MainTex;
//			float4 _Color;
//			struct Input
//			{
//				float2 uv_MainTex;
//			};
//
//
//		void surf(Input IN, inout SurfaceOutput o)
//		{
//			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
//			o.Albedo = c.rgb;
//			o.Specular = 1.0f * _SpecColor;
//			o.Gloss = 1.0f;
//
//		}
//		ENDCG
//		}
//			FallBack "Diffuse"
//}

Shader "Instanced/InstancedParticle"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            CGPROGRAM
            // Physically based Standard lighting model, and enable shadows on all light types
            #pragma surface surf Standard fullforwardshadows

            // Use shader model 3.0 target, to get nicer looking lighting
            #pragma target 3.0

            sampler2D _MainTex;

            struct Input
            {
                float2 uv_MainTex;
            };

            half _Glossiness;
            half _Metallic;
            fixed4 _Color;

            // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
            // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
            // #pragma instancing_options assumeuniformscaling
            UNITY_INSTANCING_BUFFER_START(Props)
                // put more per-instance properties here
            UNITY_INSTANCING_BUFFER_END(Props)

            void surf(Input IN, inout SurfaceOutputStandard o)
            {
                // Albedo comes from a texture tinted by color
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
                o.Albedo = c.rgb;
                // Metallic and smoothness come from slider variables
                o.Metallic = _Metallic;
                o.Smoothness = _Glossiness;
                o.Alpha = c.a;
            }
            ENDCG
        }
            FallBack "Diffuse"
}


Shader "Test/FragmentLambert"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
        SubShader
    {
        Pass
        {
            Tags {"LightMode" = "ForwardBase"}
            CGPROGRAM

         #pragma vertex vert
         #pragma fragment frag
         # include "UnityCG.cginc"
         # include "Lighting.cginc"
        // # include "UnityLightingCommon.cginc"       
         #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
         # include "AutoLight.cginc"

            struct v2f
           {
                float2 uv : TEXCOORD0;
               SHADOW_COORDS(1) // put shadows data into TEXCOORD1
                fixed3 diff : COLOR0;
                fixed3 ambient : COLOR1;
                float4 pos : SV_POSITION;
            };

          v2f vert(appdata_base v)
           {
             v2f o;
             o.pos = UnityObjectToClipPos(v.vertex);
             o.uv = v.texcoord;
             half3 worldNormal = UnityObjectToWorldNormal(v.normal);
             half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
             o.diff = nl * _LightColor0.rgb;
             // o.diff.rgb += ShadeSH9(half4(worldNormal, 1));  
               o.ambient = ShadeSH9(half4(worldNormal, 1));

               // compute shadows data
               TRANSFER_SHADOW(o)
               return o;
               }

               sampler2D _MainTex;

              fixed4 frag(v2f i) : SV_Target
               {
                 fixed4 col = tex2D(_MainTex, i.uv);
              // compute shadow attenuation (1.0 = fully lit, 0.0 = fully shadowed)
             fixed shadow = SHADOW_ATTENUATION(i);
             // darken light's illumination with shadow, keep ambient intact
            fixed3 lighting = i.diff * shadow + i.ambient;
            col.rgb *= lighting;

            return col;
           }
           ENDCG
       }
        // shadow casting support
        // UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
        // Shadow pass를 추가하지 않고 이렇게 UsePass도 대체할수 있다.

      Pass
      {

        Tags { "LightMode" = "ShadowCaster"}

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma multi_compile_shadowcaster
        # include "UnityCG.cginc"

           struct v2f
          {
        V2F_SHADOW_CASTER;
          };

        v2f vert(appdata_base v)
          {

           v2f o;
          TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)

          return o;
       }

         float4 frag(v2f i) : SV_Target
              {
                SHADOW_CASTER_FRAGMENT(i)
              }

              ENDCG
          }

    }
}