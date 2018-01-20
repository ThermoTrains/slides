const gulp = require('gulp');
const gutil = require('gulp-util');
const gls = require('gulp-live-server');
const nunjucksRender = require('gulp-nunjucks-render');
const sass = require('gulp-sass');

const runSequence = require('run-sequence');
const del = require('del');

gulp.task('default', ['root', 'slides']);

gulp.task('root', () => gulp.src('index.html').pipe(gulp.dest('build')));
gulp.task('slides', () => runSequence('clean:slides', ['slides:nunjucks', 'slides:js', 'slides:style', 'slides:images', 'slides:deps']));

gulp.task('clean', ['clean:docs', 'clean:slides']);
gulp.task('clean:slides', () => del(['build/**/*']));

gulp.task('slides:nunjucks', function () {
  gulp.src('slides/index.html')
    .pipe(nunjucksRender({path: ['slides/']}))
    .on('error', (error) => {
      gutil.log(gutil.colors.red('Error (' + error.plugin + '): ' + error.message));
      this.emit('end');
    })
    .pipe(gulp.dest('./build'));
});

gulp.task('slides:js', () => {
  gulp.src('slides/**/*.js')
    .pipe(gulp.dest('build'));
});

gulp.task('slides:style', () => {
  gulp.src('slides/styles/main.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('build'));
});

gulp.task('slides:deps', ['slides:deps:styles'], () => {
  gulp.src('{node_modules/reveal.js/lib/js/head.min.js,' +
    'node_modules/reveal.js/plugin/**/*.js,' +
    'node_modules/reveal.js/plugin/**/*.html,' +
    'node_modules/reveal.js/js/reveal.js,' +
    'node_modules/reveal.js/**/*.{eot,ttf,woff}}')
    .pipe(gulp.dest('build'));
});

gulp.task('slides:deps:styles', () => {
  gulp.src('{node_modules/reveal.js/css/reveal.scss,node_modules/reveal.js/**/*.css}')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('build'));
});

gulp.task('slides:images', () => {
  gulp.src('slides/images/**/*.{png,jpg,gif,svg,mp4}')
    .pipe(gulp.dest('build/images'));
});

gulp.task('serve:slides', ['slides'], () => {
  const server = gls.static('build', 3002);
  server.start();

  // Restart the server when file changes
  gulp.watch('slides/styles/**/*.scss', (file) => {
    runSequence('slides:style', () => server.notify.apply(server, [file]));
  });
  gulp.watch('slides/**/*.html', (file) => {
    runSequence('slides:nunjucks', () => setTimeout(() => server.notify.apply(server, [file]), 100));
  });
  gulp.watch('slides/js/**/*.js', (file) => {
    runSequence('slides:js', () => server.notify.apply(server, [file]));
  });
  gulp.watch('slides/images/**/*.{png,jpg,gif,svg,mp4}', (file) => {
    runSequence('slides:images', () => server.notify.apply(server, [file]));
  });
});
