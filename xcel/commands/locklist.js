const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    message.channel.send('https://docs.google.com/spreadsheets/d/1uMZrbys0jBADqHHtweL6p_stV5nZd_IuQczRgNsEdTc/edit?gid=0#gid=0')
}

exports.conf = {
    name: "locklist",
    perm: 0,
    guild: "1195851569472741437"
}