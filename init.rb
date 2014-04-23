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
		src_scripts 			= ["#{PATH_SKELETON}","src","scripts"]
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

		FileUtils.mkdir_p(File.join(src_scripts))
		puts "\tcreate \t#{File.join(src_scripts)}"
		FileUtils.touch("#{File.join(src_scripts)}/application.js")
		puts "\tcreate \t#{File.join(src_scripts)}/aplication.js"
		
		FileUtils.mkdir_p(File.join(src_stylesheets))
		puts "\tcreate \t#{File.join(src_stylesheets)}"
		FileUtils.touch("#{File.join(src_stylesheets)}/main.scss")
		puts "\tcreate \t#{File.join(src_stylesheets)}/main.scss"
		puts "\n"

		#package.json
		FileUtils.touch("#{PATH_SKELETON}/package.json")
		self.create_package
		puts "\tcreate \t#{PATH_SKELETON}/package.json"

		#gulpfile.js
		FileUtils.touch("#{PATH_SKELETON}/gulpfile.js")
		self.create_gulpfile
		puts "\tcreate \t#{PATH_SKELETON}/gulpfile.js"
		
		#README.md
		FileUtils.touch("#{PATH_SKELETON}/README.md")
		self.create_readme
		puts "\tcreate \t#{PATH_SKELETON}/README.md"

		#index.html
		FileUtils.touch("#{PATH_SKELETON}/index.html")
		self.create_html
		puts "\tcreate \t#{PATH_SKELETON}/index.html"
		puts "\n"

		#configurando o gulpfile
		puts "\t\nConfigurando Gulp.........................................\n"
		
		#instala o gulp, componentes básicos e entra na pasta do projeto PATH_SKELETON
		system("cd #{PATH_SKELETON} && npm install --save-dev gulp gulp-ruby-sass gulp-autoprefixer gulp-minify-css gulp-livereload tiny-lr")
		puts "#############################################################################"
		puts "\n\t--Gulp e componentes instalados"

		#inicia o git e escreve o primeiro commit
		system("cd #{PATH_SKELETON} && git init && git add . && git commit -am '[First Commit]'")
		puts "#############################################################################"
		puts "\t--Git iniciado e com primeiro comentário"
		puts "\t--Digite: `git status` para mais informações."

		#sobre o automatizador
		self.about
	end

	# Responsavel por criar o arquivo package.json
	def self.create_package
		f = File.new("#{PATH_SKELETON}/package.json", "a")
		f.puts "{}"
		f.close unless f.closed?
	end

	#responsavel por adicionar as dependencias do gulp e crias as tasks do projeto para compilar css e o watch com livereload
	def self.create_gulpfile
		f = File.new("#{PATH_SKELETON}/gulpfile.js", "a")
		f.puts "//configuration gulp added
var gulp = require('gulp'),
    sass = require('gulp-ruby-sass'),
    prefix = require('gulp-autoprefixer'),
    minifycss = require('gulp-minify-css'),
    refresh = require('gulp-livereload'),
    server = require ('tiny-lr')();

gulp.task('compileStyles',function(){
    gulp.src('src/stylesheets/main.scss')
        .pipe(sass({
            noCache : true,
            precision : 4,
            unixNewlines : true
        }))
        .pipe(prefix('last 3 version'))
        .pipe(minifycss())
        .pipe(gulp.dest('app/assets/stylesheets'))
        .pipe(refresh(server));
});

gulp.task('watch', function() {
    server.listen(35729, function( err ) {
        if ( err ) { return console.log( err ); }
				
        gulp.watch('src/stylesheets/**/*.{sass,scss}', [
            'compileStyles'
        ]);
    });
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
	<link rel=\"stylesheet\" href=\"app/assets/stylesheets/main.css\">
	<!-- JS -->
	<script src=\"app/javascript/application.js\"></script>
	<!-- TITLE -->
	<title>Teste de gulp automatizado com Ruby</title>
</head>
<body>
	
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

Digite: 'gulp watch' e ative o livereload do chrome.

###Dependências instaladas

		
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
		puts "\tParabéns, \n\tvocê terminou de gerar um projeto com gulp-frontend-generator automatizador"
		
		puts "\n\tProjeto Open source para comunidade Front-End/Back-end \n\tque utiliza o Gulp como automatizador de tarefas e componentes."
		puts "\n\tAgora é só rodar o gulp."
		
		puts "\tEntre no projeto `cd #{PATH_SKELETON}`"
		puts "\tDigite: 'gulp watch' e ative o LiveReload do chrome."

		puts "\n\tEdite o arquivo `#{PATH_SKELETON}/src/stylesheets/main.scss` e seja feliz. "
		
		puts "\n\tCriado por Thadeu Esteves Jr."
		puts "\tEmail: tadeuu@gmail.com"
		puts "\tBlog: http://tadeuesteves.wordpress.com"
		puts "\tSite: http://thadeuesteves.com.br"
		puts "#############################################################################"
	end
end

ARGV.each do |a|	
	Skeleton.make('app')
end