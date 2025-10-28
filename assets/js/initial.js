const css = $(`
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <link rel="shortcut icon" href="/icon.png" type="image/x-icon">
   <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
   <link rel="stylesheet" href="/assets/css/initial.css">
   <link rel="stylesheet" href="/assets/css/projects.css">
   <title>Ocean</title>
`)

$('head').append(css)

const prevHTML = $("body").html()
const newHTML = $(`
   <div id="top">
      <img src="/assets/images/pfp.png" alt="">
      <div id="popup" class="hide">
         <strong>Stuff i have</strong>
         <button redirect="https://www.youtube.com/@Ocean10230">
            <i class='bx bxl-youtube'></i>
            Youtube
         </button>

         <button redirect="https://www.roblox.com/users/3013334798/profile?">
            <img src="/assets/images/roblox.png" alt="">
            Roblox
         </button>

         <button>
            <i class='bx bxl-discord-alt' style='color:#ffffff' ></i>
            @ocean10230
         </button>
      </div>
   </div>
   <div style="margin-bottom: 150px;"></div>

   ${prevHTML}
`)

$("body").html(newHTML)

newHTML.find("button[redirect]").click(function() {
   const url = $(this).attr("redirect")
   const a = document.createElement("a")
   a.href = url
   a.target = "_blank"
   a.click()
   a.remove()
})

newHTML.find("img").click(function() {
   $("#popup").toggleClass("show")
   $("#popup").toggleClass("hide")
})