const Discord = require('discord.js'); // ww
const client = new Discord.Client();
const path = require('path')
const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
require('dotenv').config({ path: path.join(resourcePath, './.env') })
const fs = require('fs');
const settingsjson = require(resourcePath + '/settings.js')

client.path = resourcePath
client.ip = settingsjson.settings.ip

if (process.env.TOKEN == "" || process.env.TOKEN == "TOKEN") {
    console.log(`Error! No Token Provided you forgot to edit the .env`);
    throw new Error('Whoops!')
}
// Test
client.on('ready', () => {
    console.log(`Logged in as ${client.user.tag}! Players: ${GetNumPlayerIndices()}`);
    console.log(`Your Prefix Is ${process.env.PREFIX}`)
    init()
});

let onlinePD = 0
let onlineStaff = 0
let onlineNHS = 0
let serverStatus = ""

if (settingsjson.settings.StatusEnabled) {
    setInterval(() => {
        if (!client.guilds.get(settingsjson.settings.GuildID)) return console.log(`Status is enabled but not configured correctly and will not work as intended.`)
        let channelid = client.guilds.get(settingsjson.settings.GuildID).channels.find(r => r.name === settingsjson.settings.StatusChannel);
        if (!channelid) return console.log(`Status channel is not available / cannot be found.`)
        let settingsjsons = require(resourcePath + '/params.json')
        let totalSeconds = (client.uptime / 1000);
        totalSeconds %= 86400;
        let hours = Math.floor(totalSeconds / 3600);
        totalSeconds %= 3600;
        let minutes = Math.floor(totalSeconds / 60);
        client.user.setActivity(`${GetNumPlayerIndices()}/${GetConvarInt("sv_maxclients",64)} players`, { type: 'WATCHING' });
        exports.xcel.execute("SELECT * FROM `xcel_user_moneys`", (result) => {
            playersSinceRelease = result.length
        });
        exports.xcel.xcel('getUsersByPermission', ['admin.tickets'], function(result) {
            if (!result.length)
                onlineStaff = 0
            else
                onlineStaff = result.length
        })
        exports.xcel.xcel('getUsersByPermission', ['police.onduty.permission'], function(result) {
            if (!result.length)
                onlinePD = 0
            else
                onlinePD = result.length
        })
        exports.xcel.xcel('getUsersByPermission', ['nhs.onduty.permission'], function(result) {
            if (!result.length)
                onlineNHS = 0
            else
                onlineNHS = result.length
        })
        exports.xcel.getServerStatus([], function(result) {
            serverStatus = result
        })
        channelid.fetchMessage(settingsjsons.messageid).then(msg => {
            let status = {
                "color": settingsjson.settings.botColour,
                "fields": [{
                        "name": "Server Status",
                        "value": `✅ Online`,
                        "inline": true
                    },
                    {
                        "name": "Average Player Ping",
                        "value": `${Math.floor(Math.random() * 18 ) + 2}ms`,
                        "inline": true
                    },
                    {
                        "name": "Ping",
                        "value": `${Math.floor(Math.random() * 19 ) + 4}ms`,
                        "inline": true
                    },
                    {
                        "name": "<:pd:1209805933597954078> Police",
                        "value": `${onlinePD}`,
                        "inline": true
                    },
                    {
                        "name": "<:nhs:1209805932276482088> NHS",
                        "value": `${onlineNHS}`,
                        "inline": true
                    },
                    {
                        "name": "💂 Staff",
                        "value": `${onlineStaff}`,
                        "inline": true
                    },
                    {
                        "name": "👫 Players",
                        "value": `${GetNumPlayerIndices()}/${GetConvarInt("sv_maxclients",64)}`,
                        "inline": true
                    },
                    {
                        "name": "How do I direct connect?",
                        "value": '``F8 -> connect coming soon!``',
                        "inline": false
                    },
                ],
                "title": "<:xrp:1272230047842959400> XCEL Server #1 Status",
                "footer": {
                    "text": "XCEL"
                },
                "timestamp": new Date()
            }
            msg.edit({ embed: status }) // uncomment when not using testing bot
        }).catch(err => {
            channelid.send('Status Page Starting..').then(id => {
                settingsjsons.messageid = id.id
                fs.writeFile(`${resourcePath}/params.json`, JSON.stringify(settingsjsons), function(err) {});
                return
            })
        })
    }, 15000);
}


client.commands = new Discord.Collection();

const init = async() => {
    fs.readdir(resourcePath + '/commands/', (err, files) => {
        if (err) console.error(err);
        console.log(`Loading a total of ${files.length} commands.`);
        files.forEach(f => {
            let command = require(`${resourcePath}/commands/${f}`);
            client.commands.set(command.conf.name, command);
        });
    });
}



client.getPerms = function(msg) {

    let settings = settingsjson.settings;
    let lvl1 = msg.guild.roles.find(r => r.name === settings.Level1Perm);
    let lvl2 = msg.guild.roles.find(r => r.name === settings.Level2Perm);
    let lvl3 = msg.guild.roles.find(r => r.name === settings.Level3Perm);
    let lvl4 = msg.guild.roles.find(r => r.name === settings.Level4Perm);
    let lvl5 = msg.guild.roles.find(r => r.name === settings.Level5Perm);
    let lvl6 = msg.guild.roles.find(r => r.name === settings.Level6Perm);
    let lvl7 = msg.guild.roles.find(r => r.name === settings.Level7Perm);
    let lvl8 = msg.guild.roles.find(r => r.name === settings.Level8Perm);
    let lvl9 = msg.guild.roles.find(r => r.name === settings.Level9Perm);
    let lvl10 = msg.guild.roles.find(r => r.name === settings.Level10Perm);

    if (!lvl1 || !lvl2 || !lvl3 || !lvl4 || !lvl5 || !lvl6 || !lvl7 || !lvl8 || !lvl9 || !lvl10) {
        console.log(`Your permissions are not setup correctly and the bot will not function as intended.\nStatus: Please check permission levels are setup correctly.`);
    }

    // Hot fix for Discord role caching
    const guild = client.guilds.get(msg.guild.id);
    if (guild.members.has(msg.author.id)) {
        guild.members.delete(msg.author.id);
    }
    const member = guild.members.get(msg.author.id);
    // Hot fix for Discord role caching

    let level = 0;
    if (msg.member.roles.has(lvl10.id)) {
        level = 10;
    } else if (msg.member.roles.has(lvl9.id)) {
        level = 9;
    } else if (msg.member.roles.has(lvl8.id)) {
        level = 8;
    } else if (msg.member.roles.has(lvl7.id)) {
        level = 7;
    } else if (msg.member.roles.has(lvl6.id)) {
        level = 6;
    } else if (msg.member.roles.has(lvl5.id)) {
        level = 5;
    } else if (msg.member.roles.has(lvl4.id)) {
        level = 4;
    } else if (msg.member.roles.has(lvl3.id)) {
        level = 3;
    } else if (msg.member.roles.has(lvl2.id)) {
        level = 2;
    } else if (msg.member.roles.has(lvl1.id)) {
        level = 1;
    }
    return level;
}


client.on('message', (message) => {
    if (!message.author.bot){
        if (message.channel.name.includes('auction-')){
            if (message.channel.name == '・auction-room'){
                return
            }
            else{
                if (!message.content.includes(`${process.env.PREFIX}bid`)){
                    if (!message.content.includes(`${process.env.PREFIX}auction`) && !message.content.includes(`${process.env.PREFIX}houseauction`) && !message.content.includes(`${process.env.PREFIX}embed`)){
                        message.delete()
                        return
                    }
                }
            }
        }else if (message.channel.name.includes('verify')){
            if (!message.content.includes(`${process.env.PREFIX}verify `)){
                message.delete()
                return
            }
        }
    }
    let client = message.client;
    if (message.author.bot) return;
    if (!message.content.startsWith(process.env.PREFIX)) return;
    let command = message.content.split(' ')[0].slice(process.env.PREFIX.length).toLowerCase();
    let params = message.content.split(' ').slice(1);
    let cmd;
    let permissions = 0
    if (message.guild.id === settingsjson.settings.GuildID) {
        permissions = client.getPerms(message)
    }
    if (client.commands.has(command)) {
        cmd = client.commands.get(command);
    }
    if (cmd) {
        if (message.guild.id === cmd.conf.guild) {
            if (!message.channel.name.includes('verify') && cmd.conf.name === 'verify'){
                message.delete()
                message.reply('Please use #verify for this command.').then(msg => {
                    msg.delete(5000)
                })
                return
            }else if (!message.channel.name.includes('bot') && !message.channel.name.includes('verify') && !cmd.name === 'embed') {
                message.delete()
                message.reply('Please use bot commands for this command.').then(msg => {
                    msg.delete(5000)
                })
            }
            else {
                if (permissions < cmd.conf.perm) return;
                try {
                    cmd.runcmd(exports, client, message, params, permissions);
                    if (cmd.conf.perm > 0 && params) { // being above 0 means won't log commands meant for anyone that isn't staff
                        params = params.join('\n ');
                        if (params != '') {
                            let { Webhook, MessageBuilder } = require('discord-webhook-node');
                            let hook = new Webhook(settingsjson.settings.botLogWebhook);
                            let embed = new MessageBuilder()
                            .setTitle('Bot Command Log')
                            .addField('Command Used:', `${cmd.conf.name}`)
                            .addField('Parameters:', `${params}`)
                            .addField('Admin:', `${message.author.username} - <@${message.author.id}>`)
                            .setColor('0x2596be')
                            .setFooter('XCEL RP')
                            .setTimestamp();
                            hook.send(embed);
                        }
                    }
                } catch (err) {
                    let embed = {
                        "title": "Error Occured!",
                        "description": "\nAn error occured. Contact <@1041903927253286952> about the issue:\n\n```" + err.message + "\n```",
                        "color": 13632027
                    }
                    message.channel.send({ embed })
                }
            }
        } else {
            if (cmd.conf.support && message.guild.id === "1195851569472741437"){
                if (message.member.roles.has("1195851569472741441")){
                    cmd.runcmd(exports, client, message, params, permissions);
                }
            } else {
                message.reply('This command is expected to be used within another guild.').then(msg => {
                    msg.delete(5000)
                })
                return;
            }
        }
    }
});

client.on("guildMemberAdd", function (member) {
    if (member.guild.id === settingsjson.settings.GuildID){
        try {
            exports.ghmattimysql.execute("SELECT * FROM `xcel_verification` WHERE discord_id = ? AND verified = 1", [member.id], (result) => {
                if (result.length > 0){
                    let role = member.guild.roles.find(r => r.name === '[Member]');
                    member.addRole(role);
                }
            });
        
        } catch (error) {}
    }
});

exports('dmUser', (source, args) => {
    let discordid = args[0].trim()
    let verifycode = args[1]
    let permid = args[2]
    const guild = client.guilds.get(settingsjson.settings.GuildID);
    const member = guild.members.get(discordid);
    try {
        let embed = {
            "title": `Discord Account Link Request`,
            "description": `User ID ${permid} has requested to link this Discord account.\n\nThe code to link is **${verifycode}**\nThis code will expire in 5 minutes.\n\nIf you have not requested this then you can safely ignore the message. Do **NOT** share this message or code with anyone else.`,
            "color": settingsjson.settings.botColour,
        }
        member.send({embed})
    } catch (error) {}
});

exports('dmUserBanned', (args) => {
    let discordid = args[0].trim()
    let reason = args[1]
    let timeLeft = args[2]
    let admin = args[3]
    let info = args[4]
    let time = timeLeft === 'Permanent Ban' ? 'Never' : `in ${timeLeft}`
    const guild = client.guilds.get(settingsjson.settings.GuildID);
    const member = guild.members.get(discordid);
    try {
        let embed = {
            "title": `You have been Banned from XCEL`,
            "description": `Reason: **${reason}**\nExpires: **${time}**\nBanning AdminID: **${admin}**\nAdditional Information: **${info}**`,
            "color": settingsjson.settings.botColour,
        }
        member.send({embed})
    } catch (error) {}
});

exports('dmUserUnbanned', (args) => {
    let discordid = args[0].trim()
    const guild = client.guilds.get(settingsjson.settings.GuildID);
    const member = guild.members.get(discordid);
    try {
        let embed = {
            "title": `You have been Unbanned from XCEL`,
            "description": `Welcome back to the city, we encourage you to brush up on the rules before rejoining XCEL.`,
            "color": settingsjson.settings.botColour,
        }
        member.send({embed})
    } catch (error) {}
});

client.login(process.env.TOKEN)
