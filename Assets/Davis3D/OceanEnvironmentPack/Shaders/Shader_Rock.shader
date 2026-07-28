// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Davis3D/OceanEnviroment/Shader_Rock"
{
	Properties
	{
		_Diffuse("Diffuse", 2D) = "white" {}
		_DiffuseMultiply("Diffuse Multiply", Color) = (1,1,1,0)
		_DiffuseBrightness("Diffuse Brightness", Float) = 2.5
		_Normal("Normal", 2D) = "bump" {}
		_NormalDetail("NormalDetail", 2D) = "bump" {}
		_NormalDetailIntensity("Normal Detail Intensity", Float) = 1
		_NormalDetailScale("Normal Detail Scale", Float) = 6
		_MicroDetail("MicroDetail", 2D) = "white" {}
		_MicroDetailIntensity("MicroDetail Intensity", Float) = 3
		_MicroDetailScale("MicroDetail Scale", Float) = 0.5
		_SandAmount("Sand Amount", Float) = 1
		_SandColorOverrideColor("Sand Color - Override Color", Color) = (0.8627451,0.8117647,0.5921569,0)
		_SandMask("Sand Mask", 2D) = "white" {}
		_SandMaskScale("Sand Mask Scale", Float) = 5
		_SandMaskAmount("Sand Mask Amount", Float) = 1
		_SandNormal("Sand Normal", 2D) = "bump" {}
		_SandNormalScale2("Sand Normal Scale 2", Float) = 12
		_SandNormalScale1("Sand Normal Scale 1", Float) = 4
		_Sand_MASTER_UV_Scale("Sand_MASTER_UV_Scale", Float) = 10
		_SandBrightness("Sand Brightness", Float) = 2
		_SpecularA("Specular A", Float) = -3
		_SpecularSand("Specular Sand", Float) = 0
		_SpecularB("Specular B", Float) = 2
		_SandSmoothness("Sand Smoothness", Float) = 1
		_SmoothnessA("Smoothness A", Float) = 1
		_SmoothnessB("Smoothness B", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _NormalDetail;
		uniform float _NormalDetailScale;
		uniform float _NormalDetailIntensity;
		uniform sampler2D _SandNormal;
		uniform float _Sand_MASTER_UV_Scale;
		uniform float _SandNormalScale1;
		uniform float _SandNormalScale2;
		uniform float _SandAmount;
		uniform sampler2D _SandMask;
		uniform float _SandMaskScale;
		uniform float _SandMaskAmount;
		uniform sampler2D _MicroDetail;
		uniform float _MicroDetailScale;
		uniform float _MicroDetailIntensity;
		uniform sampler2D _Diffuse;
		uniform float4 _Diffuse_ST;
		uniform float4 _DiffuseMultiply;
		uniform float _DiffuseBrightness;
		uniform float4 _SandColorOverrideColor;
		uniform float _SandBrightness;
		uniform float _SpecularA;
		uniform float _SpecularB;
		uniform float _SpecularSand;
		uniform float _SmoothnessA;
		uniform float _SmoothnessB;
		uniform float _SandSmoothness;


		inline float4 TriplanarSampling70( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 tex2DNode98 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 temp_cast_0 = (_NormalDetailScale).xx;
			float2 uv_TexCoord50 = i.uv_texcoord * temp_cast_0;
			float2 temp_cast_1 = (( _Sand_MASTER_UV_Scale * _SandNormalScale1 )).xx;
			float2 uv_TexCoord55 = i.uv_texcoord * temp_cast_1;
			float2 temp_cast_2 = (( _Sand_MASTER_UV_Scale * _SandNormalScale2 )).xx;
			float2 uv_TexCoord59 = i.uv_texcoord * temp_cast_2;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float dotResult247 = dot( ase_normWorldNormal , float3( 0,1,0 ) );
			float clampResult248 = clamp( dotResult247 , 0.0 , 1.0 );
			float clampResult43 = clamp( ( ( ( clampResult248 * tex2DNode98.b ) * 2.0 ) * _SandAmount ) , 0.0 , 1.0 );
			float2 temp_cast_3 = (_SandMaskScale).xx;
			float2 uv_TexCoord49 = i.uv_texcoord * temp_cast_3;
			float lerpResult51 = lerp( 1.0 , tex2D( _SandMask, uv_TexCoord49 ).g , _SandMaskAmount);
			float temp_output_44_0 = ( clampResult43 * lerpResult51 );
			float3 lerpResult6 = lerp( BlendNormals( tex2DNode98 , UnpackScaleNormal( tex2D( _NormalDetail, uv_TexCoord50 ), _NormalDetailIntensity ) ) , BlendNormals( UnpackNormal( tex2D( _SandNormal, uv_TexCoord55 ) ) , UnpackNormal( tex2D( _SandNormal, uv_TexCoord59 ) ) ) , temp_output_44_0);
			o.Normal = lerpResult6;
			float2 temp_cast_4 = (_MicroDetailScale).xx;
			float3 ase_worldPos = i.worldPos;
			float4 triplanar70 = TriplanarSampling70( _MicroDetail, ase_worldPos, ase_worldNormal, 1.0, temp_cast_4, 1.0, 0 );
			float lerpResult74 = lerp( 1.0 , ( triplanar70.y + 0.5 ) , _MicroDetailIntensity);
			float2 uv_Diffuse = i.uv_texcoord * _Diffuse_ST.xy + _Diffuse_ST.zw;
			float4 tex2DNode2 = tex2D( _Diffuse, uv_Diffuse );
			float4 temp_output_250_0 = ( _SandColorOverrideColor * _SandBrightness );
			float4 lerpResult36 = lerp( ( lerpResult74 * ( tex2DNode2 * _DiffuseMultiply * _DiffuseBrightness ) ) , temp_output_250_0 , temp_output_44_0);
			o.Albedo = lerpResult36.rgb;
			float lerpResult77 = lerp( _SpecularA , _SpecularB , tex2DNode2.a);
			float clampResult249 = clamp( lerpResult77 , 0.1 , 1.0 );
			float lerpResult78 = lerp( clampResult249 , _SpecularSand , temp_output_44_0);
			float3 temp_cast_6 = (lerpResult78).xxx;
			o.Specular = temp_cast_6;
			float lerpResult89 = lerp( _SmoothnessA , _SmoothnessB , tex2DNode2.a);
			float lerpResult87 = lerp( lerpResult89 , _SandSmoothness , temp_output_44_0);
			o.Smoothness = lerpResult87;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.WorldNormalVector;246;-3318.267,-106.6202;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;3;-2775.362,795.3039;Inherit;True;Property;_Normal;Normal;3;0;Create;True;0;0;0;False;0;False;abc00000000000746726904355842572;abc00000000000746726904355842572;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DotProductOpNode;247;-3066.267,-65.62016;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;248;-2900.267,-7.620163;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;98;-2466.841,802.1516;Inherit;True;Property;_T_Rocks_AB_New_Norm;T_Rocks_AB_New_Norm;35;0;Create;True;0;0;0;False;0;False;-1;abc00000000000746726904355842572;abc00000000000746726904355842572;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-2628.651,183.3249;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-3210.154,651.4612;Inherit;False;Property;_SandMaskScale;Sand Mask Scale;15;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-1802.208,-828.1311;Inherit;True;Property;_Diffuse;Diffuse;0;0;Create;True;0;0;0;False;0;False;abc00000000003537318495103793257;abc00000000003537318495103793257;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;46;-3024.154,438.4612;Inherit;True;Property;_SandMask;Sand Mask;14;0;Create;True;0;0;0;False;0;False;abc00000000000470720041989946782;abc00000000000746726904355842572;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;65;-3130.631,1513.842;Inherit;False;Property;_SandNormalScale1;Sand Normal Scale 1;19;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-4051.489,552.9134;Inherit;False;Property;_Sand_MASTER_UV_Scale;Sand_MASTER_UV_Scale;20;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-2447.901,183.875;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2397.641,304.8134;Inherit;False;Property;_SandAmount;Sand Amount;10;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;71;-1837.111,-1463.727;Inherit;True;Property;_MicroDetail;MicroDetail;7;0;Create;True;0;0;0;False;0;False;e582bb488f4502a40a1f9efc70e7d606;abc00000000003537318495103793257;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;72;-1819.15,-1278.614;Inherit;False;Property;_MicroDetailScale;MicroDetail Scale;9;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-3123.136,1674.937;Inherit;False;Property;_SandNormalScale2;Sand Normal Scale 2;18;0;Create;True;0;0;0;False;0;False;12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-2965.373,635.0085;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;70;-1529.048,-1346.304;Inherit;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;57;-3248.335,1123.328;Inherit;False;Property;_NormalDetailScale;Normal Detail Scale;6;0;Create;True;0;0;0;False;0;False;6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;48;-2738.154,435.5762;Inherit;True;Property;_TextureSample5;Texture Sample 5;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-2833.415,1683.678;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-2855.894,1453.899;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1542.803,-826.1196;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-2277.901,184.875;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-2505.478,624.5524;Inherit;False;Property;_SandMaskAmount;Sand Mask Amount;16;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-882.4072,316.0238;Inherit;False;Property;_SpecularA;Specular A;25;0;Create;True;0;0;0;False;0;False;-3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-3020.811,1110.178;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;8;-2783.052,1076.032;Inherit;True;Property;_NormalDetail;NormalDetail;4;0;Create;True;0;0;0;False;0;False;abc00000000004188447198822879912;abc00000000004188447198822879912;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;81;-866.1713,417.6725;Inherit;False;Property;_SpecularB;Specular B;27;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;43;-2098.231,186.4865;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-2597.841,1433.831;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;75;-1122.901,-1186.056;Inherit;False;Property;_MicroDetailIntensity;MicroDetail Intensity;8;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;54;-2360.082,1400.835;Inherit;True;Property;_SandNormal;Sand Normal;17;0;Create;True;0;0;0;False;0;False;abc00000000014048536414302893271;abc00000000004188447198822879912;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;18;-1478.253,-997.2553;Inherit;False;Property;_DiffuseMultiply;Diffuse Multiply;1;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;-2599.025,1669.067;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;-2735.967,1284.983;Inherit;False;Property;_NormalDetailIntensity;Normal Detail Intensity;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-1078.694,-1295.19;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1230.557,-685.1279;Inherit;False;Property;_DiffuseBrightness;Diffuse Brightness;2;0;Create;True;0;0;0;False;0;False;2.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;91;-1165.347,435.7612;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;51;-2276.046,471.5982;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;77;-618.5836,345.062;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;251;-1251.354,-18.37607;Inherit;False;Property;_SandBrightness;Sand Brightness;24;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;100;-2079.124,1390.106;Inherit;True;Property;_TextureSample18;Texture Sample 18;35;0;Create;True;0;0;0;False;0;False;-1;abc00000000000746726904355842572;abc00000000000746726904355842572;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;93;-1076.783,1035.574;Inherit;False;Property;_SmoothnessB;Smoothness B;30;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-1065.783,962.5742;Inherit;False;Property;_SmoothnessA;Smoothness A;29;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;74;-845.2297,-1314.53;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1881.231,194.4865;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;101;-2066.022,1638.635;Inherit;True;Property;_TextureSample17;Texture Sample 17;35;0;Create;True;0;0;0;False;0;False;-1;abc00000000000746726904355842572;abc00000000000746726904355842572;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;35;-1579.231,-51.8705;Inherit;False;Property;_SandColorOverrideColor;Sand Color - Override Color;13;0;Create;True;0;0;0;False;0;False;0.8627451,0.8117647,0.5921569,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1008.338,-825.039;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;99;-2454.321,1076.555;Inherit;True;Property;_TextureSample16;Texture Sample 16;35;0;Create;True;0;0;0;False;0;False;-1;abc00000000000746726904355842572;abc00000000000746726904355842572;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;53;-906.6838,171.0021;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;250;-1190.354,-138.3761;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;58;-1673.037,1439.995;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;89;-864.0785,999.3947;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-747.1478,-784.0541;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;249;-479.1226,203.7005;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-585.1713,516.6724;Inherit;False;Property;_SpecularSand;Specular Sand;26;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-933.0172,1131.577;Inherit;False;Property;_SandSmoothness;Sand Smoothness;28;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;5;-2106.262,943.8783;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;94;-1316.509,519.0244;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2730.172,-144.2993;Inherit;False;Property;_SandDiffuseDetailScale;Sand Diffuse Detail Scale;22;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;36;-742.9089,-276.2456;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;11;-1923.282,-535.3122;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;28;-2910.172,-279.2993;Inherit;False;True;True;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-2395.103,-447.0066;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2871.172,-441.2993;Inherit;False;Property;_SandDiffuseScale;Sand Diffuse Scale;21;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;6;-1538.301,899.0553;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;12;-1909.938,-211.9837;Inherit;True;Property;_TextureSample4;Texture Sample 4;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;-1553.172,-150.2993;Inherit;False;Property;_SandDesaturation;Sand Desaturation;23;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;27;-3101.172,-267.2993;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;13;-2211.183,-220.0474;Inherit;True;Property;_SandDetail;Sand Detail;12;0;Create;True;0;0;0;False;0;False;abc00000000018130809698958201829;abc00000000018130809698958201829;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;10;-2182.687,-537.3237;Inherit;True;Property;_SandDiffuse;Sand Diffuse;11;0;Create;True;0;0;0;False;0;False;abc00000000016260969062029517796;abc00000000016260969062029517796;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;78;-398.2876,372.5226;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;15;-1255.476,-298.9877;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2437.101,-234.0128;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1257.172,84.70074;Inherit;False;Property;_SandColorOverRide;Sand Color OverRide;31;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;-999.1724,-354.2993;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2577.172,-458.2993;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;14;-1510.389,-334.6087;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;87;-672.032,1096.644;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Davis3D/OceanEnviroment/Shader_Rock;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;247;0;246;0
WireConnection;248;0;247;0
WireConnection;98;0;3;0
WireConnection;39;0;248;0
WireConnection;39;1;98;3
WireConnection;40;0;39;0
WireConnection;49;0;47;0
WireConnection;70;0;71;0
WireConnection;70;3;72;0
WireConnection;48;0;46;0
WireConnection;48;1;49;0
WireConnection;64;0;26;0
WireConnection;64;1;66;0
WireConnection;63;0;26;0
WireConnection;63;1;65;0
WireConnection;2;0;1;0
WireConnection;41;0;40;0
WireConnection;41;1;42;0
WireConnection;50;0;57;0
WireConnection;43;0;41;0
WireConnection;55;0;63;0
WireConnection;59;0;64;0
WireConnection;73;0;70;2
WireConnection;91;0;2;4
WireConnection;51;1;48;2
WireConnection;51;2;52;0
WireConnection;77;0;80;0
WireConnection;77;1;81;0
WireConnection;77;2;91;0
WireConnection;100;0;54;0
WireConnection;100;1;55;0
WireConnection;74;1;73;0
WireConnection;74;2;75;0
WireConnection;44;0;43;0
WireConnection;44;1;51;0
WireConnection;101;0;54;0
WireConnection;101;1;59;0
WireConnection;16;0;2;0
WireConnection;16;1;18;0
WireConnection;16;2;20;0
WireConnection;99;0;8;0
WireConnection;99;1;50;0
WireConnection;99;5;69;0
WireConnection;53;0;44;0
WireConnection;250;0;35;0
WireConnection;250;1;251;0
WireConnection;58;0;100;0
WireConnection;58;1;101;0
WireConnection;89;0;92;0
WireConnection;89;1;93;0
WireConnection;89;2;91;0
WireConnection;76;0;74;0
WireConnection;76;1;16;0
WireConnection;249;0;77;0
WireConnection;5;0;98;0
WireConnection;5;1;99;0
WireConnection;94;0;44;0
WireConnection;36;0;76;0
WireConnection;36;1;250;0
WireConnection;36;2;53;0
WireConnection;11;0;10;0
WireConnection;11;1;24;0
WireConnection;28;0;27;0
WireConnection;24;0;29;0
WireConnection;24;1;28;0
WireConnection;6;0;5;0
WireConnection;6;1;58;0
WireConnection;6;2;44;0
WireConnection;12;0;13;0
WireConnection;12;1;25;0
WireConnection;78;0;249;0
WireConnection;78;1;82;0
WireConnection;78;2;94;0
WireConnection;15;0;14;0
WireConnection;15;1;32;0
WireConnection;25;0;31;0
WireConnection;25;1;28;0
WireConnection;33;0;15;0
WireConnection;33;1;250;0
WireConnection;33;2;34;0
WireConnection;29;0;26;0
WireConnection;29;1;30;0
WireConnection;14;0;11;0
WireConnection;14;1;12;0
WireConnection;87;0;89;0
WireConnection;87;1;90;0
WireConnection;87;2;94;0
WireConnection;0;0;36;0
WireConnection;0;1;6;0
WireConnection;0;3;78;0
WireConnection;0;4;87;0
ASEEND*/
//CHKSM=05D3A95A3B642810740846BE2B999ECDB6F25983