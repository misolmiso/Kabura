module.exports = (grunt) ->
    grunt.loadNpmTasks 'grunt-contrib'

    grunt.initConfig
        watch:
            coffee:
                files: "coffee/*.coffee",
                tasks: ["coffee"]

        coffee:
            compile:
                files:
                    'main.js': [
                        "coffee/*.coffee"
                    ]

    grunt.registerTask "default", ["coffee"]
