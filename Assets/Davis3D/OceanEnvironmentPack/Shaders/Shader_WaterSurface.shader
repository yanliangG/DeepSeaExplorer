// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Davis3D/OceanEnviroment/Shader_WaterSurface"
{
	Properties
	{
		_MASTERTiling("MASTER Tiling", Float) = 10
		_MASTERSpeed("MASTER Speed", Float) = 10
		_Cubemap("Cubemap", CUBE) = "white" {}
		_WaterNorm("Water Norm", 2D) = "bump" {}
		_WaterTile2("Water Tile 2", Float) = 100
		_WaterTile3("Water Tile 3", Float) = 30
		_WaterTile4("Water Tile 4", Float) = 10
		_WaterTile5("Water Tile 5", Float) = 20
		_WaterTile1("Water Tile 1", Float) = 150
		_WaterSpeed1("Water Speed 1", Float) = 0.1
		_WaterSpeed2("Water Speed 2", Float) = 0.1
		_WaterSpeed3("Water Speed 3", Float) = 0.1
		_WaterSpeed4("Water Speed 4", Float) = 0.1
		_WaterSpeed5("Water Speed 5", Float) = 0.1
		_FresnelBias("Fresnel Bias", Float) = 0
		_WaterNormIntensityClose("Water Norm Intensity Close", Float) = 1
		_WaterNormIntensityFar("Water Norm Intensity Far", Float) = 1
		_FresnelPower("Fresnel Power", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
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
			float3 worldRefl;
			INTERNAL_DATA
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform samplerCUBE _Cubemap;
		uniform sampler2D _WaterNorm;
		uniform float _MASTERSpeed;
		uniform float _WaterSpeed1;
		uniform float _MASTERTiling;
		uniform float _WaterTile1;
		uniform float _WaterSpeed2;
		uniform float _WaterTile2;
		uniform float _WaterSpeed3;
		uniform float _WaterTile3;
		uniform float _WaterSpeed4;
		uniform float _WaterTile4;
		uniform float _WaterSpeed5;
		uniform float _WaterTile5;
		uniform float _WaterNormIntensityClose;
		uniform float _WaterNormIntensityFar;
		uniform float _FresnelBias;
		uniform float _FresnelPower;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float4 color372 = IsGammaSpace() ? float4(0,0,1,0) : float4(0,0,1,0);
			float3 temp_output_377_0 = (color372).rgb;
			float2 temp_cast_0 = (( _MASTERSpeed * _WaterSpeed1 )).xx;
			float2 temp_cast_1 = (( _MASTERTiling * _WaterTile1 )).xx;
			float2 uv_TexCoord355 = i.uv_texcoord * temp_cast_1;
			float2 panner364 = ( 1.0 * _Time.y * temp_cast_0 + uv_TexCoord355);
			float2 temp_cast_2 = (( _MASTERSpeed * _WaterSpeed2 )).xx;
			float2 temp_cast_3 = (( _MASTERTiling * _WaterTile2 )).xx;
			float2 uv_TexCoord357 = i.uv_texcoord * temp_cast_3;
			float2 panner361 = ( 1.0 * _Time.y * temp_cast_2 + uv_TexCoord357);
			float2 temp_cast_4 = (( _MASTERSpeed * _WaterSpeed3 )).xx;
			float2 temp_cast_5 = (( _MASTERTiling * _WaterTile3 )).xx;
			float2 uv_TexCoord359 = i.uv_texcoord * temp_cast_5;
			float2 panner365 = ( 1.0 * _Time.y * temp_cast_4 + uv_TexCoord359);
			float2 temp_cast_6 = (( _MASTERSpeed * _WaterSpeed4 )).xx;
			float2 temp_cast_7 = (( _MASTERTiling * _WaterTile4 )).xx;
			float2 uv_TexCoord346 = i.uv_texcoord * temp_cast_7;
			float2 panner352 = ( 1.0 * _Time.y * temp_cast_6 + uv_TexCoord346);
			float2 temp_cast_8 = (( _MASTERSpeed * _WaterSpeed5 )).xx;
			float2 temp_cast_9 = (( _MASTERTiling * _WaterTile5 )).xx;
			float2 uv_TexCoord344 = i.uv_texcoord * temp_cast_9;
			float2 panner360 = ( 1.0 * _Time.y * temp_cast_8 + uv_TexCoord344);
			float3 temp_output_374_0 = BlendNormals( BlendNormals( UnpackNormal( tex2D( _WaterNorm, panner364 ) ) , UnpackNormal( tex2D( _WaterNorm, panner361 ) ) ) , BlendNormals( UnpackNormal( tex2D( _WaterNorm, panner365 ) ) , BlendNormals( UnpackNormal( tex2D( _WaterNorm, panner352 ) ) , UnpackNormal( tex2D( _WaterNorm, panner360 ) ) ) ) );
			float3 lerpResult379 = lerp( temp_output_377_0 , temp_output_374_0 , _WaterNormIntensityClose);
			float3 lerpResult380 = lerp( temp_output_377_0 , temp_output_374_0 , _WaterNormIntensityFar);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV381 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode381 = ( _FresnelBias + 1.0 * pow( 1.0 - fresnelNdotV381, _FresnelPower ) );
			float3 lerpResult382 = lerp( lerpResult379 , lerpResult380 , fresnelNode381);
			float3 break384 = WorldReflectionVector( i , lerpResult382 );
			float4 appendResult386 = (float4(break384.x , ( break384.y * -1.0 ) , break384.z , 0.0));
			o.Emission = texCUBE( _Cubemap, appendResult386.xyz ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

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
				surfIN.worldRefl = -worldViewDir;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
Node;AmplifyShaderEditor.RangedFloatNode;331;-4669.917,735.0009;Inherit;False;Property;_WaterTile4;Water Tile 4;6;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;332;-4701.917,1215.001;Inherit;False;Property;_WaterTile5;Water Tile 5;7;0;Create;True;0;0;0;False;0;False;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;333;-4877.917,447.0009;Inherit;False;Property;_MASTERTiling;MASTER Tiling;0;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;340;-4109.917,623.001;Inherit;False;Property;_WaterSpeed4;Water Speed 4;12;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;334;-4269.917,1199.001;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-4301.917,735.0009;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;336;-4925.917,303.0009;Inherit;False;Property;_MASTERSpeed;MASTER Speed;1;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;337;-4605.917,15.00086;Inherit;False;Property;_WaterTile2;Water Tile 2;4;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;-4077.917,1087.001;Inherit;False;Property;_WaterSpeed5;Water Speed 5;13;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;339;-4573.918,463.0009;Inherit;False;Property;_WaterTile3;Water Tile 3;5;0;Create;True;0;0;0;False;0;False;30;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;341;-4669.917,-336.9992;Inherit;False;Property;_WaterTile1;Water Tile 1;8;0;Create;True;0;0;0;False;0;False;150;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;342;-4397.917,-400.9993;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;349;-4061.917,287.0009;Inherit;False;Property;_WaterSpeed3;Water Speed 3;11;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;347;-4365.917,-0.9991446;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;346;-4141.917,719.0009;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;348;-4173.917,-112.9991;Inherit;False;Property;_WaterSpeed2;Water Speed 2;10;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;345;-4253.917,383.0009;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;343;-3885.917,1071.001;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;350;-3917.917,607.001;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;351;-4237.917,-512.9991;Inherit;False;Property;_WaterSpeed1;Water Speed 1;9;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;344;-4109.917,1183.001;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;359;-4109.917,383.0009;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;360;-3821.917,1183.001;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;358;-4013.917,-912.9987;Inherit;True;Property;_WaterNorm;Water Norm;3;0;Create;True;0;0;0;False;0;False;abc00000000010132068090221292727;abc00000000004188447198822879912;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;352;-3853.917,719.0009;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;356;-4045.917,-528.9991;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;353;-3981.917,-128.999;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;355;-4141.917,-416.9993;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;357;-4205.917,-16.99915;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;354;-3885.917,271.0009;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;361;-3917.917,-16.99915;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;362;-3501.917,1151;Inherit;True;Property;_TextureSample17;Texture Sample 17;15;0;Create;True;0;0;0;False;0;False;-1;abc00000000000746726904355842572;abc00000000000746726904355842572;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;363;-3533.917,687.0009;Inherit;True;Property;_TextureSample0;Texture Sample 0;35;0;Create;True;0;0;0;False;0;False;-1;abc00000000000746726904355842572;abc00000000000746726904355842572;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;364;-3869.917,-416.9993;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;365;-3805.917,383.0009;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;366;-3485.917,351.0009;Inherit;True;Property;_TextureSample1;Texture Sample 1;35;0;Create;True;0;0;0;False;0;False;-1;abc00000000000746726904355842572;abc00000000000746726904355842572;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;367;-3597.917,-48.99915;Inherit;True;Property;_TextureSample19;Texture Sample 17;35;0;Create;True;0;0;0;False;0;False;-1;abc00000000000746726904355842572;abc00000000000746726904355842572;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;368;-3613.917,-464.9993;Inherit;True;Property;_TextureSample18;Texture Sample 18;35;0;Create;True;0;0;0;False;0;False;-1;abc00000000000746726904355842572;abc00000000000746726904355842572;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;369;-3005.917,1055.001;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;370;-3101.917,-336.9992;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;372;-2363.729,8.593873;Inherit;False;Constant;_Color0;Color 0;15;0;Create;True;0;0;0;False;0;False;0,0,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;371;-2893.917,591.001;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;378;-2034.778,305.5516;Inherit;False;Property;_WaterNormIntensityClose;Water Norm Intensity Close;15;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;377;-2143.318,21.68256;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;376;-2079.861,191.9533;Inherit;False;Property;_WaterNormIntensityFar;Water Norm Intensity Far;16;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;374;-2302.386,371.7305;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;373;-1996.693,455.8391;Inherit;False;Property;_FresnelBias;Fresnel Bias;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;375;-2006.74,537.342;Inherit;False;Property;_FresnelPower;Fresnel Power;17;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;380;-1830.95,46.7747;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;379;-1714.034,249.1764;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;381;-1681.318,404.4504;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;382;-1418.355,22.64508;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldReflectionVector;383;-1201.394,21.37274;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;384;-989.3858,65.60914;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;385;-861.3856,3.609132;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;386;-747.3856,60.60914;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;387;-598.0928,23.4729;Inherit;True;Property;_Cubemap;Cubemap;2;0;Create;True;0;0;0;False;0;False;-1;abc00000000009448429789665740208;abc00000000009448429789665740208;True;0;False;white;Auto;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;32.67245,-64.47063;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Davis3D/OceanEnviroment/Shader_WaterSurface;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;334;0;333;0
WireConnection;334;1;332;0
WireConnection;335;0;333;0
WireConnection;335;1;331;0
WireConnection;342;0;333;0
WireConnection;342;1;341;0
WireConnection;347;0;333;0
WireConnection;347;1;337;0
WireConnection;346;0;335;0
WireConnection;345;0;333;0
WireConnection;345;1;339;0
WireConnection;343;0;336;0
WireConnection;343;1;338;0
WireConnection;350;0;336;0
WireConnection;350;1;340;0
WireConnection;344;0;334;0
WireConnection;359;0;345;0
WireConnection;360;0;344;0
WireConnection;360;2;343;0
WireConnection;352;0;346;0
WireConnection;352;2;350;0
WireConnection;356;0;336;0
WireConnection;356;1;351;0
WireConnection;353;0;336;0
WireConnection;353;1;348;0
WireConnection;355;0;342;0
WireConnection;357;0;347;0
WireConnection;354;0;336;0
WireConnection;354;1;349;0
WireConnection;361;0;357;0
WireConnection;361;2;353;0
WireConnection;362;0;358;0
WireConnection;362;1;360;0
WireConnection;363;0;358;0
WireConnection;363;1;352;0
WireConnection;364;0;355;0
WireConnection;364;2;356;0
WireConnection;365;0;359;0
WireConnection;365;2;354;0
WireConnection;366;0;358;0
WireConnection;366;1;365;0
WireConnection;367;0;358;0
WireConnection;367;1;361;0
WireConnection;368;0;358;0
WireConnection;368;1;364;0
WireConnection;369;0;363;0
WireConnection;369;1;362;0
WireConnection;370;0;368;0
WireConnection;370;1;367;0
WireConnection;371;0;366;0
WireConnection;371;1;369;0
WireConnection;377;0;372;0
WireConnection;374;0;370;0
WireConnection;374;1;371;0
WireConnection;380;0;377;0
WireConnection;380;1;374;0
WireConnection;380;2;376;0
WireConnection;379;0;377;0
WireConnection;379;1;374;0
WireConnection;379;2;378;0
WireConnection;381;1;373;0
WireConnection;381;3;375;0
WireConnection;382;0;379;0
WireConnection;382;1;380;0
WireConnection;382;2;381;0
WireConnection;383;0;382;0
WireConnection;384;0;383;0
WireConnection;385;0;384;1
WireConnection;386;0;384;0
WireConnection;386;1;385;0
WireConnection;386;2;384;2
WireConnection;387;1;386;0
WireConnection;0;2;387;0
ASEEND*/
//CHKSM=8D0A250CB7E788866E9A0974645FE9075701962A