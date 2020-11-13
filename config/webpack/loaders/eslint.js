module.exports = {
  enforce: 'pre',
  test: /\.(js|vue)?$/,
  exclude: /node_modules/,
  use: ['eslint-loader']
}
