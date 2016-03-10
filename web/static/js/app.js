import {Socket} from "phoenix"

// let socket = new Socket("/ws")
// socket.connect()
// let chan = socket.chan("topic:subtopic", {})
// chan.join().receive("ok", chan => {
//   console.log("Success!")
// })
import React from "react"
import ReactDOM from "react-dom"
import HelloReact from "./react_example"

ReactDOM.render(
  <HelloReact/>,
  document.getElementById("react-example")
);
