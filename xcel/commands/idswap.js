const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

let oldPerm = null;
let newPerm = null;

exports.runcmd = async (fivemexports, client, message, params) => {
    if (!params[0] || !parseInt(params[0]) || !params[1] || !parseInt(params[1])) {
        return message.reply(`Invalid args! Correct term is: ` + process.env.PREFIX + `idswap [perm-id] [new-perm-id] [wipe-existing-player]`)
    }
    oldPerm = params[0];
    newPerm = params[1];
    if (oldPerm === newPerm) {
        return message.reply(`Invalid args! You cannot swap to the same perm id!`)
    }
    const maxCount = await checkMaxPIDS(fivemexports);
    if (newPerm > maxCount) {
        return message.reply(`Invalid new perm id! Max perm id is ${maxCount}`)
    }
    const playerExists = await doesPlayerExist(fivemexports, oldPerm);
    if (!playerExists) {
        return message.reply(`Invalid old perm id! Player does not exist!`)
    }
    const statusMessage = await message.channel.send({ embed: addEmbed(`Starting ID Swap`, ``, 0xed4245) });
    const newPermExists = await doesPlayerExist(fivemexports, newPerm);
    if (newPermExists) {
        if (params[2] === 'true') {
            fivemexports.xcel.kickPlayerIdSwap([parseInt(params[0])], function(cb) {});
            clearExistingPlayer(fivemexports, newPerm, statusMessage, message);
        } else {
           return message.reply('Enter `true` after `newpermid` to wipe the existing player id: [' + newPerm + ']')
        }
    } else {
        try {
            fivemexports.xcel.kickPlayerIdSwap([parseInt(params[0])], function(cb) {});
            await updateNewPlayer(fivemexports, oldPerm, newPerm, statusMessage);
            fivemexports.xcel.execute("SELECT discord_id FROM `xcel_verification` WHERE user_id = ?", [newPerm], (result) => {
                if (result.length > 0) {
                    const discordid = result[0].discord_id;
                    const user = client.users.get(discordid);
                    if (!user) {
                        console.log(`User with ID ${discordid} not found.`);
                        return;
                    }
                    let embed = {
                        "color": settingsjson.settings.botColour,
                        "title": "ID Swap",
                        "description": `Successfully swapped your ID\nOld ID: ${oldPerm}\nNew ID: ${newPerm}`,
                    };
                    user.send({ embed }).catch(error => {
                        console.error(`Could not send DM to ${user.tag}:`, error);
                    });
                }
            });
            message.channel.send({ embed: addEmbed(`Swap ID's`, `ID Swap completed successfully \nOld Perm ID: ${oldPerm}\nNew Perm ID: ${newPerm}`, 0x2ecc71) });
        } catch (error) {
            message.channel.send({ embed: addEmbed(`Swap ID's`, `An Error Occurred: ${error.message}`, 0xed4245) });
        }
    }
}

const embedColors = {
    progress: 0xfea878,
    error: 0xed4245,
    success: 0x2ecc71,
};

const tables = [
    { name: 'xcel_srv_data', field: 'dkey'},
    { name: 'xcel_user_homes', field: 'user_id'},
    { name: 'xcel_user_identities', field: 'user_id'},
    { name: 'xcel_user_ids', field: 'user_id'},
    { name: 'xcel_user_info', field: 'user_id'},
    { name: 'xcel_user_moneys', field: 'user_id'},
    { name: 'xcel_user_tokens', field: 'user_id'},
    { name: 'xcel_user_vehicles', field: 'user_id'},
    { name: 'xcel_verification', field: 'user_id'},
    { name: 'xcel_users', field: 'id'},
    { name: 'xcel_warnings', field: 'user_id'},
    { name: 'xcel_weapon_codes', field: 'user_id'},
    { name: 'xcel_weapon_whitelists', field: 'user_id'},
    { name: 'xcel_user_notes', field: 'user_id'},
    { name: 'xcel_subscriptions', field: 'user_id'},
    { name: 'xcel_stores', field: 'user_id'},
    { name: 'xcel_user_data', field: 'user_id'},
    { name: 'xcel_staff_tickets', field: 'user_id'},
    { name: 'xcel_user_device', field: 'user_id'},
    { name: 'xcel_quests', field: 'user_id'},
    { name: 'xcel_prison', field: 'user_id'},
    { name: 'xcel_police_hours', field: 'user_id'},
    { name: 'xcel_dvsa', field: 'user_id'},
    { name: 'xcel_user_gangs', field: 'user_id'},
    { name: 'xcel_daily_rewards', field: 'user_id'},
    { name: 'xcel_custom_garages', field: 'user_id'},
    { name: 'xcel_casino_chips', field: 'user_id'},
    { name: 'xcel_bans_offenses', field: 'UserID'},
    { name: 'xcel_anticheat', field: 'user_id'},
];

async function updateNewPlayer(fivemexports, oldPerm, newPerm, statusMessage) {
    let statusDescription = '';
    for (let i = 0; i < tables.length; i++) {
        const table = tables[i];
        let result;
        try {
            if (table.name === 'xcel_srv_data') {
                const statement = `UPDATE ${table.name} SET ${table.field} = REPLACE(${table.field}, ?, ?) WHERE ${table.field} LIKE ? AND ${table.field} REGEXP ?`;
                const variables = [`|${oldPerm}`, `|${newPerm}`, `%|${oldPerm}`, `\\|${oldPerm}$`];
                result = await fivemexports.xcel.executeSync(statement, variables);
            } else {
                const statement = `UPDATE ${table.name} SET ${table.field} = ? WHERE ${table.field} = ?`;
                const variables = [newPerm, oldPerm];
                result = await fivemexports.xcel.executeSync(statement, variables);
                if (result && result.affectedRows === 0) {
                    result = await fivemexports.xcel.executeSync(`INSERT INTO ${table.name} (${table.field}) VALUES (?)`, [newPerm]);
                }
            }
            if (result && result.affectedRows > 0) {
                statusDescription += `🟢 Updated ${table.name} [${table.field}]\n`;
            } else {
                statusDescription += `🟠 No data to update in ${table.name}\n`;
            }
            await statusMessage.edit({ embed: addEmbed(`Swapping ID's [${i+1}/${tables.length}]`, statusDescription.trim(), embedColors.progress) });
        } catch (error) {
            statusDescription += `🔴 Error updating ${table.name}: ${error.message}\n`;
            await statusMessage.edit({ embed: addEmbed(`Swapping ID's [${i+1}/${tables.length}]`, statusDescription.trim(), embedColors.error) });
        }
    }
    await statusMessage.edit({ embed: addEmbed(`Swapping ID's [${tables.length}/${tables.length}]`, statusDescription.trim(), embedColors.success) });
}

function addEmbed(title, description, color = embedColors.progress) {
    return {
        color,
        title,
        description,
        timestamp: new Date(),
        footer: { text: `XCEL | ID Swap` },
    };
}

async function doesPlayerExist(fivemexports, permId) {
    const result = await fivemexports.xcel.executeSync(`SELECT * FROM xcel_users WHERE id = ?`, [permId]);
    return result.length > 0;
}

async function checkMaxPIDS(fivemexports) {
    const result = await fivemexports.xcel.executeSync(`SELECT MAX(id) as maxId FROM xcel_users`,[]);
    return result[0].maxId;
}

async function clearExistingPlayer(fivemexports, permId, statusMessage, message) {
    let statusDescription = '';
    for (let i = 0; i < tables.length; i++) {
        const table = tables[i];
        const statement = `DELETE FROM ${table.name} WHERE ${table.field} = ?`;
        const variables = [permId];
        const result = await  fivemexports.xcel.executeSync(
            statement, 
            variables
        );
        if (result && result.affectedRows > 0) {
            statusDescription += `🟢 Deleted ${table.name} [${table.field}]\n`;
        } else {
            statusDescription += `🟠 No data to delete in ${table.name}\n`;
        }
        await statusMessage.edit({ embed: addEmbed(`Clearing ID: ${newPerm} - [${i+1}/${tables.length}]`, statusDescription.trim(), embedColors.progress) });
    }
    await statusMessage.edit({ embed: addEmbed(`Cleared ID [${oldPerm}]`, statusDescription.trim(), embedColors.success) });
    await updateNewPlayer(fivemexports, oldPerm, newPerm, statusMessage);
    message.channel.send({ embed: addEmbed(`Swap ID's`, `ID Swap completed successfully \nOld Perm ID: ${oldPerm}\nNew Perm ID: ${newPerm}`, 0xed4245) });
}

exports.conf = {
    name: "idswap",
    perm: 9,
    guild: "1195851569472741437",
}