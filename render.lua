--@region libs
local ffi = require( 'ffi' )
--@endregion

--@region math
do
    function math.clamp( num, min, max )
        return math.min( math.max( num, min ), max )
    end
end
--@endregion

--@region utils
local utils = ( function( )
    local function print_ptr( ptr )
        print( ffi.cast( 'int64_t', ptr ) )
    end

    local function assert_ptr( name, ptr )
        if ffi.cast( 'int64_t', ptr ) == 0 then
            error( string.format( 'invalid pointer \'%s\'', name or 'unknown' ) )
        end
    end

    local function contains_path( text )
        local patterns = {
            "[A-Za-z]:\\[^%s<>:\"|%?%*]+",
            "\\\\[^%s<>:\"|%?%*]+",
            "[%w%._%-]+\\[%w%._%-%\\]+",
            "/[^%s]+",
            "%./[^%s]+",
            "%.%./[^%s]+",
            "[%w%._%-]+/[%w%._%-%/]+"
        }

        for _, pat in ipairs( patterns ) do
            if string.match( text, pat ) then
                return true
            end
        end

        return false
    end

    return {
        print_ptr = print_ptr,
        assert_ptr = assert_ptr,
        contains_path = contains_path
    }
end )( )
--@endregion

--@region libapi
local libapi = ( function( )
    local jmp_ecx = client.find_signature('engine.dll', '\xFF\xE1'); utils.assert_ptr('jmp_ecx', jmp_ecx)

    local get_module_handle_sig = client.find_signature( 'engine.dll', '\xFF\x15\xCC\xCC\xCC\xCC\x85\xC0\x74\x0B' ); utils.assert_ptr('get_module_handle_sig', get_module_handle_sig)
    local get_module_handle_ptr_ptr = ffi.cast( 'uint32_t**', ffi.cast( 'uint32_t', get_module_handle_sig ) + 2 ); utils.assert_ptr( 'get_module_handle_ptr_ptr', get_module_handle_ptr_ptr )
    local get_module_handle_ptr = get_module_handle_ptr_ptr[0][0]; utils.assert_ptr( 'get_module_handle_ptr', get_module_handle_ptr )
    local get_module_handle_fn = ffi.cast( 'uint32_t( __fastcall* )( unsigned int, unsigned int, const char* )', jmp_ecx )

    local get_proc_address_sig = client.find_signature( 'engine.dll', '\xFF\x15\xCC\xCC\xCC\xCC\xA3\xCC\xCC\xCC\xCC\xEB\x05' ); utils.assert_ptr( 'get_proc_address_sig', get_proc_address_sig )
    local get_proc_address_ptr_ptr = ffi.cast( 'uint32_t**', ffi.cast( 'uint32_t', get_proc_address_sig ) + 2 ); utils.assert_ptr( 'get_proc_address_ptr_ptr', get_proc_address_ptr_ptr )
    local get_proc_address_ptr = get_proc_address_ptr_ptr[0][0]; utils.assert_ptr( 'get_proc_address_ptr', get_proc_address_ptr )
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

--@region vec2_t
local vec2_t = ( function( )
    ffi.cdef [[
    typedef struct { 
        float x, y; 
    } vec2_t;
    ]]

    local vec2_ct = ffi.typeof( 'vec2_t' )
    local vec2_t = ffi.metatype( vec2_ct, {
        __call = function( self, x, y )
            return vec2_ct( x or 0, y or 0 )
        end,

        __add = function( a, b )
            if type(b) == 'number' then
                return vec2_ct( a.x + b, a.y + b )
            elseif type( a ) == 'number' then
                return vec2_ct( a + b.x, a + b.y )
            else
                return vec2_ct( a.x + b.x, a.y + b.y )
            end
        end,

        __sub = function( a, b )
            if type( b ) == 'number' then
                return vec2_ct( a.x - b, a.y - b )
            elseif type( a ) == 'number' then
                return vec2_ct( a - b.x, a - b.y )
            else
                return vec2_ct( a.x - b.x, a.y - b.y )
            end
        end,

        __mul = function( a, b )
            if type( b ) == 'number' then
                return vec2_ct( a.x * b, a.y * b )
            elseif type( a ) == 'number' then
                return vec2_ct( a * b.x, a * b.y )
            else
                return vec2_ct( a.x * b.x, a.y * b.y )
            end
        end,

        __div = function( a, b )
            if type( b ) == 'number' then
                return vec2_ct( a.x / b, a.y / b )
            elseif type( a ) == 'number' then
                return vec2_ct( a / b.x, a / b.y )
            else
                return vec2_ct( a.x / b.x, a.y / b.y )
            end
        end,

        __tostring = function( self )
            return string.format( 'vec2_t(%.2f, %.2f)', self.x, self.y )
        end,

        __index = {
            __type = 'vec2_t',

            clone = function( self )
                return vec2_ct( self.x, self.y )
            end,

            unpack = function( self )
                return self.x, self.y
            end,
            
            floor = function( self )
                return vec2_ct( math.floor( self.x ), math.floor( self.y ) )
            end,

            length2d = function( self )
                return math.sqrt( self.x * self.x + self.y * self.y )
            end,

            length2d_sqr = function( self )
                return self.x * self.x + self.y * self.y
            end,

            normalize = function( self )
                local l = math.sqrt( self.x * self.x + self.y * self.y )
                if l < 1e-6 then
                    return vec2_ct( 0, 0 )
                end
                return vec2_ct( self.x / l, self.y / l )
            end,

            dot = function( self, v )
                return self.x * v.x + self.y * v.y
            end,

            cross = function( self, v )
                return self.x * v.y - self.y * v.x
            end,

            distance = function( self, v )
                local dx = self.x - v.x
                local dy = self.y - v.y
                return math.sqrt( dx * dx + dy * dy )
            end,

            distance_sqr = function( self, v )
                local dx = self.x - v.x
                local dy = self.y - v.y
                return dx * dx + dy * dy
            end,

            perp = function( self )
                return vec2_ct( -self.y, self.x )
            end,

            is_zero = function( self, eps )
                eps = eps or 1e-6
                return math.abs( self.x ) < eps and math.abs( self.y ) < eps
            end,

            tostring = function( self )
                return string.format( 'vec2_t(%.2f, %.2f)', self.x, self.y )
            end,
        },
    } )

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

    local col_ct = ffi.typeof( 'col_t' )
    local col_t = ffi.metatype( col_ct, {
        __call = function( self, r, g, b, a )
            return col_ct( r, g, b, a )
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

            brightness = function( self )
                return math.max( self.r, math.max( self.g, self.b ) )
            end,

            clone = function( self )
                return col_ct( self.r, self.g, self.b, self.a )
            end,

            unpack = function( self )
                return self.r, self.g, self.b, self.a
            end,
            
            fraction = function( self )
                return col_ct( self.r / 255, self.g / 255, self.b / 255, self.a / 255 )
            end,

            alpha = function( self, factor )
                local new_a = math.max( 0, math.min( 1, self.a * factor ) )
                return col_ct( self.r, self.g, self.b, new_a )
            end,

            hex = function( self )
                return string.format( '%02X%02X%02X%02X', self.r*255, self.g*255, self.b*255, self.a*255 )
            end,

            lerp = function( self, other, weight )
                local r = lerp_fn( self.r, other.r, weight )
                local g = lerp_fn( self.g, other.g, weight )
                local b = lerp_fn( self.b, other.b, weight )
                local a = lerp_fn( self.a, other.a, weight )

                return col_ct( r, g, b, a )
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

--@region font_manager
local font_manager = ( function( )
    local font_c = {}
    font_c.__index = font_c
    
    function font_c:get_size( )
        return self.size
    end

    function font_c:get_data( )
        return self.data
    end

    local function create_font( font_fn, path, size, flags )
        local data = font_fn( path, size, flags )

        local font = setmetatable( {
            data = data,
            path = path,
            size = size,
            flags = flags
        }, font_c )

        return font
    end

    return {
        create_font = create_font
    }
end )( )    
--@endregion

--@region render
local render_impl = function( pathn, use_game )
    ffi.cdef [[
    typedef struct IDirect3DTexture9 IDirect3DTexture9;

    typedef struct { 
        unsigned int width, height;
        IDirect3DTexture9* texture;
    } img_object_t;
    ]]

    local get_directory = vtable_bind( 'engine.dll', 'VEngineClient014', 36, 'const char*( __thiscall* )( void* )' )
    local formated_dir = string.sub( ffi.string( get_directory( ) ), 1, -5 )

    local path = string.format( '%s\\lua\\%s', formated_dir, 'render.dll' )
    if pathn ~= nil then
        path = use_game and string.format( '%s\\%s', formated_dir, pathn ) or pathn
    end
    
    local status, handle = pcall( libapi.load_lib, path )
    if ffi.cast( 'int64_t', handle ) == 0 or not status then
        error( tostring( ffi.cast( 'int64_t', handle ) ), 1 )
    end

    local is_render_init_fn = libapi.get_function( handle, 'is_render_init', 'bool( __fastcall* )( uint32_t, uint32_t )' )
    local update_buffer_fn = libapi.get_function( handle, 'update_buffer', 'void( __fastcall* )( uint32_t, uint32_t )' )

    local push_mask_fn = libapi.get_function( handle, 'push_mask', 'void( __fastcall* )( uint32_t, uint32_t, bool, float )' )
    local pop_mask_fn = libapi.get_function( handle, 'pop_mask', 'void( __fastcall* )( uint32_t, uint32_t )' )
    local begin_mask_content_fn = libapi.get_function( handle, 'begin_mask_content', 'void( __fastcall* )( uint32_t, uint32_t )' )

    local push_blur_fn = libapi.get_function( handle, 'push_blur', 'void( __fastcall* )( uint32_t, uint32_t, col_t )' )
    local pop_blur_fn = libapi.get_function( handle, 'pop_blur', 'void( __fastcall* )( uint32_t, uint32_t )' )

    local poly_fn = libapi.get_function( handle, 'poly', 'void( __fastcall* )( uint32_t, uint32_t, const vec2_t*, int, col_t )' )
    local poly_line_fn = libapi.get_function( handle, 'poly_line', 'void( __fastcall* )( uint32_t, uint32_t, const vec2_t*, int, col_t, float, unsigned int )' )
    local poly_shadow_fn = libapi.get_function( handle, 'poly_shadow', 'void( __fastcall* )( uint32_t, uint32_t, const vec2_t*, int, col_t, float, vec2_t, unsigned int )' )

    local circle_fn = libapi.get_function( handle, 'circle', 'void( __fastcall* )( uint32_t, uint32_t, vec2_t, col_t, float, int )' )
    local circle_outline_fn = libapi.get_function( handle, 'circle_outline', 'void( __fastcall* )( uint32_t, uint32_t, vec2_t, col_t, float, float, int )' )
    local circle_shadow_fn = libapi.get_function( handle, 'circle_shadow', 'void( __fastcall* )( uint32_t, uint32_t, vec2_t, col_t, float, float, vec2_t, unsigned int, int )' )
    local circle_gradient_fn = libapi.get_function( handle, 'circle_gradient', 'void( __fastcall* )( uint32_t, uint32_t, vec2_t, col_t, col_t, float )' )

    local rect_fn = libapi.get_function( handle, 'rect', 'void( __fastcall* )( uint32_t, uint32_t, vec2_t, vec2_t, col_t, float, unsigned int )' )
    local rect_outline_fn = libapi.get_function( handle, 'rect_outline', 'void( __fastcall* )( uint32_t, uint32_t, vec2_t, vec2_t, col_t, float, float, unsigned int )' )
    local rect_shadow_fn = libapi.get_function( handle, 'rect_shadow', 'void( __fastcall* )( uint32_t, uint32_t, vec2_t, vec2_t, col_t, float, vec2_t, float, unsigned int )' )
    local gradient_fn = libapi.get_function( handle, 'gradient', 'void( __fastcall* )( uint32_t, uint32_t, vec2_t, vec2_t, col_t, col_t, col_t, col_t, float, unsigned int )' ) 

    local texture_fn = libapi.get_function( handle, 'texture', 'void( __fastcall* )( uint32_t, uint32_t, img_object_t, vec2_t, vec2_t, col_t, float, unsigned int )' )
    local load_texture_svg_fn = libapi.get_function( handle, 'load_texture_svg', 'img_object_t( __fastcall* )( uint32_t, uint32_t, const char*, const float )' )
    local load_texture_file_fn = libapi.get_function( handle, 'load_texture_file', 'img_object_t( __fastcall* )( uint32_t, uint32_t, const char* )' )
    local load_texture_memory_fn = libapi.get_function( handle, 'load_texture_memory', 'img_object_t( __fastcall* )( uint32_t, uint32_t, const char*, int )' )

    local load_font_file_fn = libapi.get_function( handle, 'load_font_file', 'void*( __fastcall* )( uint32_t, uint32_t, const char*, float, unsigned int )' )
    local measure_text_fn = libapi.get_function( handle, 'measure_text', 'void( __fastcall* )( uint32_t, uint32_t, vec2_t*, void*, float, const char* )' )
    local text_fn = libapi.get_function( handle, 'text', 'const char*( __fastcall* )( uint32_t, uint32_t, void*, vec2_t, col_t, const char* )' )

    local get_windows_directory_fn = libapi.get_function( libapi.get_module_handle( 'kernel32.dll' ), 'GetWindowsDirectoryA', 'unsigned int( __fastcall* )( uint32_t, uint32_t, char*, unsigned int )' )

    local MAX_PATH = 260
    local function get_fonts_path( )
        local buf = ffi.new( 'char[?]', MAX_PATH )

        local len = get_windows_directory_fn( buf, MAX_PATH )
        if len == 0 then
            return ''
        end

        local win_dir = ffi.string( buf, len )
        return win_dir .. '\\Fonts\\'
    end

    local function centroid( pts, count )
        local c = vec2_t( 0, 0 )
        for i = 1, count do
            c = c + pts[i]
        end
        return c / count
    end

    local function rounded_points( pts, r, arc_segments )
        local count = #pts
        local out = {}

        if not pts or count < 3 or r <= 0 then
            for i = 1, count do
                out[#out+1] = pts[i]
            end
            return out
        end

        arc_segments = arc_segments or 8
        if arc_segments < 3 then arc_segments = 3 end

        local CEN = centroid( pts, count )

        for i = 1, count do
            local A = pts[i == 1 and count or i - 1]
            local B = pts[i]
            local C = pts[i == count and 1 or i + 1]

            local v1 = ( A - B ):normalize( )
            local v2 = ( C - B ):normalize( )

            local cos_th = math.clamp( v1:dot( v2 ), -1.0, 1.0 )
            local theta = math.acos( cos_th )

            if theta < 1e-4 then
                out[#out + 1] = B
            else
                local t = r / math.tan( theta * 0.5 )

                local len1 = B:distance( A )
                local len2 = B:distance( C )
                local max_t = math.min( len1, len2 ) * 0.5
                if t > max_t then t = max_t end

                local P = B + v1 * t
                local Q = B + v2 * t

                local bis = ( v1 + v2 ):normalize( )
                if bis:is_zero( ) then
                    out[#out + 1] = B
                else
                    local to_center = ( CEN - B ):normalize( )
                    if bis:dot( to_center ) < 0 then
                        bis = bis * -1
                    end

                    local sin_half = math.sin( theta * 0.5 )
                    if sin_half < 1e-6 then
                        out[#out + 1] = B
                    else
                        local h = r / sin_half
                        local O = B + bis * h

                        local angP = math.atan2( P.y - O.y, P.x - O.x )
                        local angQ = math.atan2( Q.y - O.y, Q.x - O.x )

                        local d = angQ - angP
                        while d > math.pi do d = d - 2 * math.pi end
                        while d < -math.pi do d = d + 2 * math.pi end

                        out[#out + 1] = P
                        for s = 1, arc_segments - 1 do
                            local a = angP + d * ( s / arc_segments )
                            out[#out+1] = vec2_t( O.x + math.cos( a ) * r, O.y + math.sin( a ) * r )
                        end
                        out[#out + 1] = Q
                    end
                end
            end
        end

        return out
    end

    local function push_mask( inverted, alpha )
        inverted = inverted ~= nil and inverted or false
        alpha = alpha or 1

        push_mask_fn( inverted, alpha )
    end

    local function load_texture_svg( path, scale )
        scale = scale or 1

        local content = path
        if utils.contains_path( path ) then
            content = readfile( path )
        end
        return load_texture_svg_fn( path, scale )
    end

    local function load_texture_file( path )
        return load_texture_file_fn( path )
    end

    local function load_texture_memory( content )
        return load_texture_memory_fn( content, #content )
    end

    local function load_font( path, size, flags )
        size = size or 12
        flags = flags or 0

        local npath = string.format( '%s%s', get_fonts_path( ), path )
        if utils.contains_path( path ) then
            npath = path
        end
        return font_manager.create_font( load_font_file_fn, npath, size, flags )
    end

    local function parse_colored_text( text, default_color )
        local segments = {}
        local current_color = default_color
        local current_text = ''
        
        local function add_segment( )
            if current_text ~= '' then
                segments[#segments + 1] = {
                    text = current_text,
                    color = current_color
                }
                current_text = ''
            end
        end
        
        local i = 1
        local len = #text
        
        while i <= len do
            local char = text:sub( i, i )
            
            if char == '\a' then
                add_segment( )
                
                local after = text:sub( i + 1 )

                if after:sub( 1, 7 ) == 'DEFAULT' then
                    current_color = default_color
                    i = i + 8
                else
                    local hex8 = after:match( '^(%x%x%x%x%x%x%x%x)' )
                    if hex8 then
                        current_color = col_t( hex8 )
                        i = i + 9
                    else
                        local hex6 = after:match( '^(%x%x%x%x%x%x)' )
                        if hex6 then
                            current_color = col_t( hex6 .. 'FF', default_color.a )
                            i = i + 7
                        else
                            i = i + 1
                        end
                    end
                end
            elseif char == '\r' then
                add_segment( )
                current_color = default_color
                i = i + 1
            else
                current_text = current_text .. char
                i = i + 1
            end
        end

        add_segment( )
        
        return segments
    end

    local function strip_color_codes( text )
        local result = text
        result = result:gsub( '\aDEFAULT', '' )
        result = result:gsub( '\a%x%x%x%x%x%x%x%x', '' )
        result = result:gsub( '\a%x%x%x%x%x%x', '' )
        result = result:gsub( '\a.?', '' )
        result = result:gsub( '\r', '' )
        return result
    end

    local function measure_text( font, text )
        if not font or not font.data then 
            return 
        end

        local clean_text = strip_color_codes( text )

        local size = ffi.new( 'vec2_t[1]' )
        measure_text_fn( size, font.data, font.size, clean_text )
        return size[0]
    end

    local function text( font, pos, color, flags, text_str )
        if not text_str or text_str == '' then 
            return 
        end
        
        flags = flags or ''

        if not font or not font.data then 
            return 
        end

        local has_outline = flags:find( 'o' ) ~= nil
        local has_shadow = flags:find( 's' ) ~= nil
        local has_center = flags:find( 'c' ) ~= nil
        
        if has_center then
            local text_size = measure_text( font, text_str )
            pos = pos - vec2_t( text_size.x / 2, 0 )
        end

        local segments = parse_colored_text( text_str, color )
        
        if #segments == 0 then return end
        
        local current_x = pos.x
        
        for i = 1, #segments do
            local segment = segments[ i ]
            
            if segment.text ~= "" then
                local segment_pos = vec2_t( current_x, pos.y )
                
                local segment_alpha = segment.color.a
                local outline_color = col_t( 0, 0, 0, segment_alpha )
                local shadow_color = col_t( 0, 0, 0, segment_alpha )
                
                if has_shadow then
                    text_fn( font.data, segment_pos + 1, shadow_color, segment.text )
                end

                if has_outline then
                    for ox = -1, 1 do
                        for oy = -1, 1 do
                            if ox ~= 0 or oy ~= 0 then
                                text_fn( font.data, segment_pos + vec2_t( ox, oy ), outline_color, segment.text )
                            end
                        end
                    end
                end

                text_fn( font.data, segment_pos, segment.color, segment.text )
                
                local size = measure_text( font, segment.text )
                current_x = current_x + size.x
            end
        end
    end

    local function poly( points, color, rounding )
        poly_fn( ffi.new( 'vec2_t[?]', #points, points ), #points, color )
    end

    local function poly_line( points, color, thick, flags )
        thick = thick or 1
        flags = flags or 0

        poly_line_fn( ffi.new( 'vec2_t[?]', #points, points ), #points, color, thick, flags )
    end

    local function poly_shadow( points, color, thick, offset, flags )
        thick = thick or 10
        offset = offset or vec2_t( )
        flags = flags or 0

        poly_shadow_fn( ffi.new( 'vec2_t[?]', #points, points ), #points, color, thick, offset, flags )
    end

    local function circle( pos, color, radius, segments )
        segments = segments or 0

        circle_fn( pos, color, radius, segments )
    end

    local function circle_outline( pos, color, radius, thick, segments )
        thick = thick or 1
        segments = segments or 0
        
        circle_outline_fn( pos, color, radius, thick, segments )
    end
    
    local function circle_shadow( pos, color, radius, thick, offset, flags, segments )
        thick = thick or 10
        offset = offset or vec2_t( )
        flags = flags or 0
        segments = segments or 0
        
        circle_shadow_fn( pos, color, radius, thick, offset, flags, segments )
    end

    local function circle_gradient( pos, color_in, color_out, radius )
        circle_gradient_fn( pos, color_in, color_out, radius )
    end

    local function texture( texture_data, pos, size, color, rounding, flags )
        rounding = rounding or 0
        flags = flags or 0

        if texture_data.texture == nil then
            return
        end

        texture_fn( texture_data, pos, size, color, rounding, flags )
    end
    
    local function gradient( pos, size, top_left, top_right, bottom_left, bottom_right, rounding, flags )
        rounding = rounding or 0
        flags = flags or 0

        gradient_fn( pos, size, top_left, top_right, bottom_left, bottom_right, rounding, flags )
    end

    local function rect( pos, size, color, rounding, flags )
        rounding = rounding or 0
        flags = flags or 0

        rect_fn( pos, size, color, rounding, flags )
    end

    local function rect_outline( pos, size, color, thick, rounding, flags )
        thick = thick or 1
        rounding = rounding or 0
        flags = flags or 0

        rect_outline_fn( pos, size, color, thick, rounding, flags )
    end

    local function rect_blur( pos, size, color, rounding, flags )
        rounding = rounding or 0
        flags = flags or 0

        push_mask( false, color.a )
            rect( pos, size, col_t( ), rounding, flags )
        begin_mask_content_fn( )
            push_blur_fn( color )
                rect( pos, size, col_t( ) )
            pop_blur_fn( )
        pop_mask_fn( )
    end

    local function rect_shadow( pos, size, color, thick, offset, rounding, flags  )
        thick = thick or 10
        offset = offset or vec2_t( )
        rounding = rounding or 0
        flags = flags or 0

        rect_shadow_fn( pos, size, color, thick, offset, rounding, flags )
    end

    local function handle_render( )
        if not is_render_init_fn( ) then
            print( 'init error' )
            return
        end
        
        client.fire_event( 'render' )

        local status, message = pcall( update_buffer_fn )
        if not status then
            error( message, 1 )
        end
    end
    
    local function shutdown_render( )
        libapi.free_lib( handle )
        collectgarbage( 'collect' ) 
    end

    client.set_event_callback( 'shutdown', shutdown_render )
    client.set_event_callback( 'paint_ui', handle_render )

    return {
        load_texture_svg = load_texture_svg,
        load_texture_file = load_texture_file,
        load_texture_memory = load_texture_memory,
        load_font = load_font,
        
        measure_text = measure_text,
        text = text,

        push_mask = push_mask,
        pop_mask = pop_mask_fn,
        begin_mask_content = begin_mask_content_fn,

        push_blur = push_blur_fn,
        pop_blur = pop_blur_fn,

        poly = poly,
        poly_line = poly_line,
        poly_shadow = poly_shadow,

        circle = circle,
        circle_outline = circle_outline,
        circle_shadow = circle_shadow,
        circle_gradient = circle_gradient,

        rect = rect,
        rect_outline = rect_outline,
        rect_blur = rect_blur,
        rect_shadow = rect_shadow,
        gradient = gradient,

        texture = texture,

        vec2_t = vec2_t,
        col_t = col_t,

        draw_flags = draw_flags,
        font_flags = font_flags,
        rounded_points = rounded_points,

        handle = handle,
        utils = utils
    }
end

return render_impl
--@endregion
