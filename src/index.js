import { Elm } from './Main.elm'
import registerServiceWorker from './registerServiceWorker'
import 'webaudiofont'

const app = Elm.Main.init({
  node: document.getElementById('root')
})

const AudioContextFunc = window.AudioContext || window.webkitAudioContext
const audioContext = new AudioContextFunc()
const player = new WebAudioFontPlayer()

// for(var i = 0; i < player.loader.instrumentKeys().length; i++) {
//   var info = player.loader.instrumentInfo(i)
//   console.log(i +", " + info.title, info.variable )
// }

app.ports.play.subscribe(function (data) {
  const info = player.loader.instrumentInfo(45)
  player.loader.startLoad(audioContext, info.url, info.variable)

  player.loader.waitLoad(function () {
    player.cancelQueue(audioContext)

    const startTime = audioContext.currentTime + 0.2

    data.forEach(function (entry) {
      const vol = entry.eVol / 127
      const eTime = startTime + entry.eTime
      player.queueWaveTable(audioContext, audioContext.destination, window[info.variable], eTime, entry.ePitch, entry.eDur, vol)
    })
  })

  return false
})

registerServiceWorker()
