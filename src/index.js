import { Elm } from './Main.elm'
import registerServiceWorker from './registerServiceWorker'
import 'webaudiofont'


const app = Elm.Main.init({
  node: document.getElementById('root')
})

const AudioContextFunc = window.AudioContext || window.webkitAudioContext
const audioContext = new AudioContextFunc()
const player = new WebAudioFontPlayer()
player.loader.decodeAfterLoading(audioContext, '_tone_0250_SoundBlasterOld_sf2')

app.ports.play.subscribe(function (data) {
  player.cancelQueue(audioContext)

  data.forEach(function (entry) {
    const vol = entry.eVol / 127
    const startTime = audioContext.currentTime + 0.1 + entry.eTime
    player.queueWaveTable(audioContext, audioContext.destination, _tone_0250_SoundBlasterOld_sf2, startTime, entry.ePitch, entry.eDur, vol)
  })
  
  return false
})

registerServiceWorker()
