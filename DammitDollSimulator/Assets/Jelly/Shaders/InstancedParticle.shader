Shader "Instanced/InstancedParticle" {
    Properties{
        _Colour("Colour", COLOR) = (1, 1, 1, 1)
        _Size("Size", float) = 0.035
    }

        SubShader{
            Pass {
       Tags { "LightMode" = "ForwardBase" "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }
       ZWrite Off
       Blend SrcAlpha OneMinusSrcAlpha

       CGPROGRAM

       #pragma glsl
       #pragma vertex vert
       #pragma fragment frag
       #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
       #pragma target 4.5

       #include "UnityCG.cginc"
       #include "UnityLightingCommon.cginc"
       #include "AutoLight.cginc"


        // matches the structure of our data on the CPU side
        struct Particle {
            float3 x;
            float3 v;
            float3x3 C;
            float mass;
            float padding;
            int colorNum;

        };

    //#if SHADER_TARGET >= 45
    //    StructuredBuffer<float4> positionBuffer;
    //#endif

    struct v2f {
        float4 pos : SV_POSITION;
        //float2 uv : TEXCOORD0;
        fixed4 color : COLOR;
        float3 ambient : TEXCOORD1;
        float3 diffuse : TEXCOORD2;
        //float3 color : TEXCOORD3;
        SHADOW_COORDS(3)
        };

        void rotate2D(inout float2 v, float r)
        {
            float s, c;
            sincos(r, s, c);
            v = float2(v.x * c - v.y * s, v.x * s + v.y * c);
        }

        float _Size;
        fixed4 _Colour;

        StructuredBuffer<Particle> particle_buffer;

        v2f vert(appdata_full v, uint instanceID : SV_InstanceID) {
            // take in data from the compute buffer, filled with data each frame in SimRenderer
            // offsetting and scaling it from the (0...grid_res, 0...grid_res) resolution of our sim into a nicer range for rendering

            float4 data = float4((particle_buffer[instanceID].x.xyz - float3(32, 32, 32)) * 0.1, 1.0);

            // Scaling vertices by our base size param (configurable in the material) and the mass of the particle
            float3 localPosition = v.vertex.xyz * (_Size * data.w);
            float3 worldPosition = data.xyz + localPosition;

            // Calculate light equations
            float3 worldNormal = v.normal;
            float3 ndotl = saturate(dot(worldNormal, _WorldSpaceLightPos0.xyz));
            float3 ambient = ShadeSH9(float4(worldNormal, 1.0f));
            float3 diffuse = (ndotl * _LightColor0.rgb);
            float3 color = v.color;

            // project into camera space
            v2f o;
            o.pos = mul(UNITY_MATRIX_VP, float4(worldPosition, 1.0f)); //o.pos = UnityObjectToClipPos(v.vertex);

            // color mapping
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

            o.ambient = ambient;
            o.diffuse = diffuse;
            TRANSFER_SHADOW(o)

            return o;
        }

        fixed4 frag(v2f i) : SV_Target {
            fixed shadow = SHADOW_ATTENUATION(i);
            float3 lighting = i.diffuse * shadow + i.ambient;
            fixed4 output = fixed4(i.color * lighting, 1.0f);
            UNITY_APPLY_FOG(i.fogCoord, output);
            return output;

            /*float3 lighting = i.diffuse + i.ambient;
            fixed4 output = fixed4(i.color * lighting, 1.0f);
            UNITY_APPLY_FOG(i.fogCoord, output);
            return output;*/

        }

        ENDCG
    }
    }
}