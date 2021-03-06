Shader "Unlit/Simple Water"
{
	Properties
	{
		_Color("Tint", Color) = (1, 1, 1, 1)
		_FoamC("Foam", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture", 2D) = "white" {}
		_TextureDistort("Texture Wobble", range(0,1)) = 0.1
		_NoiseTex("Extra Wave Noise", 2D) = "white" {}
		_Speed("Wave Speed", Range(0,1)) = 0.5
		_Amount("Wave Amount", Range(0,1)) = 0.6
		_Scale("Scale", Range(0,1)) = 0.5
		_Height("Wave Height", Range(0,1)) = 0.1
		_Foam("Foamline Thickness", Range(0,10)) = 8
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque"  "Queue" = "Transparent" "RenderPipeline" = "UniversalPipeline"}
		LOD 100
		Blend OneMinusDstColor One
		Cull Off

		Pass
		{
			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			//#include "UnityCG.cginc"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD3;
				float fogCoords : TEXCOORD1;
				float4 vertex : SV_POSITION;
				float4 scrPos : TEXCOORD2;//
				float4 worldPos : TEXCOORD4;//
			};
			CBUFFER_START(UnityPerMaterial)
			float _TextureDistort;
			float4 _Color;
			Texture2D _CameraDepthTexture; SamplerState sampler_CameraDepthTexture;//Depth Texture
			sampler2D _MainTex, _NoiseTex;//
			float4 _MainTex_ST;
			float _Speed, _Amount, _Height, _Foam, _Scale;// 
			float4 _FoamC;
			CBUFFER_END

			uniform float3 _Position;
			uniform sampler2D _GlobalEffectRT;
			uniform float _OrthographicCamSize;

			v2f vert(appdata v)
			{
				v2f o;
				//UNITY_INITIALIZE_OUTPUT(v2f, o);
				float4 tex = tex2Dlod(_NoiseTex, float4(v.uv.xy, 0, 0));//extra noise tex
				v.vertex.y += sin(_Time.z * _Speed + (v.vertex.x * v.vertex.z * _Amount * tex)) * _Height;//movement
				//o.vertex = UnityObjectToClipPos(v.vertex);
				VertexPositionInputs vertInputs = GetVertexPositionInputs(v.vertex.xyz);    //This function calculates all the relative spaces of the objects vertices
				o.vertex = vertInputs.positionCS;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.scrPos = ComputeScreenPos(o.vertex);
				//UNITY_TRANSFER_FOG(o,o.vertex);
				o.fogCoords = ComputeFogFactor(o.vertex.z);
				
				return o;
			}

			half4 frag(v2f i) : SV_Target
			{
				// rendertexture UV
				float2 uv = i.worldPos.xz - _Position.xz;
				uv = uv / (_OrthographicCamSize * 2);
				uv += 0.5;
				// Ripples
				float ripples = tex2D(_GlobalEffectRT, uv).b;

				// sample the texture
				half4 distortx = tex2D(_NoiseTex, (i.worldPos.xz * _Scale) + (_Time.x * 2)).r;// distortion alpha
				distortx += (ripples * 2);

				half4 col = tex2D(_MainTex, (i.worldPos.xz * _Scale) - (distortx * _TextureDistort));// texture times tint;			
				half depth = LinearEyeDepth(_CameraDepthTexture.Sample(sampler_CameraDepthTexture, i.scrPos.xy / i.scrPos.w).r, _ZBufferParams); // depth
				half4 foamLine = 1 - saturate(_Foam* (depth - i.scrPos.w));// foam line by comparing depth and screenposition
				//col = (col.rgb[0] + col.rgb[1] + col.rgb[2] == 3)? col : col * _Color;
				col *= _Color;
				col += (step(0.4 * distortx,foamLine) * _FoamC); // add the foam line and tint to the texture
				col = saturate(col) * col.a;

				ripples = step(0.99, ripples * 3);
				float4 ripplesColored = ripples * _FoamC;

				return saturate(col + ripplesColored);
			}
			ENDHLSL
		}
	}
}