module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'

  grunt.initConfig
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
    "coffee:compile"
    "requirejs:nooptimize"
    ]
    
  grunt.registerTask "default", [
    "coffee:compile"
    "requirejs:optimize"
    ]
