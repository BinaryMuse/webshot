express = require 'express'
{spawn} = require 'child_process'
url     = require 'url'
fs      = require 'fs'

getWebshot = (uri, cb) ->
  uri = "http://#{uri}" if uri.indexOf(":") == -1
  uriObj = url.parse(uri)
  uri = url.format(uriObj)

  now = new Date()
  tmpFile = "#{uriObj.hostname}-#{process.pid}-#{now.getTime()}.png"

  cmd = "phantomjs"
  args = ['../phantom-render.js', uri, tmpFile]
  proc = spawn cmd, args,
    cwd: "#{__dirname}/shots"

  proc.on 'exit', (code) ->
    if code == 0
      cb(null, "shots/#{tmpFile}")
    else
      cb("Couldn't capture", null)

app = express.createServer()

app.use express.static("#{__dirname}/public")

app.get '/', (req, res) ->
  res.render 'form.jade'

app.get '/webshot', (req, res) ->
  getWebshot req.param('webshot'), (err, filename) ->
    if err?
      res.end "Couldn't capture"
    else
      res.sendfile filename, (err) ->
        fs.unlink filename

app.listen 3456
