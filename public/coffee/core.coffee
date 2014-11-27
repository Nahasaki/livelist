livelist = angular.module 'livelist', ['ui.sortable']

livelist.controller 'mainController', ($scope, $http) ->
  $scope.newItem = {}

  $http.get 'api/list'
    .success (data) ->
      fillItems(data)
    .error (err) ->
      console.log 'Error: ' + err

  fillItems = (data) ->
    data.sort (a, b) ->
      a = a.position
      b = b.position
      return 1  if a > b
      return -1  if a < b
      0
    console.log data
    $scope.items = data
    console.log $scope.items

  bulkUpdate = (items) ->
    $http.post 'api/list/update', items
      .success (data) ->
        console.log data
        fillItems(data)
      .error (err) ->
        console.log 'Error: ' + err

  $scope.sortItems = ->
    i = 0
    order = []
    $scope.items.forEach (item) ->
      item.position = ++i
      order.push(_id: item._id, props: position: item.position)
    bulkUpdate order

  $scope.createNewItem = ->
    $http.post 'api/list/add', $scope.newItem
      .success (data) ->
        $scope.newItem = {}
        fillItems(data)
      .error (err) ->
        console.log 'Error: ' + err

  $scope.moveItem = (item, direction) ->
    $http.post 'api/list/move', 
      _id: item._id
      direction: direction
      .success (data) ->
        fillItems(data)

  $scope.sortable =
    orderChanged: (event) ->
      console.log 'moved'

  return

### READY ###
$(document).ready ->
  $('.new-app-button').click ->
    $('.new-app-sidebar').sidebar 'toggle'
