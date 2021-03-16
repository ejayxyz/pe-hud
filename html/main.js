window.addEventListener("message", function (event) {
  switch (event.data.action) {
    case "hud":
      progress(event.data.health, ".health");
      progress(event.data.armor, ".armor");
      progress(event.data.stamina, ".stamina");
    break;
    
    case "showHide":
      $("body").fadeToggle();
    break;

  }
});

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