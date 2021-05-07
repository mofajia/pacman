/*
 * spu.c
 *
 *  Created on: 2021��4��28��
 *      Author: user
 */

#include "spu.h"

void spu_set_sprite(int x, int y, int index)
{
	spu_control((x << 14) | (y << 8) | (0x00FF & index));
}

void spu_set_map(int *map)
{
	for (int y = 0; y < SPU_MAP_HEIGHT; ++y) {
		for (int x = 0; x < SPU_MAP_WIDTH; ++x) {
			spu_set_sprite(x, y, map[y * SPU_MAP_WIDTH + x]);
		}
	}
}
