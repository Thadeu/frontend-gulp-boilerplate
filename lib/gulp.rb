require 'rubygems'
require 'fileutils'

class Gulp
  
  COMPONENTS = %w(
    gulp 
    gulp-ruby-sass 
    gulp-autoprefixer 
    gulp-minify-css 
    gulp-livereload 
    tiny-lr 
    gulp-util 
    gulp-coffee 
    gulp-concat 
    gulp-sourcemaps 
    babel-core
    babel-preset-es2015 
    gulp-babel
  )
    
  class << self
    def path(path)
      @@path = path
      self
    end
  
    def shell
      puts "\t\nConfigurando Gulp.........................................\n"
  		system("cd #{@@path} && sudo npm install --save-dev #{COMPONENTS.join(" ")}")
  		puts "#############################################################################"
  		puts "\n\t--Gulp e componentes instalados"
    end
    
    def create_file
  		FileUtils.touch("#{@@path}/gulpfile.js")
  		puts "\tcreate \t#{@@path}/gulpfile.js"
      self
    end
    
    def gulpfile
      self.create_file
      
  		f = File.new("#{@@path}/gulpfile.js", "a")
  		f.puts "//configuration gulp
  const gulp = require('gulp'),
    sass = require('gulp-ruby-sass'),
    prefix = require('gulp-autoprefixer'),
    minifycss = require('gulp-minify-css'),
    livereload = require('gulp-livereload'),
    server = require ('tiny-lr')(),
    gutil = require('gulp-util'),
    concat = require('gulp-concat'),
    babel = require('gulp-babel'),
    sourcemaps = require('gulp-sourcemaps'),
    coffee = require('gulp-coffee');

  //compilar arquivos sass,scss para css
  gulp.task('stylesheets',function(){
    sass('src/stylesheets/*.scss', {sourcemap: true})
    .pipe(concat('application.css'))
    .pipe(prefix('last 3 version'))
    .pipe(minifycss())
    .pipe(gulp.dest('app/assets/stylesheets'))
    .pipe(livereload({ start: true }));
  });

  gulp.task('coffee', function() {
    gulp.src('src/coffee/*.coffee')
      .pipe(coffee({bare: true}).on('error', gutil.log))
      .pipe(concat('coffee.js'))
      .pipe(gulp.dest('app/assets/javascripts'))
      .pipe(livereload({ start: true }));
  });

  gulp.task('es6', function() {
    gulp.src('src/es6/**/*.js')
      .pipe(sourcemaps.init())
      .pipe(babel({presets: ['es2015']}))
      .pipe(concat('application.js'))
      .pipe(sourcemaps.write('.'))
      .pipe(gulp.dest('app/assets/javascripts'))
      .pipe(livereload({ start: true }));
  });

  //abre o servidor para reload funcionar,
  //e ao mesmo tempo verifica os arquivos sass,scss, js para compilar
  gulp.task('watch', function() {
    livereload.listen();
    gulp.watch('src/stylesheets/*.scss', [
      'stylesheets'
    ]);

    gulp.watch('src/coffee/*.coffee', [
      'coffee'
    ]);

    gulp.watch('src/es6/*.js', [
      'es6'
    ]);
  });
  "
  		f.close unless f.closed? 
    end
  end
end