'use strict'

require('materialize-css/dist/css/materialize.css')
require('materialize-css/dist/js/materialize.js')

require('./index.html')

let Elm = require('./Main.elm')
let mountNode = document.getElementById('main')

let app = Elm.Main.embed(mountNode)
