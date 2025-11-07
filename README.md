# 🧾 Render API Documentation

---

### ⚙️ Functions

#### 🔤 `render.load_font(path: string, size?: number, flags?: number) -> font_data`
Loads and registers a font.

| Parameter | Type | Description |
|------------|------|-------------|
| `path` | `string` | Path to the font file |
| `size` | `number` *(optional)* | Font size in pixels (default `12`) |
| `flags` | `number` *(optional)* | Font flags (default `0`) |

📤 **Returns:** Loaded font.

---

#### 🖼️ `render.load_image(content: string) -> texture_data`
Loads an image from a file path or binary memory buffer.

| Parameter | Type | Description |
|------------|------|-------------|
| `content` | `string` | File path or binary image data |

📤 **Returns:** Loaded texture.

---

#### 🅰️ `render.get_text_size(font: string, text: string) -> vec2_t`
Returns the pixel size of the given text.

| Parameter | Type | Description |
|------------|------|-------------|
| `font` | `font_data` | Font returned by `render.load_font` |
| `text` | `string` | Text to measure |

📤 **Returns:** `vec2_t(width, height)`

---

#### 🖋️ `render.add_text(font: string, text: string, x: number, y: number, color: col_t)`
Draws text at the specified screen position.

| Parameter | Type | Description |
|------------|------|-------------|
| `font` | `string` | Font ID |
| `text` | `string` | Text content |
| `x` | `number` | X coordinate |
| `y` | `number` | Y coordinate |
| `color` | `col_t` | Text color |

---

#### 🟦 `render.add_rect_filled(x: number, y: number, w: number, h: number, color: col_t, rounding?: number, flags?: number)`
Draws a **filled rectangle**.

| Parameter | Type | Description |
|------------|------|-------------|
| `x` | `number` | Top-left X |
| `y` | `number` | Top-left Y |
| `w` | `number` | Width |
| `h` | `number` | Height |
| `color` | `col_t` | Fill color |
| `rounding` | `number` *(optional)* | Corner rounding radius |
| `flags` | `number` *(optional)* | Draw flags |

---

#### ⬛ `render.add_rect(x: number, y: number, w: number, h: number, color: col_t, thick?: number, rounding?: number, flags?: number)`
Draws a **rectangle outline**.

| Parameter | Type | Description |
|------------|------|-------------|
| `x` | `number` | Top-left X |
| `y` | `number` | Top-left Y |
| `w` | `number` | Width |
| `h` | `number` | Height |
| `color` | `col_t` | Outline color |
| `thick` | `number` *(optional)* | Line thickness (default `1`) |
| `rounding` | `number` *(optional)* | Corner rounding (default `0`) |
| `flags` | `number` *(optional)* | Draw flags |

---

#### 🌫️ `render.add_blur(x: number, y: number, w: number, h: number, color: col_t, radius?: number, rounding?: number, flags?: number)`
Applies a **blur effect** to a rectangular region.

| Parameter | Type | Description |
|------------|------|-------------|
| `x` | `number` | Top-left X |
| `y` | `number` | Top-left Y |
| `w` | `number` | Width |
| `h` | `number` | Height |
| `color` | `col_t` | Blur color/tint |
| `radius` | `number` *(optional)* | Blur radius |
| `rounding` | `number` *(optional)* | Corner rounding |
| `flags` | `number` *(optional)* | Draw flags |

---

#### 🧊 `render.add_rect_shadow(x: number, y: number, w: number, h: number, color: col_t, thick?: number, offset?: vec2_t, rounding?: number, flags?: number)`
Draws a **shadow** behind a rectangle.

| Parameter | Type | Description |
|------------|------|-------------|
| `x` | `number` | Top-left X |
| `y` | `number` | Top-left Y |
| `w` | `number` | Width |
| `h` | `number` | Height |
| `color` | `col_t` | Shadow color |
| `thick` | `number` *(optional)* | Blur strength |
| `offset` | `vec2_t` *(optional)* | Shadow offset (default `vec2_t(0, 0)`) |
| `rounding` | `number` *(optional)* | Corner rounding |
| `flags` | `number` *(optional)* | Draw flags |

---

#### 🧭 `render.add_line(x: number, y: number, x1: number, y1: number, color: col_t, thick?: number)`
Draws a **line** between two points.

| Parameter | Type | Description |
|------------|------|-------------|
| `x`, `y` | `number` | Start position |
| `x1`, `y1` | `number` | End position |
| `color` | `col_t` | Line color |
| `thick` | `number` *(optional)* | Line thickness |

---

#### 🌀 `render.add_circle(x: number, y: number, radius: number, segments: number, color: col_t, thick?: number)`
Draws a **circle outline**.

| Parameter | Type | Description |
|------------|------|-------------|
| `x` | `number` | Center X |
| `y` | `number` | Center Y |
| `radius` | `number` | Circle radius |
| `segments` | `number` | Number of segments for smoothness |
| `color` | `col_t` | Line color |
| `thick` | `number` *(optional)* | Line thickness |

---

#### ⚫ `render.add_circle_filled(x: number, y: number, radius: number, segments: number, color: col_t)`
Draws a **filled circle**.

| Parameter | Type | Description |
|------------|------|-------------|
| `x` | `number` | Center X |
| `y` | `number` | Center Y |
| `radius` | `number` | Circle radius |
| `segments` | `number` | Number of segments for smoothness |
| `color` | `col_t` | Fill color |

---

#### 🧮 `render.add_polyline(points: table<vec2_t>, color: col_t, thick?: number, flags?: number)`
Draws a **polyline** (connected line segments).

| Parameter | Type | Description |
|------------|------|-------------|
| `points` | `table<vec2_t>` | Array of connected points |
| `color` | `col_t` | Line color |
| `thick` | `number` *(optional)* | Line thickness |
| `flags` | `number` *(optional)* | Draw flags |

---

#### 🔺 `render.add_polyfilled(points: table<vec2_t>, color: col_t)`
Draws a **filled polygon**.

| Parameter | Type | Description |
|------------|------|-------------|
| `points` | `table<vec2_t>` | Array of polygon vertices |
| `color` | `col_t` | Fill color |

---

#### 🌑 `render.add_polyshadow(points: table<vec2_t>, color: col_t, thick?: number, offset?: vec2_t, flags?: number)`
Draws a **shadowed polygon**.

| Parameter | Type | Description |
|------------|------|-------------|
| `points` | `table<vec2_t>` | Polygon vertex list |
| `color` | `col_t` | Shadow color |
| `thick` | `number` *(optional)* | Blur amount |
| `offset` | `vec2_t` *(optional)* | Shadow offset vector |
| `flags` | `number` *(optional)* | Draw flags |

---

#### ✂️ `render.push_clip_rect(x: number, y: number, w: number, h: number, intersect?: boolean)`
Pushes a **clip rectangle** to limit the drawing area.

| Parameter | Type | Description |
|------------|------|-------------|
| `x` | `number` | Top-left X |
| `y` | `number` | Top-left Y |
| `w` | `number` | Width |
| `h` | `number` | Height |
| `intersect` | `boolean` *(optional)* | Whether to intersect with the previous clip rect (default `false`) |

---

#### ✂️ `render.pop_clip_rect()`
Removes the last pushed clipping rectangle.

| Parameter | Type | Description |
|------------|------|-------------|
| *(none)* | – | Pops the current clip rectangle |

---

#### 🔁 `render.set_callback(fn: function)`
Registers a function to be executed every frame.

| Parameter | Type | Description |
|------------|------|-------------|
| `fn` | `function` | Callback function to execute |

📘 Example:
```lua
render.set_callback(function()
    render.add_rect_filled(50, 50, 200, 100, render.col_t(0, 0.5, 1, 1), 5)
end)
```

---

Отлично — вот профессионально оформленная **документация для `vec2_t`**, в стиле API-описаний (на английском, Markdown формат, идеально подходит для проекта с LuaJIT + FFI).

---

# 🧾 Module: `vec2_t`

### 📘 Overview
`vec2_t` is a lightweight **2D vector type**.  
It represents a mathematical vector with `x` and `y` components and supports standard vector arithmetic and operations via metamethods.

This structure is often used for positions, sizes, directions, or UV coordinates in 2D rendering systems.

---
---

### ⚙️ Constructor

```lua
local v = vec2_t(x, y)
```

| Parameter | Type     | Default | Description  |
| --------- | -------- | ------- | ------------ |
| `x`       | `number` | `0`     | X coordinate |
| `y`       | `number` | `0`     | Y coordinate |

Example:

```lua
local a = vec2_t(10, 5)
local b = vec2_t() -- defaults to (0, 0)
```

---

### ➕ Arithmetic Operations

All arithmetic metamethods are overloaded to work with both **numbers** and **other `vec2_t` objects**.
They return a **new `vec2_t` instance** (immutable behavior).

#### `__add` — Vector Addition

```lua
a + b
a + 3
3 + a
```

* Adds either another `vec2_t` or a scalar number.

#### `__sub` — Vector Subtraction

```lua
a - b
a - 3
3 - a
```

* Subtracts either another `vec2_t` or a scalar.

#### `__mul` — Multiplication

```lua
a * b
a * 2
2 * a
```

* Multiplies components pairwise if both operands are vectors.
* Multiplies both components by a scalar if one operand is numeric.

#### `__div` — Division

```lua
a / b
a / 2
2 / a
```

* Divides component-wise if both are vectors.
* Divides by a scalar if one operand is numeric.

---

### 🧰 Methods

#### `vec2_t:unpack()`

```lua
local x, y = v:unpack()
```

Returns both vector components as separate values.

| Returns | Type     | Description |
| ------- | -------- | ----------- |
| `x`     | `number` | X component |
| `y`     | `number` | Y component |

---

#### `vec2_t:__tostring()`

```lua
tostring(v)
```

Converts the vector into a formatted string:

```
vec2_t(10.00, 5.00)
```

---

### 🧮 Examples

#### Basic arithmetic

```lua
local a = vec2_t(10, 20)
local b = vec2_t(5, 5)

local sum = a + b        -- vec2_t(15, 25)
local diff = a - 3       -- vec2_t(7, 17)
local scaled = 2 * a     -- vec2_t(20, 40)
local divided = a / b    -- vec2_t(2, 4)
```

#### Extracting values

```lua
local pos = vec2_t(128, 256)
local x, y = pos:unpack()
print(x, y) -- 128, 256
```

#### Printing

```lua
print(pos)  -- Output: vec2_t(128.00, 256.00)
```
---

## 🎨 Module: `col_t`

### 📘 Overview

`col_t` is a color structure representing RGBA color values.
Used by all render functions for coloring shapes and text.

---

### 🧱 Constructor

```lua
local c = render.col_t(r, g, b, a)
```

| Parameter | Type                  | Range   | Description         |
| --------- | --------------------- | ------- | ------------------- |
| `r`       | `number`              | 0.0–1.0 | Red                 |
| `g`       | `number`              | 0.0–1.0 | Green               |
| `b`       | `number`              | 0.0–1.0 | Blue                |
| `a`       | `number` *(optional)* | 0.0–1.0 | Alpha (default `1`) |

---

### 🧩 Methods

#### `c:unpack() -> number, number, number, number`

Returns `r, g, b, a`.

#### `tostring(c) -> string`

Stringifies the color:

```lua
col_t(1.00, 0.50, 0.00, 1.00)
```

---
# 🧾 Module: `draw_flags`

### 📘 Overview

You can combine multiple flags using bitwise OR (`bit.bor`).

---

### ⚙️ Flags Reference

| Constant | Description |
|-----------|--------------|
| `draw_flags.none` | Default, no special behavior. |
| `draw_flags.closed` | Indicates that a shape or line should be **closed** (the last point connects to the first). Used with `add_polyline()`. |
| `draw_flags.round_corners_top_left` | Round **top-left** corner only (if rounding > 0). |
| `draw_flags.round_corners_top_right` | Round **top-right** corner only (if rounding > 0). |
| `draw_flags.round_corners_bottom_left` | Round **bottom-left** corner only (if rounding > 0). |
| `draw_flags.round_corners_bottom_right` | Round **bottom-right** corner only (if rounding > 0). |
| `draw_flags.round_corners_none` | Disable rounding on all corners, even if `rounding > 0`. |
| `draw_flags.round_corners_top` | Round **top-left** and **top-right** corners. Equivalent to `top_left | top_right`. |
| `draw_flags.round_corners_bottom` | Round **bottom-left** and **bottom-right** corners. |
| `draw_flags.round_corners_left` | Round **top-left** and **bottom-left** corners. |
| `draw_flags.round_corners_right` | Round **top-right** and **bottom-right** corners. |
| `draw_flags.round_corners_all` | Round **all four corners**. This is the **default** rounding behavior. |
| `draw_flags.round_corners_default` | Alias for `draw_flags.round_corners_all`. |
| `draw_flags.round_corners_mask` | Bit mask combining all corner-related flags (useful for validation). |
| `draw_flags.shadow_cut_out_shape_background` | Do not render the shadow shape behind the original geometry — improves blending or saves fill-rate. Used with `add_rect_shadow()` and `add_polyshadow()`. |

---

### 💡 Usage Examples

#### ✅ Combine flags
```lua
local flags = bit.bor(
    draw_flags.round_corners_top,
    draw_flags.shadow_cut_out_shape_background
)
```

---
# 🧾 Module: `font_flags`

### 📘 Overview

Each flag corresponds to a bitmask value and can be combined using `bit.bor()`.

---

### ⚙️ Flags Reference

| Constant | Description |
|-----------|--------------|
| `font_flags.no_hinting` | **Disables hinting.** Glyphs are rendered without aligning to the pixel grid, resulting in slightly blurrier text when anti-aliased. |
| `font_flags.no_auto_hint` | **Disables FreeType’s auto-hinter.** Uses the font’s native hinter only. |
| `font_flags.force_auto_hint` | **Forces the use of the auto-hinter** even if the font provides its own hinting instructions. |
| `font_flags.light_hinting` | **Light hinting algorithm.** Snaps glyphs to the pixel grid only vertically (Y-axis). Produces smoother shapes and preserves spacing, similar to Microsoft ClearType or Adobe rendering. |
| `font_flags.mono_hinting` | **Strong monochrome hinting.** Designed for pixel-perfect alignment in non-anti-aliased (monochrome) output. |
| `font_flags.bold` | **Applies artificial emboldening** (thickens glyph strokes). Useful for styles without a dedicated bold font. |
| `font_flags.oblique` | **Applies a slant** to the font to emulate an italic style (shearing transformation). |
| `font_flags.monochrome` | **Disables anti-aliasing.** Produces crisp, single-color glyphs. Often combined with `mono_hinting` for best results. |
| `font_flags.load_color` | **Enables color-layered glyphs** (such as emoji or colored icons) when supported by the font. |
| `font_flags.bitmap` | **Enables bitmap glyph loading.** Useful for fonts that include pre-rendered bitmap characters. |

---

### 💡 Usage Examples

#### ✅ Combine multiple flags
```lua
local flags = bit.bor(
    font_flags.no_hinting,
    font_flags.bold,
    font_flags.load_color
)
```

---

## 💡 Example Usage

```lua
local render = require( 'render' )

local col_t = render.col_t
local vec2_t = render.vec2_t

local bytes = "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x10\x00\x00\x00\x10\x08\x06\x00\x00\x00\x1F\xF3\xFF\x61\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x73\x42\x49\x54\x08\x08\x08\x08\x7C\x08\x64\x88\x00\x00\x00\xB7\x49\x44\x41\x54\x38\x8D\xA5\x93\xD1\x11\x82\x40\x0C\x44\x5F\xAC\x80\x12\x28\x81\x0E\xB4\x04\x4B\xC0\xCA\xB8\x12\xEC\xC0\xA1\x02\xCE\x0A\xBC\x16\xAC\x60\xFD\xF0\x98\x41\x08\x07\x23\xFB\x99\xDB\xDD\x24\x97\x04\x0E\xC2\xBC\xA0\xA4\x06\x38\x03\x4D\x0E\x45\xA0\x37\xB3\x58\x74\x93\x54\x49\xEA\xB4\x8E\x4E\x52\x55\x12\x0F\x05\xF1\x88\xC1\x35\x91\x14\x76\x88\x47\x84\x45\xCF\x0E\x29\x6D\x98\xD6\x00\xA7\xEC\x71\x71\xBA\x4A\x66\xD6\x02\x37\xE0\xED\xBC\x5F\xA7\x06\x8D\x43\x00\xC0\xCC\x42\x4E\xF0\x9C\x3D\xFD\x54\xB0\x07\xF2\x82\xA3\xC1\xEA\x7C\x25\xB5\xC0\x83\x65\x95\x69\x4A\xF2\x3E\xF1\xA5\xF2\x4E\xD4\xF3\x4C\xFF\x8F\x31\x1B\x54\x92\xE2\x0E\x71\xD4\xC6\x36\x96\x2A\x09\x73\xF1\xDA\x31\xD5\x7C\xE7\x3C\x3D\xA6\xBB\x99\x25\x8F\x7F\x08\x1F\xB1\xA8\x87\x34\xB5\x43\x0E\xB3\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82"
local image_bytes = render.load_image( bytes )
local image_file = render.load_image( 'D:/Steam/steamapps/common/Counter-Strike Global Offensive/img.jpg' )

local font = render.load_font( 'C:/Windows/Fonts/Verdana.ttf', 40 )

render.set_callback( function( )
    local size = render.get_text_size( font, 'morion.pw' )

    render.add_image( image_bytes, 100, 100, 20, 20, col_t( 1, 1, 1, 1 ) )
    render.push_clip_rect( 400, 100, 200, 200 )
    render.add_image( image_file, 400, 100, 736 / 2, 693 / 2, col_t( 1, 1, 1, 1 ), 30 )
    render.pop_clip_rect( )

    render.add_blur( 477, 180, size.x + 10, size.y + 10, col_t( 1, 1, 1, 1 ), 4, 10 )
    render.add_rect_shadow( 100, 100, 736 / 2, 693 / 2, col_t( 0, 0, 0, 1 ) )
    render.add_rect_filled( 175, 185, size.x + 10, size.y + 10, col_t( 1, 1, 1, 1 ), 10 )
    render.add_rect( 477, 180, size.x + 10, size.y + 10, col_t( 1, 1, 1, 1 ), 3, 10 )
    render.add_text( font, 'morion.pw', 482, 181, col_t( 1, 1, 1, 1 ) )

    local polygons = { vec2_t( 125, 100 ), vec2_t( 162, 150 ), vec2_t( 200, 100 ) }
    render.add_line( polygons[1].x, polygons[1].y, polygons[2].x, polygons[2].y, col_t( 1, 1, 1, 1 ) )

    render.add_polyshadow( polygons, col_t( 0, 0, 0, 1 ) )
    render.add_polyfilled( polygons, col_t( 1, 0, 0, 1 ) )
    render.add_polyline( polygons, col_t( 1, 1, 1, 1 ), 3, bit.lshift( 1, 0 ) )

    render.add_circle_filled( 200, 200, 30, 25, col_t( 1, 0, 0, 1 ) )
    render.add_circle( 200, 200, 30, 25, col_t( 1, 1, 1, 1 ), 3 )
    render.add_circle_shadow( 200, 200, 30, 25, col_t( 1, 1, 1, 1 ) )
end )
```
