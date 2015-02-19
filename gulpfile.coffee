gulp           = require 'gulp'
bower          = require 'gulp-bower'
concat         = require 'gulp-concat'
plumber        = require 'gulp-plumber'
sourcemaps     = require 'gulp-sourcemaps'
coffee         = require 'gulp-coffee'
webserver      = require 'gulp-webserver'
_              = require 'lodash'
mainBowerFiles = require 'main-bower-files'

gulp.task 'bower', ->
  bower './lib'

gulp.task 'bower:concat', ['bower'], ->
  gulp.src mainBowerFiles filter: /\.js$/
      .pipe plumber()
      .pipe sourcemaps.init()
      .pipe concat('dependencies.js')
      .pipe sourcemaps.write('.')
      .pipe gulp.dest('./public/assets/dist/')

gulp.task 'bower:css', ['bower'], ->
  gulp.src [ './lib/angular-material/angular-material.css']
      .pipe gulp.dest('./public/assets/dist/')

gulp.task 'coffee:compile', ->
  gulp.src './app/**/*.coffee'
      .pipe plumber()
      .pipe coffee()
      .pipe concat('application.js')
      .pipe sourcemaps.write('.')
      .pipe gulp.dest('./public/assets/dist/')

gulp.task 'webserver', ->
  gulp.src './public'
      .pipe webserver({
        port: 8888
        livereload: false
        directoryListing: false
        open: false
      })

gulp.task 'default', ['bower:concat', 'bower:css', 'coffee:compile'], ->

gulp.task 'watch', ['default', 'webserver'], ->
  gulp.watch ['./bower.json'], ['bower:concat', 'bower:css']
  gulp.watch ['./public/app/**/*.js'], ['javascript:concat']
  gulp.watch ['./app/**/*.coffee'], ['coffee:compile']
