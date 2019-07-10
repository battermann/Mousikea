import './main.css'
import { Elm } from './Main.elm'
import registerServiceWorker from './registerServiceWorker'
import 'webaudiofont'

var player = new WebAudioFontPlayer()

Elm.Main.init({
  node: document.getElementById('root')
})

registerServiceWorker()
