module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt);

  version = ->
    grunt.file.readJSON("package.json").version
  version_tag = ->
    "v#{version()}"

  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    comments: """
/*!
<%= pkg.name %> 是在chosen https://github.com/harvesthq/chosen 的基础上专门针对中文的改进。
Version <%= pkg.version %> Build Time <%= grunt.template.date(new Date(), 'yyyy-mm-dd')  %>
项目代码 https://github.com/doukit/chosen4chinese
*/
\n
"""
    minified_comments: "/* Chosen #{version_tag()} | (c) 2011-<%= grunt.template.today('yyyy') %> by Harvest | MIT License, https://github.com/harvesthq/chosen/blob/master/LICENSE.md */\n"

    concat:
      options:
        banner: "<%= comments %>"
      jquery:
        src: ["lib/chosen.jquery.js"]
        dest: "lib/chosen.jquery.js"
      proto:
        src: ["lib/chosen.proto.js"]
        dest: "lib/chosen.proto.js"
      css:
        src: ["lib/css/chosen.css"]
        dest: "lib/css/chosen.css"

    coffee:
      options:
        join: true
      compile:
        files:
          'lib/chosen.jquery.js': ['src/base/select-parser.coffee', 'src/base/abstract-chosen.coffee', 'src/pinyin.coffee', 'src/chosen.jquery.coffee']
          'example/chosen.jquery.js': ['src/base/select-parser.coffee', 'src/base/abstract-chosen.coffee', 'src/pinyin.coffee', 'src/chosen.jquery.coffee']
          'lib/chosen.proto.js': ['src/base/select-parser.coffee', 'src/base/abstract-chosen.coffee', 'src/chosen.proto.coffee']

    uglify:
      options:
        mangle:
          except: ['jQuery', 'AbstractChosen', 'Chosen', 'SelectParser']
        banner: "<%= minified_comments %>"
      minified_chosen_js:
        files:
          'lib/chosen.jquery.min.js': ['lib/chosen.jquery.js']
          'example/chosen.jquery.min.js': ['lib/chosen.jquery.js']
          'lib/chosen.proto.min.js': ['lib/chosen.proto.js']

    compass:
      chosen_css:
        options:
          bundleExec: true
          specify: ['sass/chosen.scss']

    cssmin:
      minified_chosen_css:
        options:
          banner: "<%= minified_comments %>"
          keepSpecialComments: 0
        src: 'lib/css/chosen.css'
        dest: 'lib/css/chosen.min.css'

    watch:
      scripts:
        files: ['src/**/*.coffee', 'sass/*.scss']
        tasks: ['build']

  grunt.registerTask 'preBuild', 'some prepare task before build', () ->
    grunt.file.delete("lib/css/chosen.css")

  grunt.registerTask 'postBuild', 'some post task after build', () ->
    content = grunt.file.read("README.md");
    len = content.length
    content = content.substring(0, len - 11)
    date = grunt.template.date(new Date(), 'yyyy-mm-dd');

    grunt.file.write("README.md", content + date)

  grunt.registerTask 'default', ['preBuild', 'build', 'postBuild']
  grunt.registerTask 'build', ['coffee', 'compass','concat', 'uglify', 'cssmin']
  grunt.registerTask 'test',  ['coffee']
