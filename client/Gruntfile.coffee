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
        ui: 'tdd'

    requirejs:
      nooptimize:
        options:
          mainConfigFile: "r-config",
          optimize: "none",
          name: "main-unoptimized",
          out: "main.js"
        
      optimize:
        options:
          mainConfigFile: "r-config",
          name: "main-unoptimized",
          out: "main.js"
  
    watch:
      debug:
        files: "coffee/*.coffee",
        tasks: ["debug"]

    coffee:
      compile:
        files: "main-unoptimized.js": "coffee/*.coffee"

  grunt.registerTask "debug", [
    "coffeelint"
    "simplemocha"
    "coffee:compile"
    "requirejs:nooptimize"
    ]

  grunt.registerTask "default", [
    "debug"
    ]
    
  grunt.registerTask "release", [
    "coffeelint"
    "simplemocha"
    "coffee:compile"
    "requirejs:optimize"
    ]
