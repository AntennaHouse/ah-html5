var gulp = require('gulp');
var sass = require('gulp-sass');

gulp.task('sass', function(done){
    // Fetch command line arguments
    const arg = (argList => {
        let arg = {}, a, opt, thisOpt, curOpt;
        for (a = 0; a < argList.length; a++) {
            thisOpt = argList[a].trim();
            opt = thisOpt.replace(/^\-+/, '');
            if (opt === thisOpt) {
                // argument value
            if (curOpt) arg[curOpt] = opt;
                curOpt = null;
            }
            else {
                // argument name
                curOpt = opt;
                arg[curOpt] = true;
            }
        }
        return arg;
    })(process.argv);

    // Set scss directory
    gulp.src('./sass/*.scss')
    // Do compile
    .pipe(sass({style : 'expanded'})) //Set output format　#nested, compact, compressed, expanded.
    // Set output directory (passed from --destdir command-line parameter)
    .pipe(gulp.dest(arg.destdir));
    done();
});
