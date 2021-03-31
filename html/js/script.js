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
      $(".idnumber").text(event.data.id)
      $(".time").text(event.data.time)
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

  }
});

$("#health-switch").click(function() { $.post('https://pe-hud/change', JSON.stringify({action: 'health'})); return;})
$("#armor-switch").click(function() {$.post('https://pe-hud/change', JSON.stringify({action: 'armor'})); return;})
$("#stamina-switch").click(function() {$.post('https://pe-hud/change', JSON.stringify({action: 'stamina'})); return;})
$("#oxygen-switch").click(function() {$.post('https://pe-hud/change', JSON.stringify({action: 'oxygen'})); return;})
$("#map-switch").click(function() {$.post('https://pe-hud/change', JSON.stringify({action: 'map'})), console.log("TEST");})
$("#id-switch").click(function() {$.post('https://pe-hud/change', JSON.stringify({action: 'id'})), console.log("TEST");})
$("#movie-switch").click(function() {$.post('https://pe-hud/change', JSON.stringify({action: 'movie'})), console.log("TEST");})
$("#time-switch").click(function() {$.post('https://pe-hud/change', JSON.stringify({action: 'time'})), console.log("TEST");})
$("#close").click(function() {$.post('https://pe-hud/close'), console.log("TEST")})


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