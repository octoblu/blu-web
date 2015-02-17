gulp           = require 'gulp'
bower          = require 'gulp-bower'
concat         = require 'gulp-concat'
jsoncombine    = require 'gulp-jsoncombine'
less           = require 'gulp-less'
plumber        = require 'gulp-plumber'
sourcemaps     = require 'gulp-sourcemaps'
coffee         = require 'gulp-coffee'
clean          = require 'gulp-clean'
webserver      = require 'gulp-webserver'
_              = require 'lodash'
mainBowerFiles = require 'main-bower-files'

gulp.task 'bower', ->
  bower './public/lib'

gulp.task 'bower:concat', ['bower'], ->
  gulp.src mainBowerFiles filter: /\.js$/
      .pipe plumber()
      .pipe sourcemaps.init()
      .pipe concat('dependencies.js')
      .pipe sourcemaps.write('.')
      .pipe gulp.dest('./public/assets/dist/')

gulp.task 'coffee:compile', ->
  gulp.src ['./app/**/*.coffee']
      .pipe plumber()
      .pipe coffee()
      .pipe concat('application.js')
      .pipe sourcemaps.write('.')
      .pipe gulp.dest('./public/assets/dist/')

gulp.task 'webserver', ->
  gulp.src './public'
      .pipe webserver({
        port: 8888
        livereload: true
        directoryListing: false
        open: false
      })

gulp.task 'default', ['bower:concat', 'coffee:compile'], ->

gulp.task 'watch', ['default', 'webserver'], ->
  gulp.watch ['./bower.json'], ['bower']
  gulp.watch ['./public/app/**/*.js'], ['javascript:concat']
  gulp.watch ['./app/**/*.coffee'], ['coffee:compile']
