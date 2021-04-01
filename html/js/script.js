window.addEventListener("message", function (event) {
  switch (event.data.action) {
    case "show":
      $("#drag-browser").fadeIn();
    break;
    
    case "hide":
      $("#drag-browser").fadeOut();
      break;

    case "hud":
      progress(event.data.health, ".health");
      progress(event.data.armor, ".armor");
      progress(event.data.stamina, ".stamina");
      progress(event.data.oxygen, ".oxygen");
      progress(event.data.players, ".id");
      $(".idnumber").text(event.data.id)
      $(".time").text(event.data.time)
    break;

    case "microphone":
      progress(event.data.microphone, ".microphone");
    break;
    
    case "healthT":
      $("#health").fadeToggle();
    break;

    case "test":
      $("#health").animate({
        top: "0px",
        left: "0px"
    });;

      $("#armor").animate({
        top: "0px",
        left: "0px"
      });;

    $("#stamina").animate({
      top: "0px",
      left: "0px"
    });;

    $("#oxygen").animate({
      top: "0px",
      left: "0px"
    });;

    $("#id").animate({
      top: "0px",
      left: "0px"
    });;

    $("#time").animate({
      top: "0px",
      left: "0px"
    });;

    $("#microphone").animate({
      top: "0px",
      left: "0px"
    });;
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
$("#reset").click(function() {$.post('https://pe-hud/reset')})

document.onkeyup = function (data) {
  if (data.which == 27) {
      $.post('https://pe-hud/close');
  }
};

function progress(percent, element) {
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
