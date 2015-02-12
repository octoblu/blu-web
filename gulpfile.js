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
  bower('./app/lib');
});

gulp.task('bower:concat', ['bower'], function(){
  return gulp.src(mainBowerFiles({filter: /\.js$/}))
    .pipe(plumber())
    .pipe(sourcemaps.init())
      .pipe(concat('dependencies.js'))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('./app/dist/'));
});


gulp.task('coffee:clean', function(){
  return gulp.src(['./app/compiled'], {read: false})
    .pipe(clean())
})

gulp.task('coffee:compile', ['coffee:clean'], function(){
  return gulp.src(['./app/**/*.coffee'])
    .pipe(plumber())
      .pipe(coffee({bare: true}))
    .pipe(gulp.dest('./app/compiled/'));
});

gulp.task('javascript:concat', ['coffee:compile'], function(){
  return gulp.src(['./app/app.js', './app/**/*.js'])
    .pipe(plumber())
    .pipe(sourcemaps.init())
      .pipe(concat('application.js'))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('./app/dist/'));
});

gulp.task('default', ['bower:concat', 'javascript:concat'], function() {});

gulp.task('watch', ['default'], function() {
  gulp.watch(['./bower.json'], ['bower']);
  gulp.watch(['./app/**/*.js', './app/*.js'], ['javascript:concat']);
  gulp.watch(['./app/**/*.coffee', './app/*.coffee'], ['coffee:compile']);

  nodemon({
    script : 'server.js',
    ext : 'js json coffee',
    watch : ['server.js', 'app/*'],
    env: { 'NODE_ENV': 'development' }
  });
});
