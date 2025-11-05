```
# 🧾 Render API Documentation

---

### ⚙️ Functions

#### 🔤 `render.load_font(path: string, size?: number, flags?: number) -> font_data`
Loads and registers a font.

| Parameter | Type | Description |
|------------|------|-------------|
| `path` | `string` | Path to the font file |
| `size` | `number` *(optional)* | Font size (default `12`) |
| `flags` | `number` *(optional)* | ImGui font flags (default `0`) |

📤 **Returns:** Created font.

---

#### 🖼️ `render.load_image(content: string) -> texture_data`
Loads an image from either a file path or binary memory data.

| Parameter | Type | Description |
|------------|------|-------------|
| `content` | `string` | Path to image file or binary content |

📤 **Returns:** Created texture.

---

#### 🅰️ `render.get_text_size(font: string, text: string) -> vec2_t`
Returns the pixel size of a given text.

| Parameter | Type | Description |
|------------|------|-------------|
| `font` | `string` | Font ID returned by `render.load_font` |
| `text` | `string` | Text to measure |

📤 **Returns:** `vec2_t(width, height)`

---

#### 🖋️ `render.add_text(font: string, text: string, x: number, y: number, color: col_t)`
Draws text.

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
| `w` | `number` | Bottom-right X |
| `h` | `number` | Bottom-right Y |
| `color` | `col_t` | Fill color |
| `rounding` | `number` *(optional)* | Corner rounding radius |
| `flags` | `number` *(optional)* | ImGui draw flags |

---

#### ⬛ `render.add_rect(x: number, y: number, w: number, h: number, color: col_t, thick?: number, rounding?: number, flags?: number)`
Draws a **rectangle outline**.

| Parameter | Type | Description |
|------------|------|-------------|
| `x` | `number` | Top-left X |
| `y` | `number` | Top-left Y |
| `w` | `number` | Bottom-right X |
| `h` | `number` | Bottom-right Y |
| `color` | `col_t` | Outline color |
| `thick` | `number` *(optional)* | Line thickness (default `1`) |
| `rounding` | `number` *(optional)* | Corner rounding (default `0`) |
| `flags` | `number` *(optional)* | Draw flags |

---

#### 🌫️ `render.add_blur(x: number, y: number, w: number, h: number, color: col_t, radius?: number, rounding?: number, flags?: number)`
Applies a **blur effect** to a rectangular region.

| Parameter | Type | Description |
|------------|------|-------------|
| `x`, `y`, `w`, `h` | `number` | Region coordinates |
| `color` | `col_t` | Blur tint/intensity |
| `radius` | `number` *(optional)* | Blur radius |
| `rounding` | `number` *(optional)* | Corner rounding |
| `flags` | `number` *(optional)* | Draw flags |

---

#### 🧊 `render.add_rect_shadow(x: number, y: number, w: number, h: number, color: col_t, thick?: number, offset?: vec2_t, rounding?: number, flags?: number)`
Draws a **shadow** behind a rectangle.

| Parameter | Type | Description |
|------------|------|-------------|
| `x`, `y`, `w`, `h` | `number` | Rectangle coordinates |
| `color` | `col_t` | Shadow color |
| `thick` | `number` *(optional)* | Blur amount |
| `offset` | `vec2_t` *(optional)* | Shadow offset |
| `rounding` | `number` *(optional)* | Corner rounding |
| `flags` | `number` *(optional)* | Draw flags |

---

#### 🧭 `render.add_line(x: number, y: number, x1: number, y1: number, color: col_t, thick?: number)`
Draws a line between two points.

| Parameter | Type | Description |
|------------|------|-------------|
| `x`, `y` | `number` | Start position |
| `x1`, `y1` | `number` | End position |
| `color` | `col_t` | Line color |
| `thick` | `number` *(optional)* | Line thickness |

---

#### 🌀 `render.add_circle(x: number, y: number, radius: number, segments: number, color: col_t, thick?: number)`
Draws a **circle outline**.

---

#### ⚫ `render.add_circle_filled(x: number, y: number, radius: number, segments: number, color: col_t)`
Draws a **filled circle**.

---

#### 🧮 `render.add_polyline(points: table<vec2_t>, color: col_t, thick?: number, flags?: number)`
Draws a **polyline** (connected line segments).

| Parameter | Type | Description |
|------------|------|-------------|
| `points` | `table<vec2_t>` | Array of points |
| `color` | `col_t` | Line color |
| `thick` | `number` *(optional)* | Thickness |
| `flags` | `number` *(optional)* | Draw flags |

---

#### 🔺 `render.add_polyfilled(points: table<vec2_t>, color: col_t)`
Draws a **filled polygon**.

---

#### 🌑 `render.add_polyshadow(points: table<vec2_t>, color: col_t, thick?: number, offset?: vec2_t, flags?: number)`
Draws a **shadowed polygon**.

---

#### ✂️ `render.push_clip_rect(x: number, y: number, w: number, h: number, intersect?: boolean)`
Pushes a **clip rectangle** to limit drawing area.

---

#### ✂️ `render.pop_clip_rect()`
Pops the last clip rectangle from the stack.

---

#### 🔁 `render.set_callback(fn: function)`
Registers a function that will be executed every frame during the `paint_ui` event.

```lua
render.set_callback(function()
    render.add_rect_filled(50, 50, 200, 100, render.col_t(0, 0.5, 1, 1), 5)
end)
```

---

## 📐 Module: `vec2_t`

### 📘 Overview

`vec2_t` is a simple 2D vector structure used for positions, sizes, and offsets.

---

### 🧱 Constructor

```lua
local v = render.vec2_t(x, y)
```

| Parameter | Type     | Description  |
| --------- | -------- | ------------ |
| `x`       | `number` | X coordinate |
| `y`       | `number` | Y coordinate |

---

### ⚙️ Operators

| Operator | Description            | Example        |
| -------- | ---------------------- | -------------- |
| `+`      | Adds two vectors       | `v3 = v1 + v2` |
| `-`      | Subtracts two vectors  | `v3 = v1 - v2` |
| `*`      | Multiplies by a scalar | `v2 = v1 * 2`  |

---

### 🧩 Methods

#### `v:unpack() -> number, number`

Returns `x, y`.

#### `tostring(v) -> string`

Stringifies the vector:

```lua
vec2_t(10.00, 5.00)
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

## 💡 Example Usage

```lua
local render = require('render')

-- Create vector and color
local pos = render.vec2_t(100, 200)
local color = render.col_t(0.2, 0.8, 1.0, 1.0)

-- Load a font
local font = render.load_font('C:\\Windows\\Fonts\\Arial.ttf', 16)

-- Draw using render callback
render.set_callback(function()
    render.add_rect(pos.x, pos.y, pos.x + 120, pos.y + 40, color, 2, 6)
    render.add_text(font, "Hello World", pos.x + 10, pos.y + 12, render.col_t(1, 1, 1, 1))
end)
```
