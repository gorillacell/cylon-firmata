require "cylon"
os = require('os')
path = require('path')

firmata =
  upload: (serialPort, hexFile) ->
    cylonProcess = new Cylon.Process
    part = '-patmega328p'
    programmer = '-carduino'
    baudrate = '-b115200'
    hexPath = path.join __dirname, "../../src/cli/hex/StandardFirmata.cpp.hex"
    hexFile = if (hexFile == null || hexFile == undefined) then "-Uflash:w:#{ hexPath }:i" else hexFile
    port = if (serialPort.search(/[\/\:]/) >= 0) then "-P#{ serialPort }" else "-P/dev/#{ serialPort }"

    switch(os.platform())
      when 'linux'
        cylonProcess.spawn('avrdude', [part, programmer, port, baudrate, '-D', hexFile])
      when 'darwin'
        cylonProcess.spawn('avrdude', [part, programmer, port, baudrate, '-D', hexFile])
      else
        console.log('OS not yet supported...\n')

  install: ->
    cylonProcess = new Cylon.Process
    switch(os.platform())
      when 'linux'
        cylonProcess.exec('sudo apt-get install avrdude')
      when 'darwin'
        cylonProcess.exec('brew install avrdude')
      else
        console.log('OS not yet supported...\n')
    true

module.exports = firmata