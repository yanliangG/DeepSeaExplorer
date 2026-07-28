// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Davis3D/OceanEnviroment/Shader_Seaweed"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Diffuse("Diffuse", 2D) = "white" {}
		_SpecularA("Specular A", Float) = 0
		_SpecularB("Specular B", Float) = 1
		_SmoothnessA("Smoothness A", Float) = 1
		_SmoothnessB("Smoothness B", Float) = 0
		_Normal("Normal", 2D) = "bump" {}
		_NormalDetail("NormalDetail", 2D) = "bump" {}
		_NormalDetailIntensity("Normal Detail Intensity", Float) = 1
		_NormalDetailScale("Normal Detail Scale", Float) = 6
		_GlowColor("Glow Color", Color) = (0,0.2886519,1,0)
		_Glow("Glow", 2D) = "white" {}
		_Glow_Intensity("Glow_Intensity", Float) = 3
		_Glow_Minimum("Glow_Minimum", Float) = 0.2
		[Toggle(_WIND_ON)] _Wind("Wind", Float) = 0
		_WindMask("WindMask", 2D) = "white" {}
		_WindNoise("WindNoise", 2D) = "white" {}
		_WindIntensity("WindIntensity", Float) = 0.1
		_WindScale("WindScale", Float) = 1
		_WindSpeed("WindSpeed", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Grass"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _WIND_ON
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _WindNoise;
		uniform float _WindSpeed;
		uniform float _WindScale;
		uniform float _WindIntensity;
		uniform sampler2D _WindMask;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _NormalDetail;
		uniform float _NormalDetailScale;
		uniform float _NormalDetailIntensity;
		uniform sampler2D _Diffuse;
		uniform float4 _Diffuse_ST;
		uniform float4 _GlowColor;
		uniform float _Glow_Intensity;
		uniform float _Glow_Minimum;
		uniform sampler2D _Glow;
		uniform float4 _Glow_ST;
		uniform float _SpecularA;
		uniform float _SpecularB;
		uniform float _SmoothnessA;
		uniform float _SmoothnessB;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 appendResult273 = (float2(_WindSpeed , _WindSpeed));
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult280 = (float2(ase_worldPos.x , ase_worldPos.y));
			float2 panner272 = ( 1.0 * _Time.y * appendResult273 + ( ( appendResult280 * 0.1 ) + ( _WindScale * v.texcoord.xy ) ));
			float4 tex2DNode271 = tex2Dlod( _WindNoise, float4( panner272, 0, 0.0) );
			float4 appendResult308 = (float4(tex2DNode271.g , tex2DNode271.g , 0.0 , 0.0));
			float lerpResult306 = lerp( 0.0 , 1.0 , tex2Dlod( _WindMask, float4( v.texcoord.xy, 0, 0.0) ).g);
			#ifdef _WIND_ON
				float4 staticSwitch309 = ( ( appendResult308 * _WindIntensity ) * lerpResult306 );
			#else
				float4 staticSwitch309 = float4( 0,0,0,0 );
			#endif
			v.vertex.xyz += staticSwitch309.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float2 temp_cast_0 = (_NormalDetailScale).xx;
			float2 uv_TexCoord50 = i.uv_texcoord * temp_cast_0;
			o.Normal = BlendNormals( UnpackNormal( tex2D( _Normal, uv_Normal ) ) , UnpackScaleNormal( tex2D( _NormalDetail, uv_TexCoord50 ), _NormalDetailIntensity ) );
			float2 uv_Diffuse = i.uv_texcoord * _Diffuse_ST.xy + _Diffuse_ST.zw;
			float4 tex2DNode2 = tex2D( _Diffuse, uv_Diffuse );
			o.Albedo = tex2DNode2.rgb;
			float2 uv_Glow = i.uv_texcoord * _Glow_ST.xy + _Glow_ST.zw;
			o.Emission = ( _GlowColor * ( ( _Glow_Intensity + _Glow_Minimum ) * tex2D( _Glow, uv_Glow ).g ) ).rgb;
			float lerpResult77 = lerp( _SpecularA , _SpecularB , tex2DNode2.b);
			float3 temp_cast_3 = (lerpResult77).xxx;
			o.Specular = temp_cast_3;
			float lerpResult89 = lerp( _SmoothnessA , _SmoothnessB , 0.0);
			o.Smoothness = ( 1.0 - lerpResult89 );
			o.Alpha = 1;
			clip( tex2DNode2.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;310;-3355.844,525.7448;Inherit;False;2049.666;814.774;Wind;22;309;303;283;284;308;271;270;272;274;273;279;280;282;278;276;281;277;275;306;302;307;301;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;279;-3305.844,575.7447;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;276;-3267.844,854.7448;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;278;-3204.844,773.7448;Inherit;False;Property;_WindScale;WindScale;18;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;282;-3030.844,712.7448;Inherit;False;Constant;_Float0;Float 0;22;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;280;-3098.844,594.7448;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;277;-2999.845,818.7448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;281;-2871.845,625.7448;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;274;-2943.255,936.4387;Inherit;False;Property;_WindSpeed;WindSpeed;19;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;273;-2743.425,928.0046;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;275;-2774.845,765.7448;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;272;-2575.026,786.2043;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;270;-2626.666,580.0676;Inherit;True;Property;_WindNoise;WindNoise;16;0;Create;True;0;0;0;False;0;False;086fedcfba4f17a45902312193710598;abc00000000003537318495103793257;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;311;-2346.421,-165.0908;Inherit;False;1035.896;666.6652;Normal;8;50;57;8;3;98;99;69;5;;0,0.8187747,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;312;-2213.687,1370.827;Inherit;False;916.912;573.4614;Emission;8;291;298;290;297;296;294;288;289;;0.09213972,1,0,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;302;-2489.368,995.6824;Inherit;True;Property;_WindMask;WindMask;15;0;Create;True;0;0;0;False;0;False;abc00000000001482198155810529704;abc00000000003537318495103793257;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;271;-2368.042,708.9101;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;307;-2455.954,1181.519;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;294;-1933.481,1567.171;Inherit;False;Property;_Glow_Intensity;Glow_Intensity;12;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;301;-2198.232,1002.457;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;296;-1934.192,1638.738;Inherit;False;Property;_Glow_Minimum;Glow_Minimum;13;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;288;-2163.687,1714.289;Inherit;True;Property;_Glow;Glow;11;0;Create;True;0;0;0;False;0;False;abc00000000014400254202910335805;abc00000000003537318495103793257;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;284;-2076.396,914.404;Inherit;False;Property;_WindIntensity;WindIntensity;17;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-2296.421,279.4563;Inherit;False;Property;_NormalDetailScale;Normal Detail Scale;9;0;Create;True;0;0;0;False;0;False;6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;308;-2064.515,753.1445;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-2106.795,-115.0908;Inherit;True;Property;_Normal;Normal;6;0;Create;True;0;0;0;False;0;False;abc00000000010586601616951192980;abc00000000000746726904355842572;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;93;-642.9167,134.2048;Inherit;False;Property;_SmoothnessB;Smoothness B;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-631.9167,61.20502;Inherit;False;Property;_SmoothnessA;Smoothness A;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-2095.896,261.3061;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;8;-2145.247,73.35215;Inherit;True;Property;_NormalDetail;NormalDetail;7;0;Create;True;0;0;0;False;0;False;abc00000000004188447198822879912;abc00000000004188447198822879912;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;283;-1876.21,861.9882;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;297;-1748.422,1590.478;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;289;-1939.563,1714.175;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;-2100.115,385.5742;Inherit;False;Property;_NormalDetailIntensity;Normal Detail Intensity;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;306;-1885.254,963.7432;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-863.905,-150.3447;Inherit;True;Property;_Diffuse;Diffuse;1;0;Create;True;0;0;0;False;0;False;abc00000000016427841086125353175;abc00000000003537318495103793257;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;2;-605.5037,-148.3333;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;98;-1870.052,-115.079;Inherit;True;Property;_T_Rocks_AB_New_Norm;T_Rocks_AB_New_Norm;35;0;Create;True;0;0;0;False;0;False;-1;abc00000000000746726904355842572;abc00000000000746726904355842572;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;81;-503.4909,-245.7202;Inherit;False;Property;_SpecularB;Specular B;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-519.7267,-347.369;Inherit;False;Property;_SpecularA;Specular A;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;99;-1859.24,149.0703;Inherit;True;Property;_TextureSample16;Texture Sample 16;35;0;Create;True;0;0;0;False;0;False;-1;abc00000000000746726904355842572;abc00000000000746726904355842572;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;-1617.459,1590.094;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;290;-1688.249,1420.827;Inherit;False;Property;_GlowColor;Glow Color;10;0;Create;True;0;0;0;False;0;False;0,0.2886519,1,0;0.2071467,0.3658273,0.4622642,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;-1681.952,942.7192;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;89;-430.2115,98.02558;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-1458.775,1564.969;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;309;-1541.178,916.1489;Inherit;False;Property;_Wind;Wind;14;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;313;-251.1295,105.536;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;77;-255.9003,-318.3308;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;5;-1538.525,28.83083;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,-2.3;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Davis3D/OceanEnviroment/Shader_Seaweed;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Grass;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;280;0;279;1
WireConnection;280;1;279;2
WireConnection;277;0;278;0
WireConnection;277;1;276;0
WireConnection;281;0;280;0
WireConnection;281;1;282;0
WireConnection;273;0;274;0
WireConnection;273;1;274;0
WireConnection;275;0;281;0
WireConnection;275;1;277;0
WireConnection;272;0;275;0
WireConnection;272;2;273;0
WireConnection;271;0;270;0
WireConnection;271;1;272;0
WireConnection;301;0;302;0
WireConnection;301;1;307;0
WireConnection;308;0;271;2
WireConnection;308;1;271;2
WireConnection;50;0;57;0
WireConnection;283;0;308;0
WireConnection;283;1;284;0
WireConnection;297;0;294;0
WireConnection;297;1;296;0
WireConnection;289;0;288;0
WireConnection;306;2;301;2
WireConnection;2;0;1;0
WireConnection;98;0;3;0
WireConnection;99;0;8;0
WireConnection;99;1;50;0
WireConnection;99;5;69;0
WireConnection;298;0;297;0
WireConnection;298;1;289;2
WireConnection;303;0;283;0
WireConnection;303;1;306;0
WireConnection;89;0;92;0
WireConnection;89;1;93;0
WireConnection;291;0;290;0
WireConnection;291;1;298;0
WireConnection;309;0;303;0
WireConnection;313;0;89;0
WireConnection;77;0;80;0
WireConnection;77;1;81;0
WireConnection;77;2;2;3
WireConnection;5;0;98;0
WireConnection;5;1;99;0
WireConnection;0;0;2;0
WireConnection;0;1;5;0
WireConnection;0;2;291;0
WireConnection;0;3;77;0
WireConnection;0;4;313;0
WireConnection;0;10;2;4
WireConnection;0;11;309;0
ASEEND*/
//CHKSM=BDBDFC2FBD616DF1F803C1E6066F04A015EA7A10