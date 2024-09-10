const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname;
const settingsjson = require(resourcePath + '/settings.js');
const Discord = require('discord.js');
const hook = new Discord.WebhookClient(settingsjson.settings.verifyLogWebhook.id, settingsjson.settings.verifyLogWebhook.token);

function daysBetween(dateString) {
    const d1 = new Date(dateString);
    const d2 = new Date();
    return Math.round((d2 - d1) / (1000 * 3600 * 24));
}

exports.runcmd = async (fivemexports, client, message, params) => {
    if (message.channel.name === "・verify") {
        message.delete().catch(console.error);
    }

    const code = params[0];

    if (!code || code.length === 0) {
        const embed = new Discord.RichEmbed()
            .setTitle("Verify")
            .setDescription(`:x: Invalid command usage \`${process.env.PREFIX}verify [code]\``)
            .setColor(settingsjson.settings.botErrorColour)
            .setFooter("");
        message.channel.send({ embed }).then(msg => {
            msg.delete(5000).catch(console.error);
        }).catch(console.error);
    } else {
        fivemexports.xcel.execute("SELECT * FROM `xcel_verification` WHERE LOWER(code) = LOWER(?)", [code], (result) => {
            if (result && result.length > 0) {
                if (result[0].discord_id !== null) {
                    message.channel.send(`A discord account is already linked to this Perm ID, please contact Management to reverify.`).then(msg => {
                        msg.delete(5000).catch(console.error);
                    }).catch(console.error);
                    return;
                }

                const verifyLog = new Discord.RichEmbed()
                    .setTitle('Verify Log')
                    .addField('Perm ID:', `${result[0].user_id}`)
                    .addField('Code:', `${code}`)
                    .addField('Discord:', `${message.author}`)
                    .addField('Discord ID:', `${message.author.id}`)
                    .addField('Created At:', `${message.author.createdAt}`)
                    .addField('Account Age:', `${daysBetween(message.author.createdAt)} days`)
                    .setColor(settingsjson.settings.botColour)
                    .setFooter('XCEL')
                    .setTimestamp();

                // Update only the necessary fields, considering existing values
                const updateValues = {
                    discord_id: result[0].discord_id || message.author.id,
                    verified: 1
                };

                fivemexports.xcel.execute("UPDATE `xcel_verification` SET ? WHERE code = ?", [updateValues, code], async (updateResult) => {
                    if (updateResult) {
                        const embed = new Discord.RichEmbed()
                            .setTitle("Verify")
                            .setDescription(`<a:verify:1216432015511916666> Great you're verified, head back in-game and press connect.`)
                            .setColor(settingsjson.settings.botColour);
                        hook.send(verifyLog).catch(console.error);
                        message.channel.send({ embed }).then(msg => {
                            msg.delete(5000).catch(console.error);
                        }).catch(console.error);
                        await message.member.addRole("1195851569472741441").catch(console.error);
                    }
                });
            } else {
                message.channel.send(`code \`\`${params[0]}\`\` does not exist.`).then(msg => {
                    msg.delete(5000).catch(console.error);
                }).catch(console.error);
            }
        });
    }
};

exports.conf = {
    name: "verify",
    perm: 0,
    guild: "1195851569472741437"
};