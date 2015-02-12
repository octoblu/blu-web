var gulp         = require('gulp'),
  bower          = require('gulp-bower'),
  mainBowerFiles = require('main-bower-files'),
  concat         = require('gulp-concat'),
  jsoncombine    = require('gulp-jsoncombine'),
  less           = require('gulp-less'),
  plumber        = require('gulp-plumber'),
  sourcemaps     = require('gulp-sourcemaps'),
  nodemon        = require('gulp-nodemon'),
  coffee         = require('gulp-coffee'),
  clean          = require('gulp-clean'),
  _              = require('lodash');

gulp.task('bower', function() {
  bower('./public/lib');
});

gulp.task('bower:concat', ['bower'], function(){
  return gulp.src(mainBowerFiles({filter: /\.js$/}))
    .pipe(plumber())
    .pipe(sourcemaps.init())
      .pipe(concat('dependencies.js'))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('./public/assets/dist/'));
});


gulp.task('coffee:clean', function(){
  return gulp.src(['./app/compiled'], {read: false})
    .pipe(clean())
})

gulp.task('coffee:compile', ['coffee:clean'], function(){
  return gulp.src(['./public/angular/**/*.coffee'])
    .pipe(plumber())
      .pipe(coffee({bare: true}))
    .pipe(gulp.dest('./public/compiled/'));
});

gulp.task('javascript:concat', ['coffee:compile'], function(){
  return gulp.src(['./public/angular/app.js', './public/angular/**/*.js'])
    .pipe(plumber())
    .pipe(sourcemaps.init())
      .pipe(concat('application.js'))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('./public/assets/dist/'));
});

gulp.task('default', ['bower:concat', 'javascript:concat'], function() {});

gulp.task('watch', ['default'], function() {
  gulp.watch(['./bower.json'], ['bower']);
  gulp.watch(['./public/angular/**/*.js', './public/angular/*.js'], ['javascript:concat']);
  gulp.watch(['./public/angular/**/*.coffee', './public/angular/*.coffee'], ['coffee:compile']);

  nodemon({
    script : 'server.js',
    ext : 'js json coffee',
    watch : ['server.js', 'public/angular/*'],
    env: { 'NODE_ENV': 'development' }
  });
});
