module.exports = {
  plugins: ['react'],
  parser: 'babel-eslint',
  env: {
    jest: true
  },
  rules: {
    'react/prop-types': 0
  },
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'eslint-config-prettier'
  ],
  parserOptions: {
    ecmaFeatures: { jsx: true },
    ecmaVersion: 2018,
    sourceType: 'module'
  }
}
