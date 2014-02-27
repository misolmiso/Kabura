module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-simple-mocha'

  grunt.initConfig
    coffeelint:
      app:
        files:
          src: [
            "Gruntfile.coffee"
            "coffee/*.coffee"
            ]

    simplemocha:
      all:
        src: ["test/*.coffee"]
      options:
        reporter: 'nyan'
        ui: 'tdd'

    requirejs:
      nooptimize:
        options:
          mainConfigFile: "r-config",
          optimize: "none",
          name: "coffee/game",
          out: "main.js"
        
      optimize:
        options:
          mainConfigFile: "r-config",
          name: "coffee/game",
          out: "main.js"
  
    watch:
      debug:
        files: ["coffee/*.coffee", "test/*.coffee"]
        tasks: ["debug"]

    coffee:
      glob_to_multiple:
        expand: true
        flatten: true
        src: ['coffee/*.coffee']
        dest: 'coffee/'
        ext: '.js'

  grunt.registerTask "debug", [
    "coffeelint"
    "coffee"
    "simplemocha"
    "requirejs:nooptimize"
    ]

  grunt.registerTask "default", [
    "debug"
    ]
    
  grunt.registerTask "release", [
    "coffeelint"
    "coffee"
    "simplemocha"
    "requirejs:optimize"
    ]
