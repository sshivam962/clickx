/** @type {import('tailwindcss').Config} */
const colors = require('tailwindcss/colors')
module.exports = {
  content: ["./app/**/*.{haml,js,css}"],
  theme: {
    extend: {
      colors: {
        primary: '#F8B018',
        secondary: 'var(--secondary)',
        transparent: 'transparent',
        current: 'currentColor',
      }
    },
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      black: colors.black,
      white: colors.white,
      gray: colors.gray,
      gray: colors.slate,
      blue: colors.blue,
      green: colors.green,
      amber: colors.amber,
      red: colors.red,
      yellow: colors.yellow,
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
  corePlugins: {
    backgroundOpacity: false,
    backdropOpacity: false,
    backgroundOpacity: false,
    borderOpacity: false,
    divideOpacity: false,
    ringOpacity: false,
    textOpacity: false
  },
}
