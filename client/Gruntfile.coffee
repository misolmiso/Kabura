module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-coffeelint'

  grunt.initConfig
    coffeelint:
      app:
        files:
          src: [
            "Gruntfile.coffee"
            "coffee/*.coffee"
            ]

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
    "coffee:compile"
    "requirejs:nooptimize"
    ]

  grunt.registerTask "default", [
    "debug"
    ]
    
  grunt.registerTask "release", [
    "coffeelint"
    "coffee:compile"
    "requirejs:optimize"
    ]
