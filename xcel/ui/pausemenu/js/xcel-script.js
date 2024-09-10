window.addEventListener('message', function(event) {
    var data = event.data;
    let date = new Date();
    let day = String(date.getDate()).padStart(2, '0');
    let month = String(date.getMonth() + 1).padStart(2, '0');
    let year = date.getFullYear();
    let hours = String(date.getHours()).padStart(2, '0');
    let minutes = String(date.getMinutes()).padStart(2, '0');
    let seconds = String(date.getSeconds()).padStart(2, '0');
    let currentTime = hours + ':' + minutes;
    let currentDate = day + '/' + month + '/' + year + ' ' + currentTime;

    if (data.type === 'xcelTogglePauseMenu') {
        if (data.toggle === true) {
            document.getElementById('xcelRoot').style.display = "block";
            document.getElementById('todaysDate').innerText = currentDate;
            document.getElementById('xcelDLastName').innerText = data.xcelDLastName;
            document.getElementById('xcelDBirthdate').innerText = data.xcelDBirthdate;
            document.getElementById('xcelDGender').innerText = data.xcelDGender;
            document.getElementById('xcelPlrName').innerText = data.xcelPlrName;
            document.getElementById('totalPlayers').innerText = data.totalPlayers;
        }  else if (data.toggle === false) {
            document.getElementById('xcelRoot').style.display = "none";
        }
    }
});

var elements = document.querySelectorAll("#xcelCuBbox, #xcelconnect, #xcelPmRow, #xcelPmBox3, #xcelPmBox2, #xcelCsettings, #xcelCsButtons, #xcelComRules, #Store, #joinDiscord, #disupte, #xcelCdisconnect, #xcelCmap, .xcelPmNavCont, .xcelNavRow, .xcelPmBox2, .xcelPmBox3");

elements.forEach(function(element) {
    element.addEventListener('mouseenter', function() {
        var audio = new Audio('./sounds/hover.mp3');
        audio.volume = 0.3;
        audio.play();
    });
});

$('#xcelCsettings').click(function(){
    $.post('https://xcel/Settings', JSON.stringify({}), function(data) {
    });
});

$('#Store').click(function(){
    $.post('https://xcel/Store', JSON.stringify({}), function(data) {
    });
});

$('#xcelCuBbox').click(function(){
    $.post('https://xcel/Guide', JSON.stringify({}), function(data) {
    });
});

$('#twitter').click(function(){
    $.post('https://xcel/Twitter', JSON.stringify({}), function(data) {
    });
});

$('#dispute').click(function(){
    $.post('https://xcel/Dispute', JSON.stringify({}), function(data) {
    });
});

$('#xcelconnect').click(function(){
    $.post('https://xcel/DeathMatchF8', JSON.stringify({}), function(data) {
    });
});

$('#joinDiscord').click(function(){
    $.post('https://xcel/DeathMatchDiscord', JSON.stringify({}), function(data) {
    });
});

$('#website').click(function(){
    $.post('https://xcel/Website', JSON.stringify({}), function(data) {
    });
});

$('#xcelCuBbox').click(function(){
    $.post('https://xcel/Guide', JSON.stringify({}), function(data) {
    });
});

$('#xcelPmBox3').click(function(){
    $.post('https://xcel/ComRules', JSON.stringify({}), function(data) {
    });
});

$('#xcelPmBox2').click(function(){
    $.post('https://xcel/Rules', JSON.stringify({}), function(data) {
    });
});
$('#xcelCmap').click(function(){
    $.post('https://xcel/Map', JSON.stringify({}), function(data) {
    });
});
$('#xcelCdisconnect').click(function(){
    $.post('https://xcel/Disconnect', JSON.stringify({}), function(data) {
    });
});

window.addEventListener('keydown', function(event) {
    if (event.key === "Escape") {
        $.post('https://xcel/Close', JSON.stringify({}), function(data) {});
        document.getElementById('xcelRoot').style.display = "none";
    }
});