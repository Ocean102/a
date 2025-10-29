local hub = {
    name = "Tide Hub",
    rf = false,

    key = {
        enabled = true,
        title = "Hệ thống key",
        subtitle = "key super bí mật",
        note = "trong discord",
        file = "cool",
        save = true,
        val = { "khoinguyenamdau1234" }
    },

    colors = {
        name = "#4a8fff",
        error = "#ff3333"
    }
}

hub.notifyPrefix = '<font color="' .. hub.colors.name .. '"><b>' .. hubDat.name .. '</b></font> - '
hub.errorPrefix = '<font color="' .. hub.colors.name .. '"><b>Lỗi callback</b></font>: bấm f9, kép xuống để gửi lỗi'

return hubDat
