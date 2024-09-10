const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname

exports.runcmd = async(fivemexports, client, message, params) => {
    if (!params[0] && !parseInt(params[0])) {
        return message.reply('Invalid args! Correct term is: ' + process.env.PREFIX + 'reset [permid]')
    }
    // Wipe the user data from all tables
    fivemexports.xcel.execute("DELETE FROM `xcel_user_ids` WHERE user_id = ?", [params[0]], (discordid) => {
        fivemexports.xcel.execute("DELETE FROM `xcel_user_moneys` WHERE user_id = ?", [params[0]], (result) => {
            fivemexports.xcel.execute("DELETE FROM `xcel_users` WHERE id = ?", [params[0]], (userdata) => {
                fivemexports.xcel.execute("DELETE FROM `xcel_user_data` WHERE user_id = ?", [params[0]], (result) => {
                    let embed = {
                        "title": "Reset User",
                        "description": `User with Perm ID: **${params[0]}** data has been reset.`,
                        "color": 0xe44c3c,
                        "footer": {
                            "text": ""
                        },
                        "timestamp": new Date()
                    }
                    message.channel.send({ embed })
                })
            })
        })
    })
}

exports.conf = {
    name: "reset",
    perm: 10,
    guild: "1195851569472741437"
}
