function onEvent(name, value1,value2)

if name == "wallpaper change" then

local ffi = require("ffi")

ffi.cdef[[

typedef void* HANDLE;

typedef const wchar_t* LPCWSTR;

typedef int BOOL;

typedef uint32_t UINT;

typedef uint32_t DWORD;

HANDLE SystemParametersInfoW(UINT uiAction, UINT uiParam, void* pvParam, UINT fWinIni);

]]

local SPI_SETDESKWALLPAPER = 0x0014

local SPIF_UPDATEINIFILE = 0x01

----------------------------

-- change this

local path = "D:/Temp/Banner.png"

----------------------------

local widePath = ffi.new("wchar_t[?]", #path + 1)

for i = 1, #path do

widePath[i - 1] = ffi.cast("wchar_t", path:byte(i))

end

local result = ffi.C.SystemParametersInfoW(SPI_SETDESKWALLPAPER, 0, widePath, SPIF_UPDATEINIFILE)

end

end