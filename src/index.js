'use strict'

require('ace-css/ace.css')
require('font-awesome/css/font-awesome')

require('./index.html')

let Elm = require('./Main.elm')
let mountNode = document.getElementById('main')

let app = Elm.Main.embed(mountNode)
