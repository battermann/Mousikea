import { Elm } from './Main.elm'
import registerServiceWorker from './registerServiceWorker'
import 'webaudiofont'

var AudioContextFunc = window.AudioContext || window.webkitAudioContext

var app = Elm.Main.init({
  node: document.getElementById('root')
})

app.ports.play.subscribe(function (data) {
  var audioContext = new AudioContextFunc()
  var player = new WebAudioFontPlayer()
  player.loader.decodeAfterLoading(audioContext, '_tone_0250_SoundBlasterOld_sf2')

  data.forEach(function (entry) {
    console.debug(entry)
    player.queueWaveTable(audioContext, audioContext.destination, _tone_0250_SoundBlasterOld_sf2, entry.eTime, entry.ePitch, entry.eDur)
  })
  player = null
  audioContext = null
  return true
})

registerServiceWorker()
