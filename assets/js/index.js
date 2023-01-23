// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

let liveSocket = new LiveSocket("/live", Socket, {
    params: { _csrf_token: csrfToken }
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

window.liveSocket = liveSocket

setTimeout(() => {
    let radugaEl = document.getElementsByClassName("raduga")[0]
    let randomColors = ["#8f300e", "#0e2c8f", "#3d8f0e", "#710e8f", "#8f6a0e"]
    let randomColor = randomColors[Math.floor(Math.random() * randomColors.length)]
    radugaEl.style.backgroundColor = randomColor
    radugaEl.classList.add("animate-hue")
}, 3000)

liveSocket.connect()