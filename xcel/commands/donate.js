const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    message.channel.send('https://store.xcelstudios.com/')
}

exports.conf = {
    name: "donate",
    perm: 0,
    guild: "1195851569472741437"
}