#!/usr/bin/env ruby

require 'rubygems'
require 'fileutils'
require File.expand_path('../lib/files', __FILE__)
require File.expand_path('../lib/gulp', __FILE__)

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
  
	def self.make(dir)  
    
  	stylesheets = ["#{PATH_SKELETON}","#{dir}","assets","stylesheets"]
  	javascript 	= ["#{PATH_SKELETON}","#{dir}","assets","javascripts"]
  	images 			= ["#{PATH_SKELETON}","#{dir}","assets","images"]

  	src_images 				= ["#{PATH_SKELETON}","src","images"]
  	src_coffee		= ["#{PATH_SKELETON}","src","coffee"]
    src_es6		= ["#{PATH_SKELETON}","src","es6"]
  	src_stylesheets 	= ["#{PATH_SKELETON}","src","stylesheets"]
    
    #styles
    Files.create({path: stylesheets.join("/") ,file: 'application', extension: 'css'})
    #javascripts
    Files.create({path: javascript.join("/") ,file: 'application', extension: 'js'})    
    #images
    Files.create({path: images.join("/") ,file: 'empty', extension: ''})
    
    #src_images
    Files.create({path: src_images.join("/"), file: 'empty', extension: ''})
    #src_styles
    Files.create({path: src_coffee.join("/") ,file: 'app', extension: 'coffee'})
    #src_javascripts
    Files.create({path: src_es6.join("/") ,file: 'application', extension: 'js'})    
    #src_javascripts
    Files.create({path: src_stylesheets.join("/") ,file: 'application', extension: 'scss'})    

		#package.json
		FileUtils.touch("#{PATH_SKELETON}/package.json")
		self.create_package
		puts "\tcreate \t#{PATH_SKELETON}/package.json"

		#gulpfile.js
		Gulp.path(PATH_SKELETON).gulpfile
		
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
		Gulp.path(PATH_SKELETON).shell
		
    self.gitignore
    puts "\n\t-- .gitignore criado...."
    puts "#############################################################################"
    
    self.bowerrc
    puts "\n\t-- .bowerrc criado...."
    puts "#############################################################################"

		#inicia o git e escreve o primeiro commit
		system("cd #{PATH_SKELETON} && git init && git add . && git commit -am '[First Commit]'")
		puts "#############################################################################"
		puts "\t--Git iniciado e com primeiro comentário"
		puts "\t--Digite: `git status` para mais informações."

		#sobre o automatizador
		self.about
	end
  
  def self.bowerrc
    system("sudo npm install -g bower")
    puts "\n\t--Bower Instalado....."
		f = File.new("#{PATH_SKELETON}/.bowerrc", "a")
		f.puts "
{
  \"directory\": \"app/components/\",
  \"ignoredDependencies\": [
    \"jquery\"
  ]
}
    "
		f.close unless f.closed?
    
    system("cd #{PATH_SKELETON} && bower install --save jquery2 bootstrap")
    puts "\n\t--jquery e bootstrap configurados............."
  end
  
  def self.gitignore
		f = File.new("#{PATH_SKELETON}/.gitignore", "a")
		f.puts "
.DS_Store
/node_modules
.sass-cache
/tmp
.tmp
app/components
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

	# responsavel por criar o arquivo index.html e escrever dentro o doctype e links para os styles e scripts
	def self.create_html
		f = File.new("#{PATH_SKELETON}/index.html", "a")
		f.puts "<!DOCTYPE html>
<html lang=\"en\">
<head>

	<!-- METAS -->
	<meta charset=\"UTF-8\">

	<!-- CSS -->
	<link rel=\"stylesheet\" href=\"app/components/bootstrap/dist/css/bootstrap.min.css\">
	<link rel=\"stylesheet\" href=\"app/assets/stylesheets/application.css\">

	<!-- TITLE -->
	<title>frontend-gulp-boirlerplate</title>

</head>
<body>

	<div class=\"all\">
		<div class=\"col-md-12\">
			<h1>Frontend Gulp Boirlerplate!</h1>
      <small>
        by Thadeu Esteves Jr.
      </small>
		</div>
	</div>

  <!-- JS -->
	<script src=\"app/components/jquery2/jquery.min.js\"></script>
	<script src=\"app/components/bootstrap/dist/js/bootstrap.min.js\"></script>
	<script src=\"app/assets/javascripts/app.js\"></script>
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