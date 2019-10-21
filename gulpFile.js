const gulp = require('gulp');
const run = require('gulp-run-command').default;
const elm = require('gulp-elm');

const build = 'elm-make';
const elmClean = 'elm-clean';
const distClean = 'dist-clean';

gulp.task(build, () => {
    return gulp.src('src/**/Main.elm')
        .pipe(elm.bundle('elm.js'))
        .pipe(gulp.dest('dist/'))
});

gulp.task(elmClean,
    run('shx rm -rf ./elm-stuff')
);

gulp.task(distClean,
    run('shx rm -rf ./dist')
);

gulp.task('elm',
    gulp.series(elmClean, distClean, build)
);