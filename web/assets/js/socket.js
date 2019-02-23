// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "./phoenix.js"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("cam:pictures", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("picture", msg => {
  var base64 = msg.base64
  document.getElementById("latest_picture").setAttribute("src", "data:image/jpeg;base64, " + base64)
  var date = new Date(msg.timestamp)
  document.getElementById("latest_time").innerText = date.toLocaleTimeString()
})

export default socket
