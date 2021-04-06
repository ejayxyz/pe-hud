window.addEventListener("message", function (event) {
  switch (event.data.action) {
    case "show":
      $("#drag-browser").fadeIn();
    break;
    
    case "hide":
      $("#drag-browser").fadeOut();
    break;

    case "hud":
      progressCircle(event.data.health, ".health");
      progressCircle(event.data.armor, ".armor");
      progressCircle(event.data.stamina, ".stamina");
      progressCircle(event.data.oxygen, ".oxygen");
      progressCircle(event.data.players, ".id");
      $(".idnumber").text(event.data.id)
      $(".time").text(event.data.time)
    break;

    case "microphone":
      progressCircle(event.data.microphone, ".microphone");
    break;
    
    case "healthT":
      $("#health").fadeToggle();
    break;

    case "armorT":
      $("#armor").fadeToggle();
    break;

    case "staminaT":
      $("#stamina").fadeToggle();
    break;

    case "oxygenT":
      $("#oxygen").fadeToggle();
    break;

    case "idT":
      $("#id").fadeToggle();
    break;

    case "movieT":
      $("#movie").fadeToggle();
    break;

    case "timeT":
      $("#time").fadeToggle();
    break;

    case "microphoneT":
      $("#microphone").fadeToggle();
    break;
  }
});

$(function() {
  $('#color-block').on('colorchange', function() {
    let color = $(this).wheelColorPicker('value')
    switch ($("#selection").val()) {
      case "health-option":
        $('#health-circle').css('stroke', color);
      break;

      case "shield-option":
        $('#armor-circle').css('stroke', color);
      break;

      case "stamina-option":
        $('#stamina-circle').css('stroke', color);
      break;

      case "oxygen-option":
        $('#oxygen-circle').css('stroke', color);
      break;

      case "microphone-option":
        $('#microphone-circle').css('stroke', color);
      break;

      case "id-option":
        $('#id-circle').css('stroke', color);
      break;

      case "time-option":
        $('#time').css('color', color);
      break;
    };
  });
});

$("#health-switch").click(function() { $.post('https://pe-hud/change', JSON.stringify({action: 'health'}));})
$("#armor-switch").click(function() {$.post('https://pe-hud/change', JSON.stringify({action: 'armor'}));})
$("#stamina-switch").click(function() {$.post('https://pe-hud/change', JSON.stringify({action: 'stamina'}));})
$("#oxygen-switch").click(function() {$.post('https://pe-hud/change', JSON.stringify({action: 'oxygen'}))})
$("#map-switch").click(function() {$.post('https://pe-hud/change', JSON.stringify({action: 'map'}))})
$("#id-switch").click(function() {$.post('https://pe-hud/change', JSON.stringify({action: 'id'}))})
$("#movie-switch").click(function() {$.post('https://pe-hud/change', JSON.stringify({action: 'movie'}))})
$("#time-switch").click(function() {$.post('https://pe-hud/change', JSON.stringify({action: 'time'}))})
$("#microphone-switch").click(function() {$.post('https://pe-hud/change', JSON.stringify({action: 'microphone'}))})
$("#close").click(function() {$.post('https://pe-hud/close')})
$("#reset").click(function() {$("#drag-browser").animate({top: "", left: "50%"});})

$("#reset-position").click(function() {
  $("#health").animate({top: "0px", left: "0px"});
  $("#armor").animate({top: "0px", left: "0px"});
  $("#stamina").animate({top: "0px", left: "0px"});
  $("#oxygen").animate({top: "0px", left: "0px"});
  $("#id").animate({top: "0px", left: "0px"});
  $("#time").animate({top: "0%", left: "50%"});
  $("#microphone").animate({top: "0px", left: "0px"});
});

$("#reset-color").click(function() {
  $('#health-circle').css('stroke', '');
  $('#armor-circle').css('stroke', '');
  $('#stamina-circle').css('stroke', '');
  $('#oxygen-circle').css('stroke', '');
  $('#microphone-circle').css('stroke', '');
  $('#id-circle').css('stroke', '');
  $('#time').css('color', '');
});

$(function() {
  $('#color-block').on('colorchange', function() {
      let color = $(this).wheelColorPicker('value');
      let alpha = $(this).wheelColorPicker('color').a;
      $('.color-preview-box').css('background-color', color);
      $('.color-preview-alpha').text(Math.round(alpha * 100) + '%');
  });
});

document.onkeyup = function(event) {
  if (event.key == 'Escape') {
      $.post('https://pe-hud/close');
  }
};

function progressCircle(percent, element) {
  const circle = document.querySelector(element);
  const radius = circle.r.baseVal.value;
  const circumference = radius * 2 * Math.PI;
  const html = $(element).parent().parent().find("span");

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent * 100) / 100 / 100) * circumference;
  circle.style.strokeDashoffset = -offset;

  html.text(Math.round(percent));
}
