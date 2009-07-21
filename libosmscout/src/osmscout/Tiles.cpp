/*
  TravelJinni - Openstreetmap offline viewer
  Copyright (C) 2009  Tim Teulings

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#include <osmscout/Tiles.h>

#include <cmath>

static double tileDiv = 20;

double GetTileWidth()
{
  return 1/tileDiv;
}

double GetTileHeight()
{
  return 1/tileDiv;
}

size_t GetTileX(double lon)
{
  return ceil((lon+180)*tileDiv);
}

size_t GetTileY(double lat)
{
  return ceil((lat+90)*tileDiv);
}

TileId GetTileId(size_t x, size_t y)
{
  return y*360*tileDiv+x;
}

TileId GetTileId(double lon, double lat)
{
  return GetTileId(GetTileX(lon),GetTileY(lat));
}

