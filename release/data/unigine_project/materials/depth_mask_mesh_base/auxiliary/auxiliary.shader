
/* Copyright (C) 2005-2017, UNIGINE Corp. All rights reserved.
 *
 * This file is a part of the UNIGINE 2.6.1.1 SDK.
 *
 * Your use and / or redistribution of this software in source and / or
 * binary form, with or without modification, is subject to: (i) your
 * ongoing acceptance of and compliance with the terms and conditions of
 * the UNIGINE License Agreement; and (ii) your inclusion of this notice
 * in any version of this software that you use or redistribute.
 * A copy of the UNIGINE License Agreement is available by contacting
 * UNIGINE Corp. at http://unigine.com/
 */


#include <core/shaders/mesh/common/common.h>

#ifdef VERTEX
	#include <unigine_project/materials/depth_mask_mesh_base/common/vertex.h>
#elif FRAGMENT
	#include <unigine_project/materials/depth_mask_mesh_base/common/fragment.h>
#endif

STRUCT(FRAGMENT_IN)
	INIT_POSITION
	
	INIT_DATA(float4,0,DATA_UV)
	
	INIT_DATA(float3,8,DATA_VERTEX_POSITION)
	INIT_DATA(float3,9,DATA_OBJECT_NORMAL)
	
	#ifdef VERTEX_COLOR
		INIT_DATA(float4,10,DATA_VERTEX_COLOR)
	#endif
	
	INIT_DATA(float3,12,DATA_POSITION)
	
	INIT_DATA(float, 13, DATA_OBLIQUE_FRUSTUM)
	
	#ifdef ALPHA_FADE && USE_ALPHA_FADE
		INIT_DATA(float,14,DATA_ALPHA_FADE)
	#endif

	#ifdef TWO_SIDED
		INIT_FRONTFACE
	#endif
	
END

#ifdef VERTEX

MAIN_BEGIN_VERTEX(FRAGMENT_IN)
	
	#include <unigine_project/materials/depth_mask_mesh_base/common/vertex.h>
MAIN_END

#elif FRAGMENT

INIT_TEXTURE(3,TEX_AUXILIARY)

MAIN_BEGIN(FRAGMENT_OUT,FRAGMENT_IN)
	
	IF_DATA(DATA_OBLIQUE_FRUSTUM)
		if(DATA_OBLIQUE_FRUSTUM > 0.0f) discard;
	ENDIF
	
	IF_DATA(DATA_ALPHA_FADE)
		texture2DAlphaFadeDiscard(DATA_ALPHA_FADE,IN_POSITION.xy);
	ENDIF
	
	#include <core/shaders/mesh/common/uv_select.h>
	
	OUT_COLOR = TEXTURE_BASE(TEX_AUXILIARY) * m_auxiliary_color;
	
	#ifdef VERTEX_COLOR && VERTEX_AUXILIARY
		OUT_COLOR *= DATA_VERTEX_COLOR;
	#endif
	
MAIN_END

#endif
