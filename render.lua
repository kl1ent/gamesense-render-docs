--@region libs
local ffi = require( 'ffi' )
--@endregion

--@region utils
local utils = ( function( )
    local function print_ptr( ptr )
        print( ffi.cast( 'int64_t', ptr ) )
    end

    return {
        print_ptr = print_ptr
    }
end )( )
--@endregion

--@region libapi
local libapi = ( function( )
    local jmp_ecx = client.find_signature('engine.dll', '\xFF\xE1')

    local get_module_handle_ptr = ffi.cast( 'uint32_t**', ffi.cast( 'uint32_t', client.find_signature( 'engine.dll', '\xFF\x15\xCC\xCC\xCC\xCC\x85\xC0\x74\x0B' ) ) + 2 )[0][0]
    local get_module_handle_fn = ffi.cast( 'uint32_t( __fastcall* )( unsigned int, unsigned int, const char* )', jmp_ecx )

    local get_proc_address_ptr = ffi.cast( 'uint32_t**', ffi.cast( 'uint32_t', client.find_signature( 'engine.dll', '\xFF\x15\xCC\xCC\xCC\xCC\xA3\xCC\xCC\xCC\xCC\xEB\x05' ) ) + 2 )[0][0]
    local get_proc_address_fn = ffi.cast( 'uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)', jmp_ecx )

    local function get_module_handle( name )
        return get_module_handle_fn( get_module_handle_ptr, 0, name )
    end

    local function get_proc_address( module, name )
        return get_proc_address_fn( get_proc_address_ptr, 0, module, name )
    end

    local function get_function( module, func_name, typestring )
        local c_type = ffi.typeof( typestring )

        return function( ... ) 
            return ffi.cast( c_type, jmp_ecx )(
                get_proc_address( ffi.cast( 'uint32_t', module ), func_name ),
                0, 
                ... 
            ) 
        end 
    end

    return {
        get_module_handle = get_module_handle,
        get_proc_address = get_proc_address,
        get_function = get_function,
        
        load_lib = get_function( get_module_handle( 'kernel32.dll' ), 'LoadLibraryA', 'void*( __fastcall* )( uint32_t, uint32_t, const char* )' ),
        free_lib = get_function( get_module_handle( 'kernel32.dll' ), 'FreeLibrary', 'bool( __fastcall* )( uint32_t, uint32_t, void* )' ),
    }
end )( )
--@endregion

--@region font_manager
local font_manager = ( function( )
    local fonts_stack = {}
    
    local function create_font( font_fn, path, size, flags )
        local id = string.format( '%s; %d; %d', path, size, flags )
        if fonts_stack[ id ] == nil then
            fonts_stack[ id ] = {
                path = path,
                size = size,
                flags = flags,

                data = nil,
                font_fn = font_fn,

                ready = false
            }
        end
        return id
    end

    local function get_font( id )
        local font = fonts_stack[ id ]
        return font
    end

    local function handle_fonts( )
        for key, value in pairs( fonts_stack ) do
            if not value.ready then
                value.data = value.font_fn( value.path, value.size, value.flags )
                value.ready = true
            end
        end
    end

    return {
        create_font = create_font,
        get_font = get_font,
        handle_fonts = handle_fonts
    }
end )( )    
--@endregion

--@region vec2_t
local vec2_t = ( function( )
    ffi.cdef [[
        typedef struct { 
            float x, y; 
        } vec2_t;
    ]]

    local vec2_t

    vec2_t = ffi.metatype( 'vec2_t', {
        __call = function( self, x, y )
            return vec2_t( x, y )
        end,

        __new = function( ct, x, y )
            return ffi.new( ct, { x or 0, y or 0 } )
        end,

        __add = function( a, b )
            if type(b) == 'number' then
                return vec2_t( a.x + b, a.y + b )
            elseif type( a ) == 'number' then
                return vec2_t( a + b.x, a + b.y )
            else
                return vec2_t( a.x + b.x, a.y + b.y )
            end
        end,

        __sub = function( a, b )
            if type( b ) == 'number' then
                return vec2_t( a.x - b, a.y - b )
            elseif type( a ) == 'number' then
                return vec2_t( a - b.x, a - b.y )
            else
                return vec2_t( a.x - b.x, a.y - b.y )
            end
        end,

        __mul = function( a, b )
            if type( b ) == 'number' then
                return vec2_t( a.x * b, a.y * b )
            elseif type( a ) == 'number' then
                return vec2_t( a * b.x, a * b.y )
            else
                return vec2_t( a.x * b.x, a.y * b.y )
            end
        end,

        __div = function( a, b )
            if type( b ) == 'number' then
                return vec2_t( a.x / b, a.y / b )
            elseif type( a ) == 'number' then
                return vec2_t( a / b.x, a / b.y )
            else
                return vec2_t( a.x / b.x, a.y / b.y )
            end
        end,

        __index = {
            __type = 'vec2_t',

            clone = function( self )
                return vec2_t( self.x, self.y )
            end,

            unpack = function( self )
                return self.x, self.y
            end,

            length2d = function( self )
                return math.sqrt( self.x * self.x + self.y * self.y )
            end,

            tostring = function( self )
                return string.format( 'vec2_t(%.2f, %.2f)', self.x, self.y )
            end,
        },
    })

    return vec2_t
end )( )
--@endregion

--@region col_t
local col_t = ( function( )
    ffi.cdef [[
        typedef struct {
            float r, g, b, a;
        } col_t;
    ]]

    local function hex_to_rgb( hex )
        local formated_hex = string.find( hex, '\a' ) and string.sub( hex, 2 ) or hex
        local r = tonumber( formated_hex:sub( 1, 2 ), 16 )
        local g = tonumber( formated_hex:sub( 3, 4 ), 16 )
        local b = tonumber( formated_hex:sub( 5, 6 ), 16 )
        local a = tonumber( formated_hex:sub( 7, 8 ), 16 )
        return r, g, b, a
    end

    local function lerp_fn( a, b, percentage, min )
        local c = a + ( b - a ) * percentage
        return math.abs( b - c ) < ( min or 0.002 ) and b or c
    end

    local col_t
    col_t = ffi.metatype( 'col_t', {
        __call = function( self, r, g, b, a )
            return col_t( r, g, b, a )
        end,

        __new = function( ct, r, g, b, a )
            if type( r ) == 'string' then
                local fr, fg, fb, fa = hex_to_rgb( r )
                if type( g ) == 'number' then
                    a = g
                else
                    a = fa / 255
                end
                r, g, b = fr / 255, fg / 255, fb / 255
            end

            return ffi.new( ct, { r or 1, g or 1, b or 1, a or 1 })
        end,

        __index = {
            __type = 'col_t',

            tostring = function( self )
                return string.format( 'col_t(%.2f, %.2f, %.2f, %.2f)', self.r, self.g, self.b, self.a )
            end,

            clone = function( self )
                return col_t( self.r, self.g, self.b, self.a )
            end,

            unpack = function( self )
                return self.r, self.g, self.b, self.a
            end,
            
            fraction = function( self )
                return col_t( self.r / 255, self.g / 255, self.b / 255, self.a / 255 )
            end,

            alpha = function( self, factor )
                local new_a = math.max( 0, math.min( 1, self.a * factor ) )
                return col_t( self.r, self.g, self.b, new_a )
            end,

            hex = function( self )
                return string.format( '%02X%02X%02X%02X', self.r*255, self.g*255, self.b*255, self.a*255 )
            end,

            lerp = function( self, other, weight )
                local r = lerp_fn( self.r, other.r, weight )
                local g = lerp_fn( self.g, other.g, weight )
                local b = lerp_fn( self.b, other.b, weight )
                local a = lerp_fn( self.a, other.a, weight )

                return col_t( r, g, b, a )
            end
        }
    } )

    return col_t
end )( )
--@endregion

--@region flags
local draw_flags = {
    none                            = 0,
    closed                          = bit.lshift( 1, 0 ),
    round_corners_top_left          = bit.lshift( 1, 4 ),
    round_corners_top_right         = bit.lshift( 1, 5 ),
    round_corners_bottom_left       = bit.lshift( 1, 6 ),
    round_corners_bottom_right      = bit.lshift( 1, 7 ),
    round_corners_none              = bit.lshift( 1, 8 ),
    round_corners_top               = bit.bor( bit.lshift( 1, 4 ), bit.lshift( 1, 5 ) ),
    round_corners_bottom            = bit.bor( bit.lshift( 1, 6 ), bit.lshift( 1, 7 ) ),
    round_corners_left              = bit.bor( bit.lshift( 1, 6 ), bit.lshift( 1, 4 ) ),
    round_corners_right             = bit.bor( bit.lshift( 1, 7 ), bit.lshift( 1, 5 ) ),
    round_corners_all               = bit.bor( bit.lshift( 1, 4 ), bit.lshift( 1, 5 ), bit.lshift( 1, 6 ), bit.lshift( 1, 7 ) ),
    round_corners_default           = bit.bor( bit.lshift( 1, 4 ), bit.lshift( 1, 5 ), bit.lshift( 1, 6 ), bit.lshift( 1, 7 ) ),
    round_corners_mask              = bit.bor( bit.lshift( 1, 4 ), bit.lshift( 1, 5 ), bit.lshift( 1, 6 ), bit.lshift( 1, 7 ), bit.lshift( 1, 8 ) ),
    shadow_cut_out_shape_background = bit.lshift( 1, 9 )
}

local font_flags = {
    no_hinting      = bit.lshift( 1, 0 ),
    no_auto_hint    = bit.lshift( 1, 1 ),
    force_auto_hint = bit.lshift( 1, 2 ),
    light_hinting   = bit.lshift( 1, 3 ),
    mono_hinting    = bit.lshift( 1, 4 ),
    bold            = bit.lshift( 1, 5 ),
    oblique         = bit.lshift( 1, 6 ),
    monochrome      = bit.lshift( 1, 7 ),
    load_color      = bit.lshift( 1, 8 ),
    bitmap          = bit.lshift( 1, 9 )
}
--@endregion

--@region render
local render = function( pathn, use_game )
    local get_directory = vtable_bind( 'engine.dll', 'VEngineClient014', 36, 'const char*( __thiscall* )( void* )' )
    local formated_dir = string.sub( ffi.string( get_directory( ) ), 1, -5 )

    local dll_name = 'main.dll'
    local test_path = string.format( '%s\\%s', 'C:\\Users\\klient\\Desktop\\necron\\gamesense_render\\Debug', dll_name )

    local path = string.format( '%s\\lua\\%s', formated_dir, dll_name )
    if pathn ~= nil then
        path = use_game and string.format( '%s\\%s', formated_dir, pathn ) or pathn
    end

    local handle = libapi.load_lib( test_path )

    local update_buffer_fn = libapi.get_function( handle, 'update_buffer', 'void( __fastcall* )( uint32_t, uint32_t )' )
    local is_imgui_ready_fn = libapi.get_function( handle, 'is_imgui_ready', 'bool( __fastcall* )( uint32_t, uint32_t )' )

    local create_font_fn = libapi.get_function( handle, 'create_font', 'void*( __fastcall* )( uint32_t, uint32_t, const char*, float, unsigned int )' )
    local create_texture_from_memory_fn = libapi.get_function( handle, 'create_texture_from_memory', 'void*( __fastcall* )( uint32_t, uint32_t, const char*, int )' )
    local create_texture_from_file_fn = libapi.get_function( handle, 'create_texture_from_file', 'void*( __fastcall* )( uint32_t, uint32_t, const char* )' )

    local get_text_size_fn = libapi.get_function( handle, 'get_text_size', 'float( __fastcall* )( uint32_t, uint32_t, vec2_t*, void*, float, const char* )' )

    local add_polyline_fn = libapi.get_function( handle, 'add_polyline', 'void( __fastcall* )( uint32_t, uint32_t, const vec2_t*, int, col_t, unsigned int, float )' )
    local add_polyfilled_fn = libapi.get_function( handle, 'add_polyfilled', 'void( __fastcall* )( uint32_t, uint32_t, const vec2_t*, int, col_t )' )
    local add_polyshadow_fn = libapi.get_function( handle, 'add_polyshadow', 'void( __fastcall* )( uint32_t, uint32_t, const vec2_t*, int, col_t, float, vec2_t, unsigned int )' )
    local add_blur_fn = libapi.get_function( handle, 'add_blur', 'void( __fastcall* )( uint32_t, uint32_t, float, float, float, float, col_t, float, unsigned int )' )
    local add_rect_filled_fn = libapi.get_function( handle, 'add_rect_filled', 'void( __fastcall* )( uint32_t, uint32_t, float, float, float, float, col_t, float, unsigned int )' )
    local add_rect_fn = libapi.get_function( handle, 'add_rect', 'void( __fastcall* )( uint32_t, uint32_t, float, float, float, float, col_t, float, unsigned int, float )' )
    local add_rect_shadow_fn = libapi.get_function( handle, 'add_rect_shadow', 'void( __fastcall* )( uint32_t, uint32_t, float, float, float, float, col_t, float, vec2_t, float, unsigned int )' )
    local add_rect_gradient_fn = libapi.get_function( handle, 'add_rect_gradient', 'void( __fastcall* )( uint32_t, uint32_t, float, float, float, float, col_t, col_t, col_t, col_t, float, unsigned int )' )
    local add_image_fn = libapi.get_function( handle, 'add_image', 'void( __fastcall* )( uint32_t, uint32_t, void*, float, float, float, float, col_t, float, unsigned int )' )
    local add_text_fn = libapi.get_function( handle, 'add_text', 'void( __fastcall* )( uint32_t, uint32_t, void*, const char*, float, float, col_t )' )
    local add_line_fn = libapi.get_function( handle, 'add_line', 'void( __fastcall* )( uint32_t, uint32_t, float, float, float, float, col_t, float )' )
    local add_circle_fn = libapi.get_function( handle, 'add_circle', 'void( __fastcall* )( uint32_t, uint32_t, float, float, float, int, col_t, float )' )
    local add_circle_filled_fn = libapi.get_function( handle, 'add_circle_filled', 'void( __fastcall* )( uint32_t, uint32_t, float, float, float, int, col_t )' )
    local add_circle_shadow_fn = libapi.get_function( handle, 'add_circle_shadow', 'void( __fastcall* )( uint32_t, uint32_t, float, float, float, int, col_t, float, vec2_t, unsigned int )' )

    local push_clip_rect_fn = libapi.get_function( handle, 'push_clip_rect', 'void( __fastcall* )( uint32_t, uint32_t, float, float, float, float, bool )' )
    local pop_clip_rect_fn = libapi.get_function( handle, 'pop_clip_rect', 'void( __fastcall* )( uint32_t, uint32_t )' )

    local push_rotation_fn = libapi.get_function( handle, 'push_rotation', 'void( __fastcall* )( uint32_t, uint32_t, float )' )
    local pop_rotation_fn = libapi.get_function( handle, 'pop_rotation', 'void( __fastcall* )( uint32_t, uint32_t )' )

    local callbacks = {}

    local function load_font( path, size, flags )
        return font_manager.create_font( create_font_fn, path, size or 12, flags or 0 )
    end

    local function load_image( content )
        if string.find( content, '[^%g%s]' ) then
            return create_texture_from_memory_fn( content, #content )
        end

        return create_texture_from_file_fn( content )
    end

    local function get_text_size( font, text )
        local font = font_manager.get_font( font )
        local size = ffi.new( 'vec2_t[ 1 ]' )

        get_text_size_fn( size, font.data, font.size, text )

        return size[ 0 ]
    end

    local function push_rotation( deg )
        push_rotation_fn( deg )
    end

    local function pop_rotation( )
        pop_rotation_fn( )
    end

    local function push_clip_rect( x, y, w, h, intersect )
        local nintersect = false
        if intersect ~= nil then
            nintersect = intersect
        end
        push_clip_rect_fn( x, y, w, h, nintersect )
    end

    local function pop_clip_rect( )
        pop_clip_rect_fn( )
    end

    local function add_image( texture, x, y, w, h, color, rounding, flags )
        add_image_fn( texture, x, y, w, h, color, rounding or 0, flags or 0 )
    end

    local function add_polyline( points, color, thick, flags )
        local formated_points = ffi.new( 'vec2_t[?]', #points, points )
        add_polyline_fn( formated_points, #points, color, flags or 0, thick or 1 )
    end

    local function add_polyfilled( points, color )
        local formated_points = ffi.new( 'vec2_t[?]', #points, points )
        add_polyfilled_fn( formated_points, #points, color )
    end

    local function add_polyshadow( points, color, thick, offset, flags )
        local formated_points = ffi.new( 'vec2_t[?]', #points, points )
        add_polyshadow_fn( formated_points, #points, color, thick or 10, offset or vec2_t( 0, 0 ), flags or 0 )
    end

    local function add_rect_filled( x, y, w, h, color, rounding, flags )
        add_rect_filled_fn( x, y, w, h, color, rounding or 0, flags or 0 )
    end

    local function add_rect_gradient( x, y, w, h, color_up_right, color_up_left, color_down_right, color_down_left, rounding, flags )
        add_rect_gradient_fn( x, y, w, h, color_up_right, color_up_left, color_down_right, color_down_left, rounding or 0, flags or 0 )
    end

    local function add_rect( x, y, w, h, color, thick, rounding, flags )
        add_rect_fn( x, y, w, h, color, rounding or 0, flags or 0, thick or 1 )
    end

    local function add_rect_shadow( x, y, w, h, color, thick, offset, rounding, flags )
        add_rect_shadow_fn( x, y, w, h, color, thick or 10, offset or vec2_t( 0, 0 ), rounding or 0, flags or 0 )
    end

    local function add_blur( x, y, w, h, color, rounding, flags )
        add_blur_fn( x, y, w, h, color, rounding or 0, flags or 0 )
    end

    local function add_line( x, y, x1, y1, color, thick )
        add_line_fn( x, y, x1, y1, color, thick or 1 )
    end

    local function add_circle( x, y, radius, segments, color, thick )
        add_circle_fn( x, y, radius, segments, color, thick or 1 )
    end

    local function add_circle_filled( x, y, radius, segments, color )
        add_circle_filled_fn( x, y, radius, segments, color )
    end

    local function add_circle_shadow( x, y, radius, segments, color, thick, offset, flags )
        add_circle_shadow_fn( x, y, radius, segments, color, thick or 10, offset or vec2_t( 0, 0 ), flags or 0 )
    end

    local function add_text( font, text, x, y, color )
        if not font then
            return
        end

        add_text_fn( font_manager.get_font( font ).data, text, x, y, color )
    end

    local function set_callback( fn )
        callbacks[ #callbacks + 1 ] = fn
    end

    client.set_event_callback( 'paint_ui', function( )
        if not is_imgui_ready_fn( ) then
            return
        end

        if #callbacks == 0 then
            return
        end

        font_manager.handle_fonts( )

        for i = 1, #callbacks do
            local callback = callbacks[ i ]
            local status, msg = pcall( callback )
            if not status then
                print( msg )
            end
        end

        update_buffer_fn( )
    end )

    local function shutdown( ) 
        libapi.free_lib( handle )
        collectgarbage( 'collect' )
    end; defer( shutdown )
    client.set_event_callback( 'shutdown', shutdown )

    return {
        load_font = load_font,
        load_image = load_image,
        
        get_text_size = get_text_size,

        add_image = add_image,
        add_rect_filled = add_rect_filled,
        add_rect = add_rect,
        add_rect_shadow = add_rect_shadow,
        add_rect_gradient = add_rect_gradient,
        add_blur = add_blur,
        add_text = add_text,
        add_polyline = add_polyline,
        add_polyfilled = add_polyfilled,
        add_polyshadow = add_polyshadow,
        add_line = add_line,
        add_circle = add_circle,
        add_circle_filled = add_circle_filled,
        add_circle_shadow = add_circle_shadow,

        push_clip_rect = push_clip_rect,
        pop_clip_rect = pop_clip_rect,
        push_rotation = push_rotation,
        pop_rotation = pop_rotation,

        set_callback = set_callback,

        vec2_t = vec2_t,
        col_t = col_t,

        draw_flags = draw_flags,
        font_flags = font_flags,

        libapi = libapi
    }
end

return render
--@endregion