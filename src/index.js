import { Elm } from './Main.elm'
import registerServiceWorker from './registerServiceWorker'
import 'webaudiofont'
import '@fortawesome/fontawesome-free/js/fontawesome'
import '@fortawesome/fontawesome-free/js/solid'
import '@fortawesome/fontawesome-free/js/regular'

const app = Elm.Main.init({
  node: document.getElementById('root')
})

const AudioContextFunc = window.AudioContext || window.webkitAudioContext
const audioContext = new AudioContextFunc()
const player = new WebAudioFontPlayer()

app.ports.stop.subscribe(function () {
  player.cancelQueue(audioContext)
})

app.ports.play.subscribe(function (data) {
  data.instruments.forEach(function (instrument) {
    const info = player.loader.instrumentInfo(instrument)
    player.loader.startLoad(audioContext, info.url, info.variable)
  })

  player.loader.waitLoad(function () {
    player.cancelQueue(audioContext)

    const startTime = audioContext.currentTime + 0.2

    data.events.forEach(function (event) {
      const info = player.loader.instrumentInfo(event.instrument)
      const time = startTime + event.time
      player.queueWaveTable(audioContext, audioContext.destination, window[info.variable], time, event.pitch, event.duration, event.volume)
    })
  })

  return false
})

registerServiceWorker()
