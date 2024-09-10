const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    if (!params[0]) {
        let embed = {
            "title": "An Error Occurred",
            "description": "Incorrect Usage\n\nCorrect Usage" + process.env.PREFIX + '\n`!unban [permid]`',
            "color": 0x57F288,
    }
    return message.channel.send({ embed })
    }
    fivemexports.xcel.execute('SELECT * FROM xcel_users WHERE id = ?', [params[0]], (result) => {
        if (result && result.length > 0) {
            if (result[0].banned == 0) {
                let embed = {
                    "title": "An Error Occurred",
                    "description": "User is not banned",
                    "color": 0x57F288,
                }
                message.channel.send({ embed })
            } else {
                let newval = fivemexports.xcel.xcel('setBanned', [params[0], false])
                let embed = {
                    "title": "User Unbanned",
                    "description": "User has been unbanned",
                    "color": 0x57F288,
                }
                message.channel.send({ embed })
            }
        } else {
            let embed = {
                "title": "An Error Occurred",
                "description": "Unable to find an XCEL Account for that ID",
                "color": 0x57F288,
            }
            message.channel.send({ embed })
        }
    });
}

exports.conf = {
    name: "unban",
    perm: 3,
    guild: "1195851569472741437",
    support: true,
}