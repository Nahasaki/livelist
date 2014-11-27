gulp = require 'gulp'
coffee = require 'gulp-coffee'
jade = require 'gulp-jade'
gutil = require 'gulp-util'
nodemon = require 'gulp-nodemon'
stylus = require 'gulp-stylus'
concat = require 'gulp-concat'
refresh = require 'gulp-livereload'
kouto = require 'kouto-swiss'


### PREPROCESSORS ###

gulp.task 'compile-coffee-back', ->
	gulp.src 'server.coffee'
		.pipe coffee(bare: true)
		.on 'error', gutil.log
		.pipe gulp.dest './'
		# .pipe refresh()

gulp.task 'compile-coffee-front', ->
	gulp.src 'public/coffee/*.coffee'
		.pipe coffee(bare: true)
		.on 'error', gutil.log
		.pipe gulp.dest 'public/js/'
		.pipe refresh()

gulp.task 'compile-jade', ->
	gulp.src 'public/jade/*.jade'
		.pipe jade()
		.on 'error', gutil.log
		.pipe gulp.dest 'public/'
		.pipe refresh()

gulp.task 'compile-stylus', ->
	gulp.src 'public/stylus/main.styl'
		.pipe stylus(
			use: [kouto()]
			linenos: true
			# compress: true
			)
		.on 'error', gutil.log
		.pipe gulp.dest 'public/css/'
		.pipe refresh()

gulp.task 'concat-js', ->
  gulp.src [
  	'public/bower_components/ng-sortable/dist/ng-sortable.js'
  ]
    .pipe concat 'master.js'
    .pipe gulp.dest 'public/js/'


### DEFAULT TASK ###

gulp.task 'default', [
	'compile-jade'
	'concat-js'
	'compile-stylus'
	'compile-coffee-front'
	'compile-coffee-back'
	], ->
	nodemon(script: 'server.js', ignore: ['public**'])
		.on 'restart', ->
			console.log 'Server restarted!'

	refresh.listen()

	gulp.watch 'server.coffee', ->
		gulp.run 'compile-coffee-back'

	gulp.watch 'public/coffee/*.coffee', ->
		gulp.run 'compile-coffee-front'

	gulp.watch 'public/jade/*.jade', ->
		gulp.run 'compile-jade'

	gulp.watch 'public/stylus/*.styl', ->
		gulp.run 'compile-stylus'

	# gulp.watch 'public/**'
	#   .on 'change', refresh.changed
