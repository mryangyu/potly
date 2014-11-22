fs = require('fs')

module.exports = (grunt) ->
	grunt.initConfig
		env: 
			dev:
				NODE_ENV: 'development'

		express:
			options: {}
			dev:
				options:
					script: 'server.js'
					args: ['--local']
					port: 5002 # warning, do not use conf for this as it preloads before ENV

		copy:
			dist: 
				expand: true
				flatten: true
				filter: 'isFile'
				src: [
					'bower_components/bootstrap/dist/fonts/*', 
					'bower_components/font-awesome/fonts/*'
				]
				dest: 'public/assets/fonts/'

		sass:
			app:
				files:
					'stylesheets/main.css': 'stylesheets/main.scss'
		cssmin:
			ext:
				files: 
					'public/assets/css/ext.min.css': [
						'stylesheets/readable.min.css'
						'bower_components/font-awesome/css/font-awesome.css'
						'bower_components/bootstrap-select/bootstrap-select.css'
						'bower_components/angular-loading-bar/build/loading-bar.css'
						'bower_components/perfect-scrollbar/src/perfect-scrollbar.css'
						'bower_components/bootstrap-tagsinput/dist/bootstrap-tagsinput.css'
					]
			app:
				files:
					'public/assets/css/app.min.css': [
						'stylesheets/main.css'
					]

		coffee: 
			dist:
				options:
					join: true
				files:
					'public/assets/js/app.js': [
						'lib/extensions/**/*.coffee'
						'lib/utils/**/*.coffee'
						'scripts/**/*.coffee'
					]
		jade:
			dist:
				options:
					data: (desc, src) ->
						model = {}
						model.conf = require('./config/init')
						return model
								
				files: [
					expand: true
					src: ['*.jade']
					cwd: 'views/client'
					dest: '.jade/tmpl'
					ext: '.html'
				]

		ngtemplates:
			options:
				bootstrap: (module,script) ->
					"""
					angular.module(conf.app.site_name).run(['$templateCache', function($templateCache) {
						#{script}
					}]);
					"""
			app:
				cwd: '.jade'
				src: 'tmpl/**/*.html'
				dest: 'public/assets/js/tmpl.js'

		uglify:
			options: 
				mangle: false
				compress:
					drop_console: false #TODO turn to true in prod
			ext:
				files:
					'public/assets/js/ext.min.js': [
						'bower_components/jQuery/dist/jquery.js'
						'bower_components/lodash/dist/lodash.js'
						'bower_components/moment/moment.js'
						'bower_components/angular/angular.js'
						'bower_components/angular-cookies/angular-cookies.js'
						'bower_components/angular-route/angular-route.js'
						'bower_components/angular-animate/angular-animate.js'
						'bower_components/angular-loading-bar/build/loading-bar.js'
						'bower_components/angular-moment/angular-moment.js'
						'bower_components/angular-file-upload/angular-file-upload.js'
						'bower_components/combodate/combodate.js'
						'bower_components/ngInfiniteScroll/ng-infinite-scroll.js'
						'bower_components/ngInfiniteScroll/build/ng-infinite-scroll.js'
						'bower_components/bootstrap/dist/js/bootstrap.js'
						'bower_components/bootstrap-select/bootstrap-select.js'
						'bower_components/bootstrap-tagsinput/dist/bootstrap-tagsinput.js'
						'bower_components/nya-bootstrap-select/src/nya-bootstrap-select.js'
						'bower_components/perfect-scrollbar/src/jquery.mousewheel.js'
						'bower_components/perfect-scrollbar/src/perfect-scrollbar.js'
						'bower_components/fastclick/lib/fastclick.js'
						'bower_components/oclazyload/dist/ocLazyLoad.js'
					]
			app:
				options:
					sourceMap: true
				files:
					'public/assets/js/app.min.js': [
						'public/assets/js/app.js'
					]
			tmpl:
				files: 
					'public/assets/js/tmpl.min.js': [
						'public/assets/js/tmpl.js'
					]
					
		watch:
			stylesheets:
				files: ['stylesheets/**/*.scss']
				tasks: ['sass', 'cssmin:app']

			scripts:
				files: ['scripts/**/*.coffee', 'lib/extensions/**/*.coffee', 'lib/utils/**/*.coffee']
				tasks: ['coffee', 'uglify:app']

			views:
				files: ['views/client/**/*.jade']
				tasks: ['jade', 'ngtemplates', 'uglify:tmpl']

			express:
				files: ['app.coffee', 'routes.coffee', 'config/*.yml', 'lib/**/*.coffee']
				tasks: ['express:dev']
				options:
					nospawn: true # Without this option specified express won't be reloaded

	grunt.loadNpmTasks('grunt-express-server')
	grunt.loadNpmTasks('grunt-contrib-watch')
	grunt.loadNpmTasks('grunt-contrib-sass')
	grunt.loadNpmTasks('grunt-contrib-uglify')
	grunt.loadNpmTasks('grunt-contrib-cssmin')
	grunt.loadNpmTasks('grunt-contrib-copy')
	grunt.loadNpmTasks('grunt-contrib-coffee')
	grunt.loadNpmTasks('grunt-contrib-jade')
	grunt.loadNpmTasks('grunt-angular-templates')
	grunt.loadNpmTasks('grunt-env')

	# Default task(s).
	grunt.registerTask('default', ['env:dev', 'express:dev', 'watch'])
	grunt.registerTask('compress', ['copy', 'sass', 'cssmin', 'coffee', 'jade', 'ngtemplates', 'uglify'])
			
	global.grunt = grunt
	