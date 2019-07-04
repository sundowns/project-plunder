local mappy = {}

-- splits a path into directory, file (with filename), and just filename
-- i really only need the directory
-- https://stackoverflow.com/a/12191225
local function splitPath(path)
    return string.match(path, '(.-)([^\\/]-%.?([^%.\\/]*))$')
end

-- Decompress tile layer data
local function getDecompressedData(data)
	local ffi     = require 'ffi'
	local d       = {}
	local decoded = ffi.cast('uint32_t*', data)

	for i = 0, data:len() / ffi.sizeof('uint32_t') - 1 do
		table.insert(d, tonumber(decoded[i]))
	end

	return d
end

-- joins two paths together into a reasonable path that Lua can use. handles going up a directory using ..
-- https://github.com/karai17/Simple-Tiled-Implementation/blob/master/sti/utils.lua#L5
local function formatPath(path)
	local npGen1, npGen2 = '[^SEP]+SEP%.%.SEP?', 'SEP+%.?SEP'
	local npPat1, npPat2 = npGen1:gsub('SEP', '/'), npGen2:gsub('SEP', '/')
	local k
	repeat path, k = path:gsub(npPat2, '/') until k == 0
	repeat path, k = path:gsub(npPat1, '') until k == 0
	if path == '' then path = '.' end
	return path
end

-- given a grid with w items per row, return the column and row of the nth item (going from left to right, top to bottom)
-- https://stackoverflow.com/a/9816217
local function getCoordinates(n, w)
	return (n - 1) % w, math.floor((n - 1) / w)
end

-- Represents a tileset in an exported Tiled map.
local Tileset = {}
Tileset.__index = Tileset

function Tileset:_init(map)
	self._map = map
	if self.image then
		local image = self._map._images[self.image]
		-- save the number of tiles per row so we don't have to calculate it later
		self._tilesPerRow = math.floor(image:getWidth() / (self.tilewidth + self.spacing))
	end
end

-- Gets the tile with the specified global id.
function Tileset:_getTile(gid)
	for _, tile in ipairs(self.tiles) do
		if self.firstgid + tile.id == gid then
			return tile
		end
	end
end

--[[
	Gets the image and optionally quad of the tile with the specified global id.
	If the tileset is a collection of images, then each tile has its own image,
	so it'll just return the image. If the tileset is one image with a grid
	that defines the individual tiles, then it'll also return the quad for the
	specific tile.

	If the tile is animated, then it'll return the correct tile for the current
	animation frame (defaults to 1).
]]
function Tileset:_getTileImageAndQuad(gid, frame)
	frame = frame or 1
	local tile = self:_getTile(gid)
	if tile and tile.animation then
		-- get the appropriate frame for animated tiles
		local currentFrameGid = self.firstgid + tile.animation[frame].tileid
		if currentFrameGid ~= gid then
			return self:_getTileImageAndQuad(currentFrameGid, frame)
		end
	end
	if tile and tile.image then
		-- if each tile has its own image, just return that image
		return self._map._images[tile.image]
	elseif self.image then
		-- return the tileset image and the quad representing the specific tile
		local image = self._map._images[self.image]
		local x, y = getCoordinates(gid - self.firstgid + 1, self._tilesPerRow)
		local quad = love.graphics.newQuad(
			x * (self.tilewidth + self.spacing),
			y * (self.tileheight + self.spacing),
			self.tilewidth, self.tileheight,
			image:getWidth(), image:getHeight())
		return image, quad
	else
		return false
	end
end

-- this metatable is applied to map.layers so that layers can be accessed by name
local LayerList = {
	__index = function(self, k)
		for _, layer in ipairs(self) do
			if layer.name == k then return layer end
		end
		return rawget(self, k)
	end,
}

-- this metatable is applied to Objectlayr.objects so that objects can be accessed by name
local ObjectList = {
	__index = function(self, k)
		for _, object in ipairs(self) do
			if object.name == k then return object end
		end
		return rawget(self, k)
	end,
}

local Layer = {}

local function getLayerClassForType(layer_type)
	if layer_type == 'tilelayer' then return Layer.TileLayer
	elseif layer_type == 'imagelayer' then return Layer.ImageLayer
	elseif layer_type == 'group' then return Layer.Group
	elseif layer_type == 'objectgroup' then return Layer.ObjectGroup end
	error('could not find layer type: ' .. layer_type)
end


--[[
	Represents any layer type that can contain tiles (currently tile layers and object layers).
	There's no layer type in Tiled called "item layers", it's just a parent class to share code between
	tile layers and object layers.
]]
Layer.ItemLayer = {}
Layer.ItemLayer.__index = Layer.ItemLayer

function Layer.ItemLayer:_init(map)
	self._map = map
	self._unbatchedItems = {}

	if self.type == 'tilelayer' and self.encoding == 'base64' then
		assert(require "ffi", "Compressed maps require LuaJIT FFI.\nPlease Switch your interperator to LuaJIT or your Tile Layer Format to \"CSV\".")
		local decoded = love.data.decode('string', 'base64', self.data)

		if not self.compression then
			self.data = getDecompressedData(decoded)
		elseif self.compression == 'zlib' then
			local data = love.data.decompress('string', 'zlib', decoded)
			self.data = getDecompressedData(data)
		elseif self.compression == 'gzip' then
			local data = love.data.decompress('string', 'gzip', decoded)
			self.data = getDecompressedData(data)
		end

		self.encoding = 'lua'
		self.compression = nil
	end

	self:_initAnimations()
	self:_createSpriteBatches()

	if self.type == 'tilelayer' then self:_fillSpriteBatches() end
	if self.type == 'objectgroup' then setmetatable(self.objects, ObjectList) end
end

-- Starts timers for each animated tile in the map.
function Layer.ItemLayer:_initAnimations()
	self._animations = {}
	for _, tileset in ipairs(self._map.tilesets) do
		self._animations[tileset] = {}
		for _, tile in ipairs(tileset.tiles) do
			if tile.animation then
				local gid = tileset.firstgid + tile.id
				self._animations[tileset][gid] = {
					frames = tile.animation,
					frame = 1,
					timer = tile.animation[1].duration,
					sprites = {},
				}
			end
		end
	end
end

-- Creates sprite batches for each single-image tileset.
function Layer.ItemLayer:_createSpriteBatches()
	self._spriteBatches = {}
	for _, tileset in ipairs(self._map.tilesets) do
		if tileset.image then
			local image = self._map._images[tileset.image]
			self._spriteBatches[image] = love.graphics.newSpriteBatch(image)
		end
	end
end

-- Renders the layer to sprite batches. Only tiles that are part of a single-image tileset are batched.
function Layer.ItemLayer:_fillSpriteBatches()
	for i = 1, self:_getNumberOfItems() do
		local gid, x, y = self:_getItem(i)
		if gid and x and y then
			-- Scan for tile flip bit flags
			local gid_rot_min = 2^29
			local flip_h, flip_v, flip_d;
			if gid > gid_rot_min then
				if bit.band(gid, 0x80000000) ~= 0 then flip_h = true end
				if bit.band(gid, 0x40000000) ~= 0 then flip_v = true end
				if bit.band(gid, 0x20000000) ~= 0 then flip_d = true end
				gid = bit.band(gid, bit.bnot(bit.bor(0x80000000, 0x40000000, 0x20000000)))
			end

			local tileset = self._map:_getTileset(gid)
			if tileset.image then
				local image, quad = tileset:_getTileImageAndQuad(gid)
				local id

				if flip_h or flip_v or flip_d then
					local r = 0
					local sx = 1
					local sy = 1
					local q_x, q_y, q_w, q_h = quad:getViewport()
					local half_width = q_w * 0.5
					local half_height = q_h * 0.5

					if flip_h then sx = -1 end
					if flip_v then sy = -1 end

					if flip_d then
						sx, sy = -sy, sx
						r = math.pi * 1.5
					end
					id = self._spriteBatches[image]:add(quad, x + half_width, y + half_height, r, sx, sy, half_width, half_height)
				else
					id = self._spriteBatches[image]:add(quad, x, y)
				end

				-- save information about sprites that will be affected by animations, since we'll have to update them later
				if self._animations[tileset][gid] then
					if flip_h or flip_v or flip_d then
						assert(false, 'TODO: add support for flipped animated tiles')
					else
						table.insert(self._animations[tileset][gid].sprites, {
							id = id,
							x = x,
							y = y
						})
					end
				end
			else
				-- remember which items aren't part of a sprite batch so we can iterate through them in layer.draw
				local image = tileset:_getTileImageAndQuad(gid, 1)
				if flip_h or flip_v or flip_d then
					local r = 0
					local sx = 1
					local sy = 1
					local half_width = image:getWidth() * 0.5
					local half_height = image:getHeight() * 0.5

					if flip_h then sx = -1 end
					if flip_v then sy = -1 end

					if flip_d then
						sx, sy = -sy, sx
						r = math.pi * 1.5
						x = x + -sx * self._map.tilewidth
						y = y + -sy * self._map.tileheight
					end

					table.insert(self._unbatchedItems, {
						gid = gid,
						x = x + half_width,
						y = y - half_height + self._map.tileheight,
						r = r,
						sx = sx,
						sy = sy,
						ox = half_width,
						oy = half_height
					})
				else
					table.insert(self._unbatchedItems, {
						gid = gid,
						x = x,
						y = y - image:getHeight() + self._map.tileheight
					})
				end
			end
		end
	end
end

-- Updates the animation timers and changes sprites in the sprite batches as needed.
function Layer.ItemLayer:_updateAnimations(dt)
	for tileset, tilesetAnimations in pairs(self._animations) do
		for gid, animation in pairs(tilesetAnimations) do
			-- decrement the animation timer
			animation.timer = animation.timer - 1000 * dt
			while animation.timer <= 0 do
				-- move to then next frame of animation
				animation.frame = animation.frame + 1
				if animation.frame > #animation.frames then
					animation.frame = 1
				end
				-- increment the animation timer by the duration of the new frame
				animation.timer = animation.timer + animation.frames[animation.frame].duration
				-- update sprites
				if tileset.image then
					local image, quad = tileset:_getTileImageAndQuad(gid, animation.frame)
					--[[
						in _fillSpriteBatches we save the id, x position, and y position of sprites
						in the sprite batch that need to be updated because of animations.
						here we iterate through them and change the quad.
					]]
					for _, sprite in ipairs(animation.sprites) do
						self._spriteBatches[image]:set(sprite.id, quad, sprite.x, sprite.y)
					end
				end
			end
		end
	end
end

-- Gets the properties table on the specified tile, if it exists. x and y are zero-based.
function Layer.ItemLayer:getTileProperties(x, y)
	local index = x + y * self.width + 1
	local gid = self.data[index]
	return self._map:getTileProperties(gid)
end

function Layer.ItemLayer:update(dt)
	self:_updateAnimations(dt)
end

function Layer.ItemLayer:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetx, self.offsety)

	-- draw the sprite batches
	for _, spriteBatch in pairs(self._spriteBatches) do
		love.graphics.draw(spriteBatch)
	end

	-- draw the items that aren't part of a sprite batch
	for _, item in ipairs(self._unbatchedItems) do
		local tileset = self._map:_getTileset(item.gid)
		local frame = 1
		if self._animations[tileset][item.gid] then
			frame = self._animations[tileset][item.gid].frame
		end
		local image = tileset:_getTileImageAndQuad(item.gid, frame)
		love.graphics.draw(image, item.x, item.y, item.r, item.sx, item.sy, item.ox, item.oy)
	end
	love.graphics.pop()
end


-- Represents a tile layer in an exported Tiled map.
Layer.TileLayer = setmetatable({}, {__index = Layer.ItemLayer})
Layer.TileLayer.__index = Layer.TileLayer

-- Gets the x and y position of the nth tile in the layer's tile data.
function Layer.TileLayer:_getTilePosition(n, width, offsetX, offsetY)
	width = width or self.width
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	local x, y = getCoordinates(n, width)
	x, y = x + offsetX, y + offsetY
	x, y = x * self._map.tilewidth, y * self._map.tileheight
	x, y = x + self.offsetx, y + self.offsety
	return x, y
end

function Layer.TileLayer:_getNumberOfItems()
	-- for infinite maps, get the total number of items split up among all the chunks
	if self.chunks then
		local items = 0
		for _, chunk in ipairs(self.chunks) do
			items = items + #chunk.data
		end
		return items
	end
	-- otherwise, just get the length of the data
	return #self.data
end

-- Gets the global gid, x position, and y position of a tile
function Layer.TileLayer:_getItem(i)
	--[[
		for infinite maps, treat all the chunk data like one big array
		each chunk has its own row width and x/y offset, which we factor
		into the position of each sprite on the screen
	]]
	if self.chunks then
		for _, chunk in ipairs(self.chunks) do
			if i <= #chunk.data then
				local gid = chunk.data[i]
				if gid ~= 0 then
					local x, y = self:_getTilePosition(i, chunk.width, chunk.x, chunk.y)
					return gid, x, y
				end
				return false
			end
			i = i - #chunk.data
		end
	end

	local gid = self.data[i]
	if gid ~= 0 then
		local x, y = self:_getTilePosition(i)
		return gid, x, y
	end
	return false
end

function Layer.TileLayer:_findBoundsRect(start_x, end_x, start_y, checked)
	local index = -1

	for y = start_y + 1, self.height - 1 do
		for x = start_x, end_x - 1 do
			index = y * self.width + x + 1
			local gid = self.data[index]

			if gid == 0 or checked[index] then
				for _x = start_x, x do
					index = y * self.width + _x + 1
					checked[index] = false
				end

				return start_x * self._map.tilewidth, start_y * self._map.tileheight, (end_x - start_x) * self._map.tilewidth, (y - start_y) * self._map.tileheight
			end

			checked[index] = true
		end
	end

	return start_x * self._map.tilewidth, start_y * self._map.tileheight, (end_x - start_x) * self._map.tilewidth, (self._map.height - start_y) * self._map.tileheight
end

function Layer.TileLayer:getCollidersIter()
	local checked = {}
	local start_col = -1

	return function()
		for y = 0, self.height - 1 do
			for x = 0, self.width - 1 do
				local index = y * self.width + x + 1
				local gid = self.data[index]

				if gid ~= 0 and not checked[index] then
					if start_col < 0 then start_col = x end
					checked[index] = true
				elseif gid == 0 or checked[index] then
					if start_col >= 0 then
						local rx, ry, rw, rh = self:_findBoundsRect(start_col, x, y, checked)
						start_col = -1
						return rx, ry, rw, rh
					end
				end
			end

			-- special case for when we have a full row
			if start_col >= 0 then
				local rx, ry, rw, rh = self:_findBoundsRect(start_col, self.width, y, checked)
				start_col = -1
				return rx, ry, rw, rh
			end
		end
	end
end


-- Represents an object layer in an exported Tiled map.
Layer.ObjectGroup = setmetatable({}, {__index = Layer.ItemLayer})
Layer.ObjectGroup.__index = Layer.ObjectGroup

function Layer.ObjectGroup:draw()
	for i, _ in ipairs(self.objects) do
		local object = self.objects[i]
		if object.color then
			love.graphics.setColor(object.color[1] / 255, object.color[2] / 255, object.color[3] / 255)
		else
			love.graphics.setColor(1, 0, 0)
		end

		love.graphics.push()
		love.graphics.translate(object.x, object.y)
		love.graphics.print(object.name, 0, -love.graphics.getFont():getHeight())
		love.graphics.rotate(math.rad(object.rotation))

		if object.shape == 'rectangle' then
			if object.gid then
				love.graphics.setColor(1, 1, 1)
				local tileset = self._map:_getTileset(object.gid)
				local image, quad = tileset:_getTileImageAndQuad(object.gid)
				if image and quad then love.graphics.draw(image, quad, 0, -object.height)
				elseif image then love.graphics.draw(image, 0, -object.height, 0, object.width / image:getWidth(), object.height / image:getHeight()) end
			else
				love.graphics.rectangle('line', 0, 0, object.width, object.height)
			end
		elseif object.shape == 'point' then
			love.graphics.points(0, 0)
		elseif object.shape == 'ellipse' then
			love.graphics.ellipse('line', object.width / 2, object.height / 2, object.width / 2, object.height / 2)
		elseif object.shape == 'polyline' then
			local points = {}
			for j, _ in ipairs(object.polyline) do
				table.insert(points, object.polyline[j].x)
				table.insert(points, object.polyline[j].y)
			end
			love.graphics.line(points)
		elseif object.shape == 'text' then
			love.graphics.print(object.text)
		elseif object.shape == 'polygon' then
			local points = {}
			for j, _ in ipairs(object.polygon) do
				table.insert(points, object.polygon[j].x)
				table.insert(points, object.polygon[j].y)
			end
			love.graphics.polygon('line', points)
		end

		love.graphics.pop()
		love.graphics.setColor(1, 1, 1)
	end
end


-- Represents an image layer in an exported Tiled map.
Layer.ImageLayer = {}
Layer.ImageLayer.__index = Layer.ImageLayer

function Layer.ImageLayer:_init(map)
	self._map = map
end

function Layer.ImageLayer:draw()
	love.graphics.draw(self._map._images[self.image], self.offsetx, self.offsety)
end


-- Represents a layer group in an exported Tiled map.
Layer.Group = {}
Layer.Group.__index = Layer.Group

function Layer.Group:_init(map)
	for _, layer in ipairs(self.layers) do
		setmetatable(layer, getLayerClassForType(layer.type))
		layer:_init(map)
	end
	setmetatable(self.layers, LayerList)
end

function Layer.Group:update(dt)
	for _, layer in ipairs(self.layers) do
		if layer.update then layer:update(dt) end
	end
end

function Layer.Group:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetx, self.offsety)
	for _, layer in ipairs(self.layers) do
		if layer.visible and layer.draw then layer:draw() end
	end
	love.graphics.pop()
end


-- Represents an exported Tiled map.
local Map = {}
Map.__index = Map

function Map:_init(path)
	self.dir = splitPath(path)
	self:_loadImages()
	self:_initTilesets()
	self:_initLayers()
end

-- Loads an image if it hasn't already been loaded yet.
-- Images are stored in map._images, and the key is the relative path to the image.
function Map:_loadImage(relativeImagePath)
	if self._images[relativeImagePath] then return end
	local imagePath = formatPath(self.dir .. relativeImagePath)
	self._images[relativeImagePath] = love.graphics.newImage(imagePath)
end

-- Loads all of the images used by the map.
function Map:_loadImages()
	self._images = {}
	for _, tileset in ipairs(self.tilesets) do
		if tileset.image then self:_loadImage(tileset.image) end
		for _, tile in ipairs(tileset.tiles) do
			if tile.image then self:_loadImage(tile.image) end
		end
	end
	for _, layer in ipairs(self.layers) do
		if layer.type == 'imagelayer' then
			self:_loadImage(layer.image)
		end
	end
end

function Map:_initTilesets()
	for _, tileset in ipairs(self.tilesets) do
		setmetatable(tileset, Tileset)
		tileset:_init(self)
	end
end

function Map:_initLayers()
	for _, layer in ipairs(self.layers) do
		setmetatable(layer, getLayerClassForType(layer.type))
		if layer._init then layer:_init(self) end
	end
	setmetatable(self.layers, LayerList)
end

-- Gets the tileset the tile with the specified global id belongs to.
function Map:_getTileset(gid)
	for i = #self.tilesets, 1, -1 do
		if gid >= self.tilesets[i].firstgid then
			return self.tilesets[i]
		end
	end
end

-- Gets the tile with the specified global id.
function Map:_getTile(gid)
	if gid == 0 then return nil end
	return self:_getTileset(gid):_getTile(gid)
end

-- Gets the type of the specified tile, if it exists.
function Map:getTileType(gid)
	local tile = self:_getTile(gid)
	return tile and tile.type
end

-- Gets the value of the specified property on the specified tile, if it exists.
function Map:getTileProperty(gid, propertyName)
	local tile = self:_getTile(gid)
	return tile and tile.properties and tile.properties[propertyName] or nil
end

-- Gets the properties table on the specified tile, if it exists
function Map:getTileProperties(gid)
	local tile = self:_getTile(gid)
	return tile and tile.properties and tile.properties or nil
end

--- Gets the tile position for the given world position. The value is not clamped to the map bounds.
function Map:worldToTilePos(x, y)
	return math.floor(x / self.tilewidth), math.floor(y / self.tileheight)
end

function Map:tileToWorldPos(x, y)
	return x * self.tilewidth, y * self.tileheight
end

function Map:update(dt)
	for _, layer in ipairs(self.layers) do
		if layer.update then layer:update(dt) end
	end
end

function Map:drawBackground()
	if self.backgroundcolor then
		local r = self.backgroundcolor[1] / 255
		local g = self.backgroundcolor[2] / 255
		local b = self.backgroundcolor[3] / 255
		love.graphics.setColor(r, g, b)
		love.graphics.rectangle('fill', 0, 0, self.width * self.tilewidth, self.height * self.tileheight)
		love.graphics.setColor(1, 1, 1)
	end
end

function Map:draw()
	self:drawBackground()
	for _, layer in ipairs(self.layers) do
		if layer.visible and layer.draw then layer:draw() end
	end
end


-- Loads a Tiled map from a lua file.
function mappy.load(path)
	if not path then error('No map path provided', 2) end
	local ok, chunk = pcall(love.filesystem.load, path)
	if not ok then
		error('Error loading map from path: ' .. tostring(chunk), 2)
	end
	if not chunk then
		error('Could not find path: ' .. path, 2)
	end

	local map = chunk()
	setmetatable(map, Map)
	map:_init(path)
	return map
end

return mappy
