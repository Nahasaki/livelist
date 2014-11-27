express = require("express")
app = express()
bodyParser = require("body-parser")
methodOverride = require("method-override")
jade = require("jade")
Datastore = require("nedb")


app.use express["static"](__dirname + "/public")
# app.set "views", __dirname + "/public"
# app.set "view engine", "jade"

app.use bodyParser.urlencoded(extended: "true")
app.use bodyParser.json()
app.use bodyParser.json(type: "application/vdn.api+json")
app.use methodOverride()

db = new Datastore(filename: 'data/list.db')
db.loadDatabase (err) ->
  if err
    console.log 'Error loading database:'
    console.log err
  else
    console.log 'Database loaded'

# db.insert
#   appId: 'abada'
#   index: 'abada'
#   name: 'abada'
#   source: 'abada'
#   title: 'abada'
#   duration: 'abada'
#   description: 'abada'
#   position: 'abada'
#   readyStatus: 'abada'
#   moved: 'abada'
# , (err, newDoc) ->
#   if err
#     console.log 'Error inserting to db'
#     console.log err
#   else
#     console.log 'Inserted new object:'
#     console.log newDoc

app.listen 8080
console.log "App listening on port 8080"
listReturn = (res) ->
  db.find {}, (err, items) ->
    console.log "list return"
    res.send err  if err
    res.json items
    console.log items
    return
  return


app.get "/api/list", (req, res) ->
  console.log "list get"
  listReturn res
  return


app.post "/api/list/add", (req, res) ->
  db.insert
    appId: req.body.appId
  #   index: req.body.index
    name: req.body.name
    source: req.body.source
    title: req.body.title
    duration: req.body.duration
    description: req.body.description
    # position: req.body.position
  #   readyStatus: req.body.readyStatus
  #   moved: req.body.moved
  , (err, item) ->
    res.send err  if err
    listReturn res
    return
  return

app.post "/api/list/update", (req, res) ->
  console.log req.body
  queue = 0
  errors = []
  req.body.forEach (item) ->
    queue++
    db.update
      _id: item._id
    ,
      $set: item.props
    , {}, (err, item) ->
      if err
        # res.send err
        errors.push err
      if (--queue == 0)
        res.send errors if errors.length
        console.log 'queue end'
        listReturn res

app.post "/api/list/move", (req, res) ->
  # req.body._id
  # req.body.direction

  db.findOne _id: req.body._id, (err, item) ->
    if err
      res.send.err
      return
    db.update {position: item.position - 1}, {position: item.position}, {}, (err, numReplaced) ->
      if err
        res.send.err
        return
      db.update {_id: req.body._id}, {position: item.position - 1}




app.put "/api/list/update:_id", (req, res) ->
  db.update
    _id: req.params._id.slice(1)
  , 
    $set:
      appId: req.body.appId
      # index: req.body.index
      name: req.body.name
      source: req.body.source
      title: req.body.title
      duration: req.body.duration
      description: req.body.description
      position: req.body.position
      # readyStatus: req.body.readyStatus
      # moved: req.body.moved
  , {}, (err, numReplaced) ->
    res.send err if err
    listReturn res
    return
  return




app.get "/", (req, res) ->
  res.sendfile "./public/index.html"
  return
