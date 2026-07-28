// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Davis3D/OceanEnviroment/Shader_Godrays"
{
	Properties
	{
		_T_Gradient_Vertical_2wayB("T_Gradient_Vertical_2wayB", 2D) = "white" {}
		_Glow("Glow", Float) = 0.4
		_TilingA("Tiling A", Float) = 30
		_TilingB("Tiling B", Float) = 22
		_FadeSurfaceDistance("Fade Surface Distance", Range( 0 , 100)) = 19
		_BeamGradientA("Beam Gradient A", 2D) = "white" {}
		_BeamGradientB("Beam Gradient B", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _FadeSurfaceDistance;
		uniform float _Glow;
		uniform sampler2D _BeamGradientA;
		uniform float _TilingA;
		uniform sampler2D _BeamGradientB;
		uniform float _TilingB;
		uniform sampler2D _T_Gradient_Vertical_2wayB;
		uniform float4 _T_Gradient_Vertical_2wayB_ST;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 temp_cast_0 = (1.0).xxx;
			o.Emission = temp_cast_0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth28 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth28 = abs( ( screenDepth28 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _FadeSurfaceDistance ) );
			float lerpResult95 = lerp( 0.0 , 1.0 , distanceDepth28);
			float clampResult97 = clamp( lerpResult95 , 0.0 , 1.0 );
			float2 temp_cast_1 = (_TilingA).xx;
			float2 uv_TexCoord78 = i.uv_texcoord * temp_cast_1;
			float2 panner84 = ( 1.0 * _Time.y * float2( 0.2,0 ) + uv_TexCoord78);
			float2 temp_cast_2 = (_TilingB).xx;
			float2 uv_TexCoord86 = i.uv_texcoord * temp_cast_2;
			float2 panner83 = ( 1.0 * _Time.y * float2( -0.2,0 ) + uv_TexCoord86);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV20 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode20 = ( 0.0 + 3.0 * pow( 1.0 - fresnelNdotV20, 1.5 ) );
			float4 lerpResult19 = lerp( ( tex2D( _BeamGradientA, panner84 ) * tex2D( _BeamGradientB, panner83 ) ) , float4( 0,0,0,0 ) , fresnelNode20);
			float4 clampResult92 = clamp( lerpResult19 , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			float2 uv_T_Gradient_Vertical_2wayB = i.uv_texcoord * _T_Gradient_Vertical_2wayB_ST.xy + _T_Gradient_Vertical_2wayB_ST.zw;
			o.Alpha = ( clampResult97 * ( ( _Glow * clampResult92 ) * tex2D( _T_Gradient_Vertical_2wayB, uv_T_Gradient_Vertical_2wayB ).g ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
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
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
Node;AmplifyShaderEditor.RangedFloatNode;38;-2303.528,385.9565;Inherit;False;Property;_TilingA;Tiling A;2;0;Create;True;0;0;0;False;0;False;30;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-2341.922,711.4953;Inherit;False;Property;_TilingB;Tiling B;3;0;Create;True;0;0;0;False;0;False;22;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;86;-2116.966,666.0237;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;78;-2089.406,412.8455;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;83;-1829.347,684.5047;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.2,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;84;-1821.75,446.1505;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0.2,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;82;-1555.989,425.3756;Inherit;True;Property;_BeamGradientA;Beam Gradient A;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;85;-1572.808,667.3572;Inherit;True;Property;_BeamGradientB;Beam Gradient B;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;20;-937.4268,596.4035;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;3;False;3;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-1155.349,508.6443;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-937.6339,253.973;Float;False;Property;_FadeSurfaceDistance;Fade Surface Distance;4;0;Create;True;0;0;0;False;0;False;19;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-635.8488,481.1299;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;28;-610.0524,201.2728;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-361.5421,449.6055;Inherit;False;Property;_Glow;Glow;1;0;Create;True;0;0;0;False;0;False;0.4;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;92;-411.6089,575.5521;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-138.7605,461.7023;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;95;-360.2578,209.1541;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-290.4391,706.4666;Inherit;True;Property;_T_Gradient_Vertical_2wayB;T_Gradient_Vertical_2wayB;0;0;Create;True;0;0;0;False;0;False;-1;abc00000000003004992162547830626;abc00000000003004992162547830626;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;31.67725,461.3808;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;97;-160.6339,288.973;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;14.20541,268.5446;Inherit;False;Constant;_Emmission;Emmission;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;161.6486,355.6697;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;346.5463,266.3028;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Davis3D/OceanEnviroment/Shader_Godrays;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;86;0;39;0
WireConnection;78;0;38;0
WireConnection;83;0;86;0
WireConnection;84;0;78;0
WireConnection;82;1;84;0
WireConnection;85;1;83;0
WireConnection;87;0;82;0
WireConnection;87;1;85;0
WireConnection;19;0;87;0
WireConnection;19;2;20;0
WireConnection;28;0;96;0
WireConnection;92;0;19;0
WireConnection;90;0;89;0
WireConnection;90;1;92;0
WireConnection;95;2;28;0
WireConnection;91;0;90;0
WireConnection;91;1;31;2
WireConnection;97;0;95;0
WireConnection;93;0;97;0
WireConnection;93;1;91;0
WireConnection;0;2;88;0
WireConnection;0;9;93;0
ASEEND*/
//CHKSM=A1121F31B5DC26853410E44D2818996D4CF21C1A