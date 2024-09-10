const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    message.channel.send('https://docs.xcelstudios.net/xcel-public/xcel-public-servers/faq')
}

exports.conf = {
    name: "faq",
    perm: 0,
    guild: "1195851569472741437"
}