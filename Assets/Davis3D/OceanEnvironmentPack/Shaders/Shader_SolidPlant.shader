// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Davis3D/OceanEnviroment/Shader_SolidPlant"
{
	Properties
	{
		_ColorDiffuseMultiply("Color Diffuse Multiply", Color) = (1,1,1,1)
		_ColorDiffuseLerp("Color Diffuse Lerp", Color) = (1,1,1,1)
		_Diffuse_Color_Lerp("Diffuse_Color_Lerp", Float) = 0
		_Diffuse("Diffuse", 2D) = "white" {}
		_Roughness("Roughness", Float) = 0
		_Normal("Normal", 2D) = "bump" {}
		_NormalDetail("NormalDetail", 2D) = "bump" {}
		_NormalDetailScale("Normal Detail Scale", Float) = 6
		_NormalDetailIntensity("Normal Detail Intensity", Float) = 1
		_NormalDetail2("NormalDetail2", 2D) = "bump" {}
		_NormalDetail2Scale("Normal Detail2 Scale", Float) = 6
		_NormalDetail2Intensity("Normal Detail2 Intensity", Float) = 1
		[Toggle(_DIFFUSEDETAIL_ON)] _DiffuseDetail("DiffuseDetail", Float) = 0
		_DiffuseVariation_Color("DiffuseVariation_Color", Color) = (0,0,0,1)
		_Diffuse_Variation_Mult("Diffuse_Variation_Mult", Color) = (1,1,1,1)
		_Dif_VariationMask("Dif_VariationMask", 2D) = "white" {}
		_Diffuse_Variation_Amount("Diffuse_Variation_Amount", Float) = 1
		_Diffuse_Variation_Color_Lerp("Diffuse_Variation_Color_Lerp", Float) = 0
		_Diffuse_Variation_Hue("Diffuse_Variation_Hue", Float) = 0
		_Diffuse_HueFromMask("Diffuse_HueFromMask", Float) = 0
		_GlowColor("Glow Color", Color) = (0,0.2886519,1,0)
		_Glow("Glow", 2D) = "white" {}
		_Fake_SSS_Glow("Fake_SSS_Glow", Float) = 0.01
		_GlowMultiply("GlowMultiply", Float) = 1
		_Glow_Inverted("Glow_Inverted", Float) = 0
		_DiffusionVariantion_UV_Scale("DiffusionVariantion_UV_Scale", Float) = 1
		_MASTER_UVScale("MASTER_UVScale", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _DIFFUSEDETAIL_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float _MASTER_UVScale;
		uniform sampler2D _NormalDetail;
		uniform float _NormalDetailScale;
		uniform float _NormalDetailIntensity;
		uniform sampler2D _NormalDetail2;
		uniform float _NormalDetail2Scale;
		uniform float _NormalDetail2Intensity;
		uniform float4 _ColorDiffuseMultiply;
		uniform sampler2D _Diffuse;
		uniform float4 _ColorDiffuseLerp;
		uniform float _Diffuse_Color_Lerp;
		uniform float4 _Diffuse_Variation_Mult;
		uniform float _Diffuse_Variation_Hue;
		uniform sampler2D _Dif_VariationMask;
		uniform float _DiffusionVariantion_UV_Scale;
		uniform float _Diffuse_HueFromMask;
		uniform float4 _DiffuseVariation_Color;
		uniform float _Diffuse_Variation_Color_Lerp;
		uniform float _Diffuse_Variation_Amount;
		uniform float _Fake_SSS_Glow;
		uniform float4 _GlowColor;
		uniform sampler2D _Glow;
		uniform float _Glow_Inverted;
		uniform float _GlowMultiply;
		uniform float _Roughness;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 UVMaster295 = ( i.uv_texcoord * _MASTER_UVScale );
			float3 Normal333 = BlendNormals( UnpackNormal( tex2D( _Normal, UVMaster295 ) ) , BlendNormals( UnpackScaleNormal( tex2D( _NormalDetail, ( UVMaster295 * _NormalDetailScale ) ), _NormalDetailIntensity ) , UnpackScaleNormal( tex2D( _NormalDetail2, ( UVMaster295 * _NormalDetail2Scale ) ), _NormalDetail2Intensity ) ) );
			o.Normal = Normal333;
			float4 tex2DNode2 = tex2D( _Diffuse, UVMaster295 );
			float4 lerpResult345 = lerp( ( _ColorDiffuseMultiply * tex2DNode2 ) , _ColorDiffuseLerp , _Diffuse_Color_Lerp);
			float4 ClearDiffuse307 = lerpResult345;
			float4 color5_g1 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float4 normalizeResult6_g1 = normalize( color5_g1 );
			float4 temp_cast_1 = (_Diffuse_Variation_Hue).xxxx;
			float4 tex2DNode324 = tex2D( _Dif_VariationMask, ( UVMaster295 * _DiffusionVariantion_UV_Scale ) );
			float4 lerpResult321 = lerp( temp_cast_1 , tex2DNode324 , _Diffuse_HueFromMask);
			float3 temp_cast_3 = (0.0).xxx;
			float3 temp_output_3_0_g1 = tex2DNode2.rgb;
			float3 rotatedValue2_g1 = RotateAroundAxis( temp_cast_3, temp_output_3_0_g1, normalizeResult6_g1.rgb, lerpResult321.r );
			float4 lerpResult315 = lerp( ( _Diffuse_Variation_Mult * float4( ( rotatedValue2_g1 + temp_output_3_0_g1 ) , 0.0 ) ) , _DiffuseVariation_Color , _Diffuse_Variation_Color_Lerp);
			float4 lerpResult306 = lerp( ClearDiffuse307 , lerpResult315 , tex2DNode324);
			float4 lerpResult304 = lerp( ClearDiffuse307 , lerpResult306 , _Diffuse_Variation_Amount);
			#ifdef _DIFFUSEDETAIL_ON
				float4 staticSwitch336 = lerpResult304;
			#else
				float4 staticSwitch336 = ClearDiffuse307;
			#endif
			float4 FinalDiffuse310 = staticSwitch336;
			o.Albedo = FinalDiffuse310.rgb;
			float4 tex2DNode263 = tex2D( _Glow, UVMaster295 );
			float lerpResult284 = lerp( tex2DNode263.g , ( 1.0 - tex2DNode263.g ) , _Glow_Inverted);
			float4 Emission301 = ( ( ClearDiffuse307 * _Fake_SSS_Glow ) + ( _GlowColor * ( lerpResult284 * _GlowMultiply ) ) );
			o.Emission = Emission301.rgb;
			o.Smoothness = ( 1.0 - _Roughness );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;300;-3083.19,-386.5224;Inherit;False;632.5991;284.2604;uv;4;279;280;295;281;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;281;-3016.868,-218.2617;Inherit;False;Property;_MASTER_UVScale;MASTER_UVScale;26;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;279;-3033.191,-336.5222;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;280;-2810.867,-286.2619;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;328;-2646.47,-1183.258;Inherit;False;2445.734;776.2036;Diffuse Variation;19;310;336;304;306;305;315;314;317;318;316;320;319;321;323;322;324;325;327;326;;0.9469855,1,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;295;-2674.592,-290.8155;Inherit;False;UVMaster;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;326;-2500.572,-1044.385;Inherit;False;295;UVMaster;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;327;-2596.47,-974.5839;Inherit;False;Property;_DiffusionVariantion_UV_Scale;DiffusionVariantion_UV_Scale;25;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;308;-2435.8,-389.5979;Inherit;False;1137.86;463.398;ClearDiffuse;8;18;307;303;2;299;344;345;346;;0.5943396,0.5943396,0.5943396,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;325;-2327.678,-1030.085;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;299;-2374.185,-147.4249;Inherit;False;295;UVMaster;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;289;-2438.071,80.13889;Inherit;False;1828.793;484.2859;Emission;14;296;301;292;290;266;329;291;267;288;287;284;285;286;263;;0.2349766,1,0,1;0;0
Node;AmplifyShaderEditor.ColorNode;18;-2110.724,-338.3486;Inherit;False;Property;_ColorDiffuseMultiply;Color Diffuse Multiply;0;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-2196.515,-168.4619;Inherit;True;Property;_Diffuse;Diffuse;3;0;Create;True;0;0;0;False;0;False;-1;abc00000000001451746144983788521;abc00000000001451746144983788521;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;322;-2132.466,-875.7621;Inherit;False;Property;_Diffuse_HueFromMask;Diffuse_HueFromMask;19;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;323;-2122.78,-1134.413;Inherit;False;Property;_Diffuse_Variation_Hue;Diffuse_Variation_Hue;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;324;-2201.292,-1059.734;Inherit;True;Property;_Dif_VariationMask;Dif_VariationMask;15;0;Create;True;0;0;0;False;0;False;-1;abc00000000009646882884457935499;abc00000000009646882884457935499;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;296;-2397.827,265.8725;Inherit;False;295;UVMaster;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;321;-1883.015,-1065.793;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;346;-1833.568,-257.6876;Inherit;False;Property;_Diffuse_Color_Lerp;Diffuse_Color_Lerp;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;344;-1919.922,-98.82759;Inherit;False;Property;_ColorDiffuseLerp;Color Diffuse Lerp;1;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;-1882.415,-190.9308;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;345;-1695.56,-129.2116;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;320;-1731.483,-772.2402;Inherit;False;HueShift;-1;;1;3748b6194161e1143a6905ade0b83f9a;0;2;1;FLOAT;0;False;3;FLOAT3;0,1,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;335;-1982.554,584.6701;Inherit;False;1609.561;1134.554;Normal;18;5;333;343;341;339;342;340;332;57;331;69;337;338;99;8;98;3;330;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;263;-2212.518,242.8408;Inherit;True;Property;_Glow;Glow;21;0;Create;True;0;0;0;False;0;False;-1;abc00000000014400254202910335805;abc00000000014400254202910335805;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;319;-1629.257,-941.5938;Inherit;False;Property;_Diffuse_Variation_Mult;Diffuse_Variation_Mult;14;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;318;-1370.042,-796.5878;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;307;-1488.832,-199.3287;Inherit;False;ClearDiffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;316;-1453.959,-690.4984;Inherit;False;Property;_Diffuse_Variation_Color_Lerp;Diffuse_Variation_Color_Lerp;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;317;-1422.678,-619.0543;Inherit;False;Property;_DiffuseVariation_Color;DiffuseVariation_Color;13;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;331;-1687.642,1003.906;Inherit;False;295;UVMaster;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;286;-1958.317,420.2307;Inherit;False;Property;_Glow_Inverted;Glow_Inverted;24;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;340;-1692.552,1473.792;Inherit;False;295;UVMaster;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;285;-1917.193,351.8656;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;341;-1726.745,1544.69;Inherit;False;Property;_NormalDetail2Scale;Normal Detail2 Scale;10;0;Create;True;0;0;0;False;0;False;6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1721.835,1074.804;Inherit;False;Property;_NormalDetailScale;Normal Detail Scale;7;0;Create;True;0;0;0;False;0;False;6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;315;-1181.699,-724.4302;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;314;-1215.715,-941.7828;Inherit;False;307;ClearDiffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-1722.446,1153.862;Inherit;False;Property;_NormalDetailIntensity;Normal Detail Intensity;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;342;-1518.338,1476.075;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;337;-1610.284,1272.666;Inherit;True;Property;_NormalDetail2;NormalDetail2;9;0;Create;True;0;0;0;False;0;False;abc00000000004188447198822879912;abc00000000004188447198822879912;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;332;-1513.428,1006.189;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;339;-1727.356,1623.748;Inherit;False;Property;_NormalDetail2Intensity;Normal Detail2 Intensity;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;287;-1754.686,437.8189;Inherit;False;Property;_GlowMultiply;GlowMultiply;23;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;284;-1740.287,311.8422;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;8;-1638.457,820.6245;Inherit;True;Property;_NormalDetail;NormalDetail;6;0;Create;True;0;0;0;False;0;False;abc00000000004188447198822879912;abc00000000004188447198822879912;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;338;-1323.851,1271.172;Inherit;True;Property;_TextureSample17;Texture Sample 16;35;0;Create;True;0;0;0;False;0;False;-1;abc00000000000746726904355842572;abc00000000000746726904355842572;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;305;-1026.623,-707.8231;Inherit;False;Property;_Diffuse_Variation_Amount;Diffuse_Variation_Amount;16;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1636.881,634.6701;Inherit;True;Property;_Normal;Normal;5;0;Create;True;0;0;0;False;0;False;abc00000000000746726904355842572;abc00000000000746726904355842572;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;330;-1827.02,653.2065;Inherit;False;295;UVMaster;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;291;-1407.911,318.653;Inherit;False;Property;_Fake_SSS_Glow;Fake_SSS_Glow;22;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;99;-1355.369,821.7045;Inherit;True;Property;_TextureSample16;Texture Sample 16;35;0;Create;True;0;0;0;False;0;False;-1;abc00000000000746726904355842572;abc00000000000746726904355842572;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;267;-1662.835,130.1387;Inherit;False;Property;_GlowColor;Glow Color;20;0;Create;True;0;0;0;False;0;False;0,0.2886519,1,0;0.2071467,0.3658273,0.4622642,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;329;-1300.482,117.7747;Inherit;False;307;ClearDiffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;306;-993.1773,-830.3785;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;-1573.034,331.074;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;98;-1357.889,635.3012;Inherit;True;Property;_T_Rocks_AB_New_Norm;T_Rocks_AB_New_Norm;35;0;Create;True;0;0;0;False;0;False;-1;abc00000000000746726904355842572;abc00000000000746726904355842572;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;290;-1108.844,122.3497;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;-1423.199,222.2778;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;304;-796.1693,-915.6227;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;343;-996.4103,1007.547;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;5;-770.5303,984.2228;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;292;-938.8753,203.5113;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;336;-644.1179,-1013.466;Inherit;False;Property;_DiffuseDetail;DiffuseDetail;12;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;293;-336.6299,100.0349;Inherit;False;Property;_Roughness;Roughness;4;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;310;-422.291,-1017.806;Inherit;False;FinalDiffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;301;-817.0103,198.4775;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;333;-572.7068,979.4588;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;294;-185.6299,104.0349;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;-263.5358,-38.64636;Inherit;False;310;FinalDiffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;334;-251.2898,31.50152;Inherit;False;333;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;302;-289.1497,237.7254;Inherit;False;301;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Davis3D/OceanEnviroment/Shader_SolidPlant;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;280;0;279;0
WireConnection;280;1;281;0
WireConnection;295;0;280;0
WireConnection;325;0;326;0
WireConnection;325;1;327;0
WireConnection;2;1;299;0
WireConnection;324;1;325;0
WireConnection;321;0;323;0
WireConnection;321;1;324;0
WireConnection;321;2;322;0
WireConnection;303;0;18;0
WireConnection;303;1;2;0
WireConnection;345;0;303;0
WireConnection;345;1;344;0
WireConnection;345;2;346;0
WireConnection;320;1;321;0
WireConnection;320;3;2;0
WireConnection;263;1;296;0
WireConnection;318;0;319;0
WireConnection;318;1;320;0
WireConnection;307;0;345;0
WireConnection;285;0;263;2
WireConnection;315;0;318;0
WireConnection;315;1;317;0
WireConnection;315;2;316;0
WireConnection;342;0;340;0
WireConnection;342;1;341;0
WireConnection;332;0;331;0
WireConnection;332;1;57;0
WireConnection;284;0;263;2
WireConnection;284;1;285;0
WireConnection;284;2;286;0
WireConnection;338;0;337;0
WireConnection;338;1;342;0
WireConnection;338;5;339;0
WireConnection;338;7;337;1
WireConnection;99;0;8;0
WireConnection;99;1;332;0
WireConnection;99;5;69;0
WireConnection;99;7;8;1
WireConnection;306;0;314;0
WireConnection;306;1;315;0
WireConnection;306;2;324;0
WireConnection;288;0;284;0
WireConnection;288;1;287;0
WireConnection;98;0;3;0
WireConnection;98;1;330;0
WireConnection;98;7;3;1
WireConnection;290;0;329;0
WireConnection;290;1;291;0
WireConnection;266;0;267;0
WireConnection;266;1;288;0
WireConnection;304;0;314;0
WireConnection;304;1;306;0
WireConnection;304;2;305;0
WireConnection;343;0;99;0
WireConnection;343;1;338;0
WireConnection;5;0;98;0
WireConnection;5;1;343;0
WireConnection;292;0;290;0
WireConnection;292;1;266;0
WireConnection;336;1;314;0
WireConnection;336;0;304;0
WireConnection;310;0;336;0
WireConnection;301;0;292;0
WireConnection;333;0;5;0
WireConnection;294;0;293;0
WireConnection;0;0;311;0
WireConnection;0;1;334;0
WireConnection;0;2;302;0
WireConnection;0;4;294;0
ASEEND*/
//CHKSM=0912F8DF6677AD8D647684AF3B14E4E2A5F5B753