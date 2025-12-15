# 🎨 render
---

## ⚠️ Important

All drawing must be performed **only** inside the `render` callback.

```lua
client.set_event_callback("render", function()
    -- all rendering here
end)
```

---

## 📚 Table of contents

- [🧩 Types](#-types)
  - [vec2_t](#vec2_t)
  - [col_t](#col_t)
  - [font_data_t](#font_data_t)
  - [texture_data_t](#texture_data_t)
- [🏷️ Flags](#️-flags)
  - [draw_flags](#draw_flags)
  - [font_flags](#font_flags)
- [🖼️ Textures](#️-textures)
  - [load_texture_file](#load_texture_file)
  - [load_texture_memory](#load_texture_memory)
  - [load_texture_svg](#load_texture_svg)
  - [texture](#texture)
- [🔤 Fonts & Text](#-fonts--text)
  - [load_font](#load_font)
  - [measure_text](#measure_text)
  - [text](#text)
- [🟦 Primitives](#-primitives)
  - [rect](#rect)
  - [rect_outline](#rect_outline)
  - [rect_shadow](#rect_shadow)
  - [gradient](#gradient)
  - [circle](#circle)
  - [circle_outline](#circle_outline)
  - [circle_shadow](#circle_shadow)
  - [circle_gradient](#circle_gradient)
  - [poly](#poly)
  - [poly_line](#poly_line)
  - [poly_shadow](#poly_shadow)
- [🧼 Mask](#-mask)
  - [push_mask](#push_mask)
  - [begin_mask_content](#begin_mask_content)
  - [pop_mask](#pop_mask)
- [🌫️ Blur](#️-blur)
  - [push_blur](#push_blur)
  - [pop_blur](#pop_blur)
  - [rect_blur](#rect_blur)
- [📐 Geometry](#-geometry)
  - [rounded_points](#rounded_points)

---

## 🧩 Types

---

## vec2_t

### 📌 Description

`vec2_t` represents a 2D vector with `x` and `y` components. It is used for positions, sizes, offsets and geometry math.

---

### 🧱 Constructors

```lua
vec2_t()
vec2_t(x: number, y: number)
```

| Parameter | Type | Default | Description |
|---|---|---:|---|
| `x` | `number` | `0` | X component |
| `y` | `number` | `0` | Y component |

---

### 🔎 Properties

| Name | Type | Description |
|---|---|---|
| `x` | `number` | X component |
| `y` | `number` | Y component |

---

### 🛠️ Methods

#### clone
```lua
vec2_t:clone() -> vec2_t
```
Returns a copy of the vector.

---

#### unpack
```lua
vec2_t:unpack() -> number, number
```
Returns `x, y`.

---

#### floor
```lua
vec2_t:floor() -> vec2_t
```
Floors both components.

---

#### length2d
```lua
vec2_t:length2d() -> number
```
Returns the vector length.

---

#### length2d_sqr
```lua
vec2_t:length2d_sqr() -> number
```
Returns squared length.

---

#### normalize
```lua
vec2_t:normalize() -> vec2_t
```
Returns a normalized copy (if length > 0).

---

#### dot
```lua
vec2_t:dot(other: vec2_t) -> number
```

| Parameter | Type | Description |
|---|---|---|
| `other` | `vec2_t` | Other vector |

Returns dot product.

---

#### cross
```lua
vec2_t:cross(other: vec2_t) -> number
```

| Parameter | Type | Description |
|---|---|---|
| `other` | `vec2_t` | Other vector |

Returns 2D cross product (scalar).

---

#### distance
```lua
vec2_t:distance(other: vec2_t) -> number
```

| Parameter | Type | Description |
|---|---|---|
| `other` | `vec2_t` | Other vector |

Returns distance to `other`.

---

#### distance_sqr
```lua
vec2_t:distance_sqr(other: vec2_t) -> number
```

| Parameter | Type | Description |
|---|---|---|
| `other` | `vec2_t` | Other vector |

Returns squared distance.

---

#### perp
```lua
vec2_t:perp() -> vec2_t
```
Returns a perpendicular vector `(-y, x)`.

---

#### is_zero
```lua
vec2_t:is_zero(epsilon?: number) -> boolean
```

| Parameter | Type | Default | Description |
|---|---|---:|---|
| `epsilon` | `number` | implementation-defined | Allowed tolerance |

Returns `true` if vector is close to zero.

---

## col_t

### 🎨 Description

`col_t` represents an RGBA color.

- Components are stored as floats.
- Expected range: **0.0 – 1.0**.
- If you use **0–255** inputs, call `fraction()` to convert into **0.0–1.0**.

---

### 🧱 Constructors

```lua
col_t(r: number, g: number, b: number, a?: number)
col_t(hex: string)
```

✅ HEX formats:
- `RRGGBB`
- `RRGGBBAA`

---

### 🔎 Properties

| Name | Type | Description |
|---|---|---|
| `r` | `number` | Red |
| `g` | `number` | Green |
| `b` | `number` | Blue |
| `a` | `number` | Alpha |

---

### 🛠️ Methods

#### clone
```lua
col_t:clone() -> col_t
```
Returns a copy of the color.

---

#### unpack
```lua
col_t:unpack() -> number, number, number, number
```
Returns `r, g, b, a`.

---

#### brightness
```lua
col_t:brightness() -> number
```
Returns `max(r, g, b)`.

---

#### fraction
```lua
col_t:fraction() -> col_t
```
Converts channels from **0–255** to **0–1**.

✅ Example:
```lua
local c = render.col_t(255, 120, 130, 40):fraction()
-- r = 1.0000
-- g = 0.4706
-- b = 0.5098
-- a = 0.1569
```

---

#### alpha
```lua
col_t:alpha(multiplier: number) -> col_t
```

| Parameter | Type | Description |
|---|---|---|
| `multiplier` | `number` | Alpha multiplier |

Returns a copy with `a = a * multiplier`.

---

#### hex
```lua
col_t:hex() -> string
```
Returns the color as `RRGGBBAA`.

---

#### lerp
```lua
col_t:lerp(other: col_t, t: number) -> col_t
```

| Parameter | Type | Description |
|---|---|---|
| `other` | `col_t` | Target color |
| `t` | `number` | Weight (0..1) |

Returns linearly interpolated color.

---

## font_data_t

### 🔤 Description

`font_data_t` represents a loaded font handle returned by `render.load_font`.  
Use it only with `render.text` and `render.measure_text`.

### 🛠️ Methods

#### get_size
```lua
font_data_t:get_size() -> number
```
Returns font size.

---

#### get_data
```lua
font_data_t:get_data() -> pointer
```
Returns font handle.

---

## texture_data_t

### 🖼️ Description

`texture_data_t` represents a loaded texture handle returned by texture loaders.

### 🔎 Properties (texture_data_t)

| Name | Type | Description |
|---|---|---|
| `width` | `number` | Texture width |
| `height` | `number` | Texture height |
| `texture` | `pointer` | Texture handle |

---

## 🏷️ Flags

---

## draw_flags

Used in primitives and `render.texture`.

| Flag | Description |
|---|---|
| `none` | No flags |
| `closed` | Close polyline (`poly_line`) |
| `round_corners_top_left` | Round top-left corner |
| `round_corners_top_right` | Round top-right corner |
| `round_corners_bottom_left` | Round bottom-left corner |
| `round_corners_bottom_right` | Round bottom-right corner |
| `round_corners_top` | Round top corners |
| `round_corners_bottom` | Round bottom corners |
| `round_corners_left` | Round left corners |
| `round_corners_right` | Round right corners |
| `round_corners_all` | Round all corners |
| `round_corners_default` | Alias for `round_corners_all` |
| `round_corners_none` | Disable rounding |
| `round_corners_mask` | Corner mask |
| `shadow_cut_out_shape_background` | Shadow cut-out mode |

---

## font_flags

Used in `render.load_font`.

| Flag | Description |
|---|---|
| `no_hinting` | Disable hinting |
| `no_auto_hint` | Disable auto-hint |
| `force_auto_hint` | Force auto-hint |
| `light_hinting` | Light hinting |
| `mono_hinting` | Monochrome hinting |
| `bold` | Bold |
| `oblique` | Italic / oblique |
| `monochrome` | Monochrome glyphs |
| `load_color` | Load colored glyphs |
| `bitmap` | Bitmap glyphs |

---

## 🖼️ Textures

---

### load_texture_file

```lua
render.load_texture_file(path: string) -> texture_data_t
```

Loads a texture from a file path.

| Argument | Type | Description |
|---|---|---|
| `path` | `string` | Path to an image file |

**Returns:** `texture_data_t`

---

### load_texture_memory

```lua
render.load_texture_memory(data: string) -> texture_data_t
```

Loads a texture from memory.

| Argument | Type | Description |
|---|---|---|
| `data` | `string` | Raw file bytes (binary string) |

**Returns:** `texture_data_t`

---

### load_texture_svg

```lua
render.load_texture_svg(path_or_svg: string, scale?: number) -> texture_data_t
```

Loads an SVG from file or string (depending on DLL implementation).

| Argument | Type | Default | Description |
|---|---|---:|---|
| `path_or_svg` | `string` | — | File path or SVG content |
| `scale` | `number` | `1` | Scale multiplier |

**Returns:** `texture_data_t`

---

### texture

```lua
render.texture(tex: texture_data_t, pos: vec2_t, size: vec2_t, color: col_t, rounding?: number, flags?: number)
```

Draws a texture.

| Argument | Type | Default | Description |
|---|---|---:|---|
| `tex` | `texture_data_t` | — | Texture handle |
| `pos` | `vec2_t` | — | Top-left position |
| `size` | `vec2_t` | — | Render size |
| `color` | `col_t` | — | Tint / alpha |
| `rounding` | `number` | `0` | Corner rounding |
| `flags` | `number` | `0` | `draw_flags` |

---

## 🔤 Fonts & Text

---

### load_font

```lua
render.load_font(path: string, size?: number, flags?: number) -> font_data_t
```

Loads a font.

| Argument | Type | Default | Description |
|---|---|---:|---|
| `path` | `string` | — | Font path or system font name |
| `size` | `number` | `12` | Font size |
| `flags` | `number` | `0` | `font_flags` |

**Returns:** `font_data_t`

---

### measure_text

```lua
render.measure_text(font: font_data_t, text: string) -> vec2_t
```

Measures text size.

| Argument | Type | Description |
|---|---|---|
| `font` | `font_data_t` | Font handle |
| `text` | `string` | Text |

**Returns:** `vec2_t(width, height)`

---

### text

```lua
render.text(font: font_data_t, pos: vec2_t, color: col_t, flags: string, text: string)
```

Draws text.

| Argument | Type | Description |
|---|---|---|
| `font` | `font_data_t` | Font handle |
| `pos` | `vec2_t` | Position |
| `color` | `col_t` | Default color |
| `flags` | `string` | Text flags string |
| `text` | `string` | Text |

#### 🧷 Text flags

| Flag | Meaning |
|---|---|
| `o` | Outline |
| `s` | Shadow |
| `c` | Center |

#### 🎛 Inline color codes (inside text)

- `\aDEFAULT` — reset to default color
- `\aRRGGBB` — apply RGB (uses default alpha)
- `\aRRGGBBAA` — apply RGBA
- `\r` — reset segment

---

## 🟦 Primitives

Each primitive below has a full signature and argument description.

---

### rect

```lua
render.rect(pos: vec2_t, size: vec2_t, color: col_t, rounding?: number, flags?: number)
```

Draws a filled rectangle.

| Argument | Type | Default | Description |
|---|---|---:|---|
| `pos` | `vec2_t` | — | Top-left position |
| `size` | `vec2_t` | — | Size (width/height) |
| `color` | `col_t` | — | Fill color |
| `rounding` | `number` | `0` | Corner rounding |
| `flags` | `number` | `0` | `draw_flags` |

---

### rect_outline

```lua
render.rect_outline(pos: vec2_t, size: vec2_t, color: col_t, thickness?: number, rounding?: number, flags?: number)
```

Draws a rectangle outline.

| Argument | Type | Default | Description |
|---|---|---:|---|
| `pos` | `vec2_t` | — | Top-left position |
| `size` | `vec2_t` | — | Size (width/height) |
| `color` | `col_t` | — | Outline color |
| `thickness` | `number` | `1` | Line thickness |
| `rounding` | `number` | `0` | Corner rounding |
| `flags` | `number` | `0` | `draw_flags` |

---

### rect_shadow

```lua
render.rect_shadow(pos: vec2_t, size: vec2_t, color: col_t, thickness?: number, offset?: vec2_t, rounding?: number, flags?: number)
```

Draws a rectangle shadow.

| Argument | Type | Default | Description |
|---|---|---:|---|
| `pos` | `vec2_t` | — | Top-left position |
| `size` | `vec2_t` | — | Size (width/height) |
| `color` | `col_t` | — | Shadow color |
| `thickness` | `number` | `10` | Shadow thickness |
| `offset` | `vec2_t` | `vec2_t(0,0)` | Shadow offset |
| `rounding` | `number` | `0` | Corner rounding |
| `flags` | `number` | `0` | `draw_flags` |

---

### gradient

```lua
render.gradient(pos: vec2_t, size: vec2_t, top_left: col_t, top_right: col_t, bottom_left: col_t, bottom_right: col_t, rounding?: number, flags?: number)
```

Draws a 4-corner gradient rectangle.

| Argument | Type | Default | Description |
|---|---|---:|---|
| `pos` | `vec2_t` | — | Top-left position |
| `size` | `vec2_t` | — | Size (width/height) |
| `top_left` | `col_t` | — | TL color |
| `top_right` | `col_t` | — | TR color |
| `bottom_left` | `col_t` | — | BL color |
| `bottom_right` | `col_t` | — | BR color |
| `rounding` | `number` | `0` | Corner rounding |
| `flags` | `number` | `0` | `draw_flags` |

---

### circle

```lua
render.circle(pos: vec2_t, color: col_t, radius: number, segments?: number)
```

Draws a filled circle.

| Argument | Type | Default | Description |
|---|---|---:|---|
| `pos` | `vec2_t` | — | Center position |
| `color` | `col_t` | — | Fill color |
| `radius` | `number` | — | Radius |
| `segments` | `number` | `0` | 0 = auto |

---

### circle_outline

```lua
render.circle_outline(pos: vec2_t, color: col_t, radius: number, thickness?: number, segments?: number)
```

Draws a circle outline.

| Argument | Type | Default | Description |
|---|---|---:|---|
| `pos` | `vec2_t` | — | Center position |
| `color` | `col_t` | — | Line color |
| `radius` | `number` | — | Radius |
| `thickness` | `number` | `1` | Line thickness |
| `segments` | `number` | `0` | 0 = auto |

---

### circle_shadow

```lua
render.circle_shadow(pos: vec2_t, color: col_t, radius: number, thickness?: number, offset?: vec2_t, flags?: number, segments?: number)
```

Draws a circle shadow.

| Argument | Type | Default | Description |
|---|---|---:|---|
| `pos` | `vec2_t` | — | Center position |
| `color` | `col_t` | — | Shadow color |
| `radius` | `number` | — | Radius |
| `thickness` | `number` | `10` | Shadow thickness |
| `offset` | `vec2_t` | `vec2_t(0,0)` | Shadow offset |
| `flags` | `number` | `0` | `draw_flags` |
| `segments` | `number` | `0` | 0 = auto |

---

### circle_gradient

```lua
render.circle_gradient(pos: vec2_t, color_in: col_t, color_out: col_t, radius: number)
```

Draws a radial gradient circle.

| Argument | Type | Description |
|---|---|---|
| `pos` | `vec2_t` | Center position |
| `color_in` | `col_t` | Inner color |
| `color_out` | `col_t` | Outer color |
| `radius` | `number` | Radius |

---

### poly

```lua
render.poly(points: vec2_t[], color: col_t)
```

Draws a filled polygon.

| Argument | Type | Description |
|---|---|---|
| `points` | `vec2_t[]` | Points array (>= 3) |
| `color` | `col_t` | Fill color |

---

### poly_line

```lua
render.poly_line(points: vec2_t[], color: col_t, thickness?: number, flags?: number)
```

Draws a polyline (use `draw_flags.closed` to close the shape).

| Argument | Type | Default | Description |
|---|---|---:|---|
| `points` | `vec2_t[]` | — | Points array |
| `color` | `col_t` | — | Line color |
| `thickness` | `number` | `1` | Line thickness |
| `flags` | `number` | `0` | `draw_flags` |

---

### poly_shadow

```lua
render.poly_shadow(points: vec2_t[], color: col_t, thickness?: number, offset?: vec2_t, flags?: number)
```

Draws a polygon/polyline shadow.

| Argument | Type | Default | Description |
|---|---|---:|---|
| `points` | `vec2_t[]` | — | Points array |
| `color` | `col_t` | — | Shadow color |
| `thickness` | `number` | `10` | Shadow thickness |
| `offset` | `vec2_t` | `vec2_t(0,0)` | Shadow offset |
| `flags` | `number` | `0` | `draw_flags` |

---

## 🧼 Mask

### 📌 Description

Mask restricts drawing to a custom shape. The mask shape can be created using primitives and textures/text.

---

### push_mask

```lua
render.push_mask(inverted?: boolean, alpha?: number)
```

Starts recording the mask shape.

| Argument | Type | Default | Description |
|---|---|---:|---|
| `inverted` | `boolean` | `false` | Invert mask region |
| `alpha` | `number` | `1` | Mask alpha multiplier |

---

### begin_mask_content

```lua
render.begin_mask_content()
```

Switches to drawing content **inside** the mask.

| Argument | Type | Description |
|---|---|---|
| — | — | No arguments |

---

### pop_mask

```lua
render.pop_mask()
```

Closes the current mask.


#### ✅ Example (mask + texture)

```lua
render.push_mask(false, 1)
    render.circle(vec2_t(300, 300), col_t(), 80)

render.begin_mask_content()

render.texture(tex, vec2_t(220, 220), vec2_t(160, 160), col_t())

render.pop_mask()
```

---

## 🌫️ Blur

### 📌 Description

Blur is applied to the **bounding box** of the geometry drawn between `push_blur` and `pop_blur`.

> ✅ To blur an exact shape (circle/rounded shape), clip the blurred result using **mask**.

---

### push_blur

```lua
render.push_blur(color: col_t)
```

Starts a blur pass.

| Argument | Type | Description |
|---|---|---|
| `color` | `col_t` | Blur tint / alpha |

---

### pop_blur

```lua
render.pop_blur()
```

Ends the blur pass.

---

### rect_blur

```lua
render.rect_blur(pos: vec2_t, size: vec2_t, color: col_t, rounding?: number, flags?: number)
```

Convenience helper for a blurred rectangle area.

| Argument | Type | Default | Description |
|---|---|---:|---|
| `pos` | `vec2_t` | — | Top-left position |
| `size` | `vec2_t` | — | Size |
| `color` | `col_t` | — | Blur tint / alpha |
| `rounding` | `number` | `0` | Corner rounding |
| `flags` | `number` | `0` | `draw_flags` |

#### ✅ Correct usage order (bounding box)

```lua
render.push_blur(col_t())
    render.rect(vec2_t(100, 100), vec2_t(250, 120), col_t())
render.pop_blur()
```

#### ✅ Blur clipped by mask (shape-accurate)

```lua
render.push_mask(false, 1)
    render.circle(vec2_t(300, 300), col_t(), 90)

render.begin_mask_content()

render.push_blur(col_t())
    render.rect(vec2_t(210, 210), vec2_t(180, 180), col_t())
render.pop_blur()

render.pop_mask()
```

---

## 📐 Geometry

---

### rounded_points

```lua
render.rounded_points(points: vec2_t[], r: number, arc_segments?: number) -> vec2_t[]
```

Generates a new list of points with rounded corners.

| Argument | Type | Default | Description |
|---|---|---:|---|
| `points` | `vec2_t[]` | — | Input polygon points (>= 3) |
| `r` | `number` | — | Rounding radius |
| `arc_segments` | `number` | `8` | Segments per arc (>= 3 recommended) |

**Returns:** `vec2_t[]`
