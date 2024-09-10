$(document).ready(function() {
    window.addEventListener("message", function(event) {
        if (event.data.updateMoney === true) {
            positionHud(event.data.topLeftAnchor);
            setMoney(event.data.cash, "#cash-text");
            setMoney(event.data.bank, "#bank-text");
            setMoney(event.data.redmoney,'#dirtycash-text');
            if (event.data.redmoney === "£0") {
              document.getElementById("dirtycash").style.display = "none";
            } else {
              document.getElementById("dirtycash").style.display = "block";
            }
            $("#user_id").text(event.data.hours + " hours");
            document.getElementById("proximity").innerHTML = event.data.proximity;
        }
        if (event.data.setPFP) {
          setProfilePicture(event.data.setPFP);
        }
        if (event.data.moneyTalking === true) {
          document.getElementById("proximity").style.color = "lightblue";
        } else if (event.data.moneyTalking === false) {
          document.getElementById("proximity").style.color = "white";
        }
        if (event.data.showMoney === false) {
          document.getElementById("proximity").style.display = "none";
          document.getElementById("cash-text").style.display = "none";
          document.getElementById("bank-text").style.display = "none";
          document.getElementById("bighudfam").style.display = "none";
        }
        if (event.data.showMoney === true) {
          document.getElementById("proximity").style.display = "block";
          document.getElementById("cash-text").style.display = "block";
          document.getElementById("bank-text").style.display = "block";
          document.getElementById("bighudfam").style.display = "block";
        }
    });
  
    function setMoney(amount, element) {
        $(element).text(amount);
    }
  
    function positionHud(topLeftAnchor) {
      $(".money-hud").css("left", topLeftAnchor + "px");
      // $( ".hud" ).css( "top", yAnchor + "px" );
    }
  
    function setProfilePicture(url) {
      if (url !== "None") {
        document.getElementById("profile-pic").src = url;
        document.getElementById("profile-pic").style.display = "block";
      } else {
        document.getElementById("profile-pic").style.display = "none";
      }
    }
  
    function updateClock() {
        var now = new Date(),
            time = (now.getHours() < 10 ? "0" : "") + now.getHours() + ":" + (now.getMinutes() < 10 ? "0" : "") + now.getMinutes();
  
        document.getElementById("hour").innerHTML = time;
        setTimeout(updateClock, 1000);
    }
  
    updateClock();
    $.post("https://xcel/moneyUILoaded", JSON.stringify({}));
  });