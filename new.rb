#!/usr/bin/env ruby

require 'rubygems'
require 'fileutils'

# == Classe
# Esta é uma classe para geração de projeto front-end 
# para qualquer linguagem. Já com a inclusão de bootstrap, normalize, Gemfile
# Git e muitas outras ferramentas.
# ---
# 
# == Sobre o autor e licença
# 
# Autor:: Thadeu Esteves Jr.
# Website:: http://tadeuesteves.wordpress.com
# Email:: tadeuu@gmail.com
# Licença:: GPL
# --
# 
# ++
class Skeleton
	# Responsavel por capturar o parâmetro passado pelo terminal
	PATH_SKELETON = ARGV[0]

	# Parametro obrigatorio
	# == dir :: nome da pasta para criação
	# ex:
	# * app
	# * vendor
	# * lib
	# ---
	def self.make(dir)
		stylesheets = ["#{PATH_SKELETON}","#{dir}","assets","stylesheets"]
		javascript 	= ["#{PATH_SKELETON}","#{dir}","assets","javascripts"]
		images 			= ["#{PATH_SKELETON}","#{dir}","assets","images"]

		src_images 				= ["#{PATH_SKELETON}","src","images"]
		src_javascripts		= ["#{PATH_SKELETON}","src","javascripts"]
		src_stylesheets 	= ["#{PATH_SKELETON}","src","stylesheets"]
		
		#stylesheets
		FileUtils.mkdir_p(File.join(stylesheets))
		FileUtils.touch("#{File.join(stylesheets)}/application.css")
		puts "\tcreate \t#{File.join(stylesheets)}"
		puts "\tcreate \t#{File.join(stylesheets)}/application.css"
		puts "\n"

		#javascript
		FileUtils.mkdir_p(File.join(javascript))
		FileUtils.touch("#{File.join(javascript)}/application.js")
		puts "\tcreate \t#{File.join(javascript)}"
		puts "\tcreate \t#{File.join(javascript)}/application.js"
		puts "\n"

		#images
		FileUtils.mkdir_p(File.join(images))
		FileUtils.touch("#{File.join(images)}/empty")
		puts "\tcreate \t#{File.join(images)}"
		puts "\tcreate \t#{File.join(images)}/empty"
		puts "\n"

		#criar pastas para o gulpfile.js
		FileUtils.mkdir_p(File.join(src_images))
		puts "\tcreate \t#{File.join(src_images)}"

		FileUtils.mkdir_p(File.join(src_javascripts))
		puts "\tcreate \t#{File.join(src_javascripts)}"
		FileUtils.touch("#{File.join(src_javascripts)}/application.coffee")
		puts "\tcreate \t#{File.join(src_javascripts)}/aplication.coffee"
		
		FileUtils.mkdir_p(File.join(src_stylesheets))
		puts "\tcreate \t#{File.join(src_stylesheets)}"
		FileUtils.touch("#{File.join(src_stylesheets)}/application.scss")
		puts "\tcreate \t#{File.join(src_stylesheets)}/application.scss"
		puts "\n"

		#package.json
		FileUtils.touch("#{PATH_SKELETON}/package.json")
		self.create_package
		puts "\tcreate \t#{PATH_SKELETON}/package.json"

		#gulpfile.js
		FileUtils.touch("#{PATH_SKELETON}/gulpfile.js")
		self.create_gulpfile
		puts "\tcreate \t#{PATH_SKELETON}/gulpfile.js"
		
		#index.html
		FileUtils.touch("#{PATH_SKELETON}/index.html")
		self.create_html
		puts "\tcreate \t#{PATH_SKELETON}/index.html"
		puts "\n"

		#README.md
		FileUtils.touch("#{PATH_SKELETON}/README.md")
		self.create_readme
		puts "\tcreate \t#{PATH_SKELETON}/README.md"

		#configurando o gulpfile
		puts "\t\nConfigurando Gulp.........................................\n"
		
		#instala o gulp, componentes básicos e entra na pasta do projeto PATH_SKELETON
		system("cd #{PATH_SKELETON} && sudo npm install --save-dev gulp gulp-ruby-sass gulp-autoprefixer gulp-minify-css gulp-livereload tiny-lr gulp-util gulp-coffee gulp-concat")
		puts "#############################################################################"
		puts "\n\t--Gulp e componentes instalados"
    
    self.gitignore
    puts "\n\t-- .gitignore criado...."
    puts "#############################################################################"

		#inicia o git e escreve o primeiro commit
		system("cd #{PATH_SKELETON} && git init && git add . && git commit -am '[First Commit]'")
		puts "#############################################################################"
		puts "\t--Git iniciado e com primeiro comentário"
		puts "\t--Digite: `git status` para mais informações."

		#sobre o automatizador
		self.about
	end
  
  def self.gitignore
		f = File.new("#{PATH_SKELETON}/.gitignore", "a")
		f.puts "#no-versions
.DS_Store
/node_modules
.sass-cache
/tmp
.tmp
    "
		f.close unless f.closed?    
  end

	# Responsavel por criar o arquivo package.json
	def self.create_package
		f = File.new("#{PATH_SKELETON}/package.json", "a")
		f.puts "{}"
		f.close unless f.closed?
	end

	#responsavel pela leitura do arquivo package.json para imprimir no readme
	def self.read_package
		File.open("#{PATH_SKELETON}/package.json") do |f|
			puts File.read(f)
		end
	end

	#responsavel por adicionar as dependencias do gulp e crias as tasks do projeto para compilar css e o watch com livereload
	def self.create_gulpfile
		f = File.new("#{PATH_SKELETON}/gulpfile.js", "a")
		f.puts "//configuration gulp added
var gulp = require('gulp'),
  sass = require('gulp-ruby-sass'),
  prefix = require('gulp-autoprefixer'),
  minifycss = require('gulp-minify-css'),
  livereload = require('gulp-livereload'),
  server = require ('tiny-lr')(),
  gutil = require('gulp-util'),
  concat = require('gulp-concat'),
  coffee = require('gulp-coffee');

//compilar arquivos sass,scss para css
gulp.task('stylesheets',function(){
  sass('src/stylesheets/application.scss', {sourcemap: true})
  .pipe(prefix('last 3 version'))
  .pipe(minifycss())
  .pipe(gulp.dest('app/assets/stylesheets'))
  .pipe(livereload({ start: true }));
});

gulp.task('coffee', function() {
  gulp.src('src/javascripts/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(concat('application.js'))
    .pipe(gulp.dest('app/assets/javascripts'))
    .pipe(livereload({ start: true }));
});

//abre o servidor para reload funcionar, 
//e ao mesmo tempo verifica os arquivos sass,scss, js para compilar
gulp.task('watch', function() {
  livereload.listen();
  gulp.watch('src/stylesheets/**/*.{sass,scss}', [
    'stylesheets'
  ]);

  gulp.watch('src/javascripts/*.coffee', [
    'coffee'
  ]);
});
"
		f.close unless f.closed?
	end

	# responsavel por criar o arquivo index.html e escrever dentro o doctype e links para os styles e scripts
	def self.create_html
		f = File.new("#{PATH_SKELETON}/index.html", "a")
		f.puts "<!doctype html>
<html lang=\"en\">
<head>
	<!-- METAS -->
	<meta charset=\"UTF-8\">
	<!-- CSS -->
	<link rel=\"stylesheet\" href=\"app/assets/stylesheets/application.css\">
	<!-- TITLE -->
	<title>Teste de gulp automatizado com Ruby</title>
</head>
<body>
	
  <!-- JS -->
  <script src=\"app/assets/javascripts/application.js\"></script>
</body>
</html>"
		f.close unless f.closed?
	end

	#responsavel por escrever o README do projeto
	def self.create_readme
		f = File.new("#{PATH_SKELETON}/README.md", "a")
		f.puts "### Projeto #{PATH_SKELETON}
Projeto Open source para comunidade Front-End/Back-end que utiliza o Gulp como automatizador de tarefas e componentes.
Agora é só rodar o gulp.

Digite: 'gulp watch' e ative a extensão LiveReload do Chrome Browser.
		
### LICENÇA E CRÉDITOS
Criado por Thadeu Esteves Jr.
Email: tadeuu@gmail.com
Blog: http://tadeuesteves.wordpress.com
Site: http://thadeuesteves.com.br
Licença: Livre GPL para uso e distruibuição.
"
		f.close unless f.closed?
	end

	#responsavel pela mensagem de entraga do projeto já compilado ao usuario.
	#explicações básicas do projeto
	#dados do desenvolvedor do plugin.
	def self.about
		puts "#############################################################################"
		puts "Parabéns, \nvocê terminou de gerar um projeto com gulp-frontend-generator"
		
		puts "Projeto Open source para comunidade Front-End/Back-end \nque utiliza o Gulp como automatizador de tarefas e componentes."
		puts "\nAgora é só rodar o gulp."
		
		puts "Entre no projeto `cd #{PATH_SKELETON}`"
		puts "Digite: 'gulp watch' e ative o LiveReload do navegador Chrome"

		puts "Edite o arquivo `#{PATH_SKELETON}/src/stylesheets/main.scss` e seja feliz."

		puts "\nDependências instaladas..."
		self.read_package
		
		puts "\n--Créditos--"
		puts "\nCriado por Thadeu Esteves Jr."
		puts "Email: tadeuu@gmail.com"
		puts "Blog: http://tadeuesteves.wordpress.com"
		puts "Site: http://thadeuesteves.com.br"
		puts "#############################################################################"
	end
end

ARGV.each do |a|	
	Skeleton.make('app')
end