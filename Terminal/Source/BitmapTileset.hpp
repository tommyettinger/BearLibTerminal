/*
 * BitmapTileset.hpp
 *
 *  Created on: Oct 17, 2013
 *      Author: Cfyz
 */

#ifndef BITMAPTILESET_HPP_
#define BITMAPTILESET_HPP_

#include "Tileset.hpp"
#include "Encoding.hpp"
#include "Bitmap.hpp"

namespace BearLibTerminal
{
	class BitmapTileset: public StronglyTypedReloadableTileset<BitmapTileset>
	{
	public:
		BitmapTileset(TileContainer& container, OptionGroup& group);
		void Remove();
		bool Save();
		void Reload(BitmapTileset&& tileset);
		Size GetBoundingBoxSize();
		Size GetSpacing();
		const Encoding<char>* GetCodepage();
		Type GetType();
		bool Provides(uint16_t code);
		void Prepare(uint16_t code);
	private:
		Bitmap m_cache;
		uint16_t m_base_code;
		Size m_tile_size;
		Size m_bbox_size;
		Size m_grid_size;
		std::unique_ptr<Encoding<char>> m_codepage;
		Tile::Alignment m_alignment;
	};
}

#endif /* BITMAPTILESET_HPP_ */
