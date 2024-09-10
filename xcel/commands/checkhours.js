const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    if (!params[0]) {
        fivemexports.xcel.execute("SELECT user_id FROM `xcel_verification` WHERE discord_id = ?", [message.author.id], (discord) => {
            if (discord.length > 0) {
                fivemexports.xcel.execute("SELECT * FROM `xcel_user_data` WHERE user_id = ?", [discord[0].user_id], (result) => {
                    if (result.length > 0) {
                        message.reply(`you have **${(JSON.parse(result[0].dvalue).PlayerTime/60).toFixed(2)}** hours`)
                    } else {
                        message.reply('No hours for this user.')
                    }
                });
            } else {
                message.channel.send('Whoops! Something went wrong. :( **We could not find your XCEL User ID**')
            }
        });
    } else {
        fivemexports.xcel.execute("SELECT * FROM `xcel_user_data` WHERE user_id = ?", [params[0]], (result) => {
            if (result.length > 0) {
                message.reply(`has **${(JSON.parse(result[0].dvalue).PlayerTime/60).toFixed(2)}** hours`)
            } else {
                message.channel.send('No hours for this user.')
            }
        });
    }
}

exports.conf = {
    name: "ch",
    perm: 0,
    guild: "1195851569472741437"
}