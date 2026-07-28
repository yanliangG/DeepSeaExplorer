// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Davis3D/OceanEnviroment/Shader_Jellyfish"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,0)
		_MainTex("Main Tex", 2D) = "white" {}
		_Metallic1("Metallic", Float) = 0
		_Glossiness1("Smoothness", Float) = 0.5
		[Normal]_NormalTex("Normal Tex", 2D) = "bump" {}
		_NormalIntencity("Normal Intencity", Float) = 1
		[HDR]_EmissiveColor("Emissive Color", Color) = (0,0,0,0)
		_EmissiveTex("Emissive Tex", 2D) = "black" {}
		_EmissionIntencity("Emission Intencity", Float) = 1
		_DifOpacityMask("DifOpacityMask", 2D) = "white" {}
		_Opacity_MasterMask("Opacity_MasterMask", 2D) = "white" {}
		_Opacity_Tex_Multiply("Opacity_Tex_Multiply", Float) = 3
		_Opacity_Min("Opacity_Min", Float) = 0
		_Opacity_Add("Opacity_Add", Float) = 0.1
		_Cubemap("Cubemap", CUBE) = "white" {}
		_RefractionCubemap("RefractionCubemap", Float) = 0.1
		_FakeReflections("FakeReflections", Float) = 0.5
		[Toggle(_VERTEXANIMATION_ON_ON)] _VertexAnimation_On("VertexAnimation_On", Float) = 0
		_VAT_Amount("VAT_Amount", Float) = 1
		_OffsetScale("Offset Scale", Float) = 1
		_VATSpeed("VAT Speed", Float) = 1
		_VAT("VAT", 2D) = "black" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _VERTEXANIMATION_ON_ON
		#include "Assets/Davis3D/OceanEnvironmentPack/Shaders/Functions/Davis3DUtils.cginc"
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
			float3 worldPos;
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
		};

		uniform float _VATSpeed;
		uniform sampler2D _VAT;
		uniform float _OffsetScale;
		uniform float _VAT_Amount;
		uniform sampler2D _NormalTex;
		uniform float4 _NormalTex_ST;
		uniform float _NormalIntencity;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _EmissiveTex;
		uniform float4 _EmissiveTex_ST;
		uniform float4 _EmissiveColor;
		uniform float _EmissionIntencity;
		uniform samplerCUBE _Cubemap;
		uniform float _RefractionCubemap;
		uniform float _FakeReflections;
		uniform float _Metallic1;
		uniform float _Glossiness1;
		uniform float _Opacity_Tex_Multiply;
		uniform float _Opacity_Add;
		uniform sampler2D _DifOpacityMask;
		uniform float4 _DifOpacityMask_ST;
		uniform sampler2D _Opacity_MasterMask;
		uniform float4 _Opacity_MasterMask_ST;
		uniform float _Opacity_Min;


		float3 MyCustomExpression1_g57( float2 uv, float VATSpeed, sampler2D VAT, float OffsetScale, float VAT_Amount, float3 worldPos )
		{
			float3 vertexOffset = MS_MorphTargets(uv, frac(_Time.y * VATSpeed + floor(worldPos.x + worldPos.z) * OffsetScale), VAT, VAT, 51);
			return float3(-vertexOffset.x, vertexOffset.z, vertexOffset.y) * 0.05 * VAT_Amount;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv1_g57 = v.texcoord1.xy;
			float VATSpeed1_g57 = _VATSpeed;
			sampler2D VAT1_g57 = _VAT;
			float OffsetScale1_g57 = _OffsetScale;
			float VAT_Amount1_g57 = _VAT_Amount;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 worldPos1_g57 = ase_worldPos;
			float3 localMyCustomExpression1_g57 = MyCustomExpression1_g57( uv1_g57 , VATSpeed1_g57 , VAT1_g57 , OffsetScale1_g57 , VAT_Amount1_g57 , worldPos1_g57 );
			#ifdef _VERTEXANIMATION_ON_ON
				float3 staticSwitch82 = localMyCustomExpression1_g57;
			#else
				float3 staticSwitch82 = float3( 0,0,0 );
			#endif
			v.vertex.xyz += staticSwitch82;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalTex = i.uv_texcoord * _NormalTex_ST.xy + _NormalTex_ST.zw;
			float3 tex2DNode2 = UnpackScaleNormal( tex2D( _NormalTex, uv_NormalTex ), _NormalIntencity );
			o.Normal = tex2DNode2;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode3 = tex2D( _MainTex, uv_MainTex );
			o.Albedo = ( _Color * tex2DNode3 ).rgb;
			float2 uv_EmissiveTex = i.uv_texcoord * _EmissiveTex_ST.xy + _EmissiveTex_ST.zw;
			o.Emission = ( ( ( tex2D( _EmissiveTex, uv_EmissiveTex ) * _EmissiveColor ) * _EmissionIntencity ) + ( texCUBE( _Cubemap, refract( i.viewDir , tex2DNode2 , _RefractionCubemap ) ) * _FakeReflections ) ).rgb;
			o.Metallic = _Metallic1;
			o.Smoothness = _Glossiness1;
			float2 uv_DifOpacityMask = i.uv_texcoord * _DifOpacityMask_ST.xy + _DifOpacityMask_ST.zw;
			float lerpResult76 = lerp( 0.0 , _Opacity_Add , tex2D( _DifOpacityMask, uv_DifOpacityMask ).g);
			float2 uv_Opacity_MasterMask = i.uv_texcoord * _Opacity_MasterMask_ST.xy + _Opacity_MasterMask_ST.zw;
			float clampResult77 = clamp( tex2D( _Opacity_MasterMask, uv_Opacity_MasterMask ).g , _Opacity_Min , 1.0 );
			float Opacity47 = ( ( ( tex2DNode3.a * _Opacity_Tex_Multiply ) + lerpResult76 ) * clampResult77 );
			o.Alpha = Opacity47;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
			sampler3D _DitherMaskLOD;
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
				vertexDataFunc( v, customInputData );
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
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
Node;AmplifyShaderEditor.CommentaryNode;68;-1676.16,-567.6331;Inherit;False;1530.338;690.866;Opacity;11;47;49;46;48;76;50;53;52;65;77;78;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;81;-1327.408,128.0362;Inherit;False;1308.636;720.7596;Emission;12;7;84;83;15;79;4;13;69;80;70;72;73;;0.1854615,1,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-1441.593,-508.9324;Inherit;False;Property;_Opacity_Tex_Multiply;Opacity_Tex_Multiply;11;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;52;-1506.51,-320.1326;Inherit;True;Property;_DifOpacityMask;DifOpacityMask;9;0;Create;True;0;0;0;False;0;False;-1;6394cf7ba98889942988282150124412;6394cf7ba98889942988282150124412;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1537.522,-756.418;Inherit;True;Property;_MainTex;Main Tex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-1393.675,-400.6747;Inherit;False;Property;_Opacity_Add;Opacity_Add;13;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-1815.905,194.18;Inherit;False;Property;_NormalIntencity;Normal Intencity;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;76;-1208.728,-370.198;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-1062.799,-45.87755;Inherit;False;Property;_Opacity_Min;Opacity_Min;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;49;-1189.16,-243.9995;Inherit;True;Property;_Opacity_MasterMask;Opacity_MasterMask;10;0;Create;True;0;0;0;False;0;False;-1;abc00000000013220669993734470830;abc00000000013220669993734470830;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1620.721,147.1063;Inherit;True;Property;_NormalTex;Normal Tex;4;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;72;-1254.649,600.0746;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;73;-1277.408,747.4189;Inherit;False;Property;_RefractionCubemap;RefractionCubemap;15;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1111.621,-514.301;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-828.9915,391.7336;Inherit;False;Property;_EmissiveColor;Emissive Color;6;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;77;-786.5208,-280.1176;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-940.7418,-442.8538;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RefractOpVec;70;-988.5148,608.5455;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;13;-829.7043,178.0362;Inherit;True;Property;_EmissiveTex;Emissive Tex;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-484.0337,181.8835;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-609.6742,-394.4844;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-714.6663,764.6326;Inherit;False;Property;_FakeReflections;FakeReflections;16;0;Create;True;0;0;0;False;0;False;0.5;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;69;-819.5833,578.9498;Inherit;True;Property;_Cubemap;Cubemap;14;0;Create;True;0;0;0;False;0;False;-1;aeec6be8589c79849941a97717ceff50;aeec6be8589c79849941a97717ceff50;True;0;False;white;Auto;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;84;-487.374,291.707;Inherit;False;Property;_EmissionIntencity;Emission Intencity;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-426.2849,-401.5607;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-1451.118,-924.2438;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;45;-153.7853,-40.95853;Inherit;False;VAT;18;;57;34d97b98da3bd9642a30ca9d92b52094;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-499.6663,584.4167;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-318.1263,184.1494;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;52.1853,-287.1384;Inherit;False;Property;_Metallic1;Metallic;2;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1216.263,-839.9421;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-154.3356,187.4877;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;25.0184,-222.3082;Inherit;False;Property;_Glossiness1;Smoothness;3;0;Create;False;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;41.63182,-150.9542;Inherit;False;47;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;82;-25.72522,-79.49115;Inherit;False;Property;_VertexAnimation_On;VertexAnimation_On;17;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;238.9497,-358.748;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Davis3D/OceanEnviroment/Shader_Jellyfish;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;;3;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;5;False;;10;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;76;1;53;0
WireConnection;76;2;52;2
WireConnection;2;5;67;0
WireConnection;50;0;3;4
WireConnection;50;1;65;0
WireConnection;77;0;49;2
WireConnection;77;1;78;0
WireConnection;48;0;50;0
WireConnection;48;1;76;0
WireConnection;70;0;72;0
WireConnection;70;1;2;0
WireConnection;70;2;73;0
WireConnection;15;0;13;0
WireConnection;15;1;4;0
WireConnection;46;0;48;0
WireConnection;46;1;77;0
WireConnection;69;1;70;0
WireConnection;47;0;46;0
WireConnection;79;0;69;0
WireConnection;79;1;80;0
WireConnection;83;0;15;0
WireConnection;83;1;84;0
WireConnection;6;0;5;0
WireConnection;6;1;3;0
WireConnection;7;0;83;0
WireConnection;7;1;79;0
WireConnection;82;0;45;0
WireConnection;0;0;6;0
WireConnection;0;1;2;0
WireConnection;0;2;7;0
WireConnection;0;3;8;0
WireConnection;0;4;9;0
WireConnection;0;9;66;0
WireConnection;0;11;82;0
ASEEND*/
//CHKSM=0E4763D2A486019B7CCCF8C31E079F96CC6D9ABF