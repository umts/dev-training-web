export default {
  extends: 'stylelint-config-standard',
  overrides: [{
    files: ['**/*.scss'],
    extends: 'stylelint-config-standard-scss'
  }],
  ignoreFiles: [
    'assets/builds/**/*',
    'coverage/**/*',
    'docs/**/*',
    'node_modules/**/*',
    'public/**/*'
  ]
}
