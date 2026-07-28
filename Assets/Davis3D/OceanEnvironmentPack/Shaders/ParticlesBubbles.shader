// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Davis3D/OceanEnviroment/ParticlesBubbles"
{
	Properties
	{
		_TintColor("TintColor", Color) = (1,1,1,1)
		_Refraction("Refraction", 2D) = "white" {}
		_Refraction_A("Refraction_A", Float) = 1.1
		_Refraction_B("Refraction_B", Float) = 2.1
		_Refraction_UV_Add("Refraction_UV_Add", Float) = 3
		_Refraction_Waviness("Refraction_Waviness", 2D) = "white" {}
		_Refraction_Waviness_Intensity("Refraction_Waviness_Intensity", Float) = 0.15
		_Normal("Normal", 2D) = "bump" {}
		_Metallic("Metallic", Float) = 0.75
		_Roughness("Roughness", Float) = 0
		_Cubemap("Cubemap", CUBE) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha 
		struct Input
		{
			float2 uv_texcoord;
			half ASEIsFrontFacing : VFACE;
			float3 viewDir;
			INTERNAL_DATA
		};

		uniform sampler2D _Normal;
		uniform float _Refraction_Waviness_Intensity;
		uniform sampler2D _Refraction_Waviness;
		uniform float _Refraction_UV_Add;
		uniform float4 _TintColor;
		uniform samplerCUBE _Cubemap;
		uniform float _Refraction_A;
		uniform float _Refraction_B;
		uniform sampler2D _Refraction;
		uniform float _Metallic;
		uniform float _Roughness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner7 = ( 1.0 * _Time.y * float2( 0.2,0 ) + i.uv_texcoord);
			float2 panner8 = ( 1.0 * _Time.y * float2( 0,0.4 ) + i.uv_texcoord);
			float lerpResult9 = lerp( tex2D( _Refraction_Waviness, panner7 ).g , tex2D( _Refraction_Waviness, panner8 ).g , 0.5);
			float2 temp_output_13_0 = ( ( i.uv_texcoord + ( _Refraction_Waviness_Intensity * lerpResult9 ) ) + ( _Refraction_UV_Add / 100.0 ) );
			float3 tex2DNode5 = UnpackNormal( tex2D( _Normal, temp_output_13_0 ) );
			o.Normal = ( tex2DNode5 * i.ASEIsFrontFacing );
			float4 temp_output_29_0 = _TintColor;
			o.Albedo = temp_output_29_0.rgb;
			float4 tex2DNode12 = tex2D( _Refraction, temp_output_13_0 );
			float lerpResult21 = lerp( _Refraction_A , _Refraction_B , tex2DNode12.g);
			o.Emission = ( texCUBE( _Cubemap, refract( i.viewDir , tex2DNode5 , lerpResult21 ) ) * _TintColor ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = ( 1.0 - _Roughness );
			o.Alpha = ( tex2DNode12.g * _TintColor.a );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;49;-2124.272,-234.4941;Inherit;False;2169.339;437.102;Refraction;13;12;13;15;14;17;16;18;9;10;11;8;7;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-2074.272,-38.75002;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;7;-1799.164,-134.1603;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.2,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;8;-1810.557,28.20613;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.4;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;10;-1593.737,-184.4941;Inherit;True;Property;_Refraction_Waviness;Refraction_Waviness;5;0;Create;True;0;0;0;False;0;False;-1;None;443af2a11bb01f845b4c6fcdd3ee2a6b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-1600.008,2.049123;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;10;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-1296.508,-168.4991;Inherit;False;Property;_Refraction_Waviness_Intensity;Refraction_Waviness_Intensity;6;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;9;-1273.27,-53.59555;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1096.515,64.14231;Inherit;False;Property;_Refraction_UV_Add;Refraction_UV_Add;4;0;Create;True;0;0;0;False;0;False;3;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1022.608,-101.8279;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;15;-876.5147,68.14231;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-879.0516,-40.92184;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-741.1765,-40.49954;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;52;-454.8359,-815.9597;Inherit;False;1126.086;576.5419;ColorOutput;8;19;20;21;46;45;47;29;48;;1,0.9735144,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;53;-775.4907,206.3967;Inherit;False;904.16;356.2231;Normal;4;4;5;2;3;;0,0.5760117,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-380.696,-690.9857;Inherit;False;Property;_Refraction_B;Refraction_B;3;0;Create;True;0;0;0;False;0;False;2.1;2.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-387.3575,-765.9597;Inherit;False;Property;_Refraction_A;Refraction_A;2;0;Create;True;0;0;0;False;0;False;1.1;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-725.4905,257.4149;Inherit;True;Property;_Normal;Normal;7;0;Create;True;0;0;0;False;0;False;None;0aa577001ae66b641bef387bb0138b68;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;12;-560.689,-170.3526;Inherit;True;Property;_Refraction;Refraction;1;0;Create;True;0;0;0;False;0;False;-1;None;747d3d4acd2ceb14aa048ae5cea5f566;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;21;-166.2926,-737.5685;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-358.1989,256.3967;Inherit;True;Property;_TextureSample0;Texture Sample 0;17;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;46;-169.5997,-621.4805;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RefractOpVec;45;18.41526,-615.4549;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;27;580.9102,50.92545;Inherit;False;Property;_Roughness;Roughness;9;0;Create;True;0;0;0;False;0;False;0;-2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;29;277.2769,-451.4178;Inherit;False;Property;_TintColor;TintColor;0;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;47;180.7822,-643.6104;Inherit;True;Property;_Cubemap;Cubemap;10;0;Create;True;0;0;0;False;0;False;-1;None;df17c36dd0a391842bccaa3843230c58;True;0;False;white;Auto;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FaceVariableNode;2;-191.6439,451.6196;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;28;740.5802,55.7609;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;793.1243,136.0958;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;741.2446,-13.6276;Inherit;False;Property;_Metallic;Metallic;8;0;Create;True;0;0;0;False;0;False;0.75;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;509.2501,-532.6162;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-33.32897,332.9935;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;31;946.5239,-81.58442;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Davis3D/OceanEnviroment/ParticlesBubbles;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;;3;False;;False;0;False;;0;False;;False;0;Transparent;0.001;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;2;5;False;;10;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;6;0
WireConnection;8;0;6;0
WireConnection;10;1;7;0
WireConnection;11;1;8;0
WireConnection;9;0;10;2
WireConnection;9;1;11;2
WireConnection;17;0;18;0
WireConnection;17;1;9;0
WireConnection;15;0;16;0
WireConnection;14;0;6;0
WireConnection;14;1;17;0
WireConnection;13;0;14;0
WireConnection;13;1;15;0
WireConnection;12;1;13;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;21;2;12;2
WireConnection;5;0;4;0
WireConnection;5;1;13;0
WireConnection;5;7;4;1
WireConnection;45;0;46;0
WireConnection;45;1;5;0
WireConnection;45;2;21;0
WireConnection;47;1;45;0
WireConnection;28;0;27;0
WireConnection;22;0;12;2
WireConnection;22;1;29;4
WireConnection;48;0;47;0
WireConnection;48;1;29;0
WireConnection;3;0;5;0
WireConnection;3;1;2;0
WireConnection;31;0;29;0
WireConnection;31;1;3;0
WireConnection;31;2;48;0
WireConnection;31;3;26;0
WireConnection;31;4;28;0
WireConnection;31;9;22;0
ASEEND*/
//CHKSM=AFFEDBCB497730B618A312A46A0C5CB5A8852DED