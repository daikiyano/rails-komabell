
export default {
  mode: 'spa',
  /*
  ** Headers of the page
  */
  head: {
    title: process.env.npm_package_name || '',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: process.env.npm_package_description || '' }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
    ]
  },
  /*
  ** Customize the progress-bar color
  */
  loading: { color: '#fff' },
  /*
  ** Global CSS
  */
  css: [
  ],
  /*
  ** Plugins to load before mounting the App
  */
  plugins: [
    'plugins/axios',
    { src: '@/plugins/vue-croppie', mode: 'client'  },
    { src: '@/plugins/vee-validate' },
    { src: '~/plugins/star-rating.js', mode: 'client' },
    {src: '@/plugins/mavon-editor', mode: 'client' }
    
  ],

  router: {
    // middleware: 'routing'
  },
  /*
  ** Nuxt.js dev-modules
  */
  buildModules: [
  ],
  /*
  ** Nuxt.js modules
  */
  modules: [
    // Doc: https://buefy.github.io/#/documentation
    'nuxt-buefy',
    '@nuxtjs/axios',
    '@nuxtjs/auth',
    '@nuxtjs/markdownit'
  ],
  markdownit: {
    injected: true, // $mdを利用してmarkdownをhtmlにレンダリングする
    breaks: true, // 改行コードに変換する
    html: true, // HTML タグを有効にする
    linkify: true, // URLに似たテキストをリンクに自動変換する
    typography: true // 言語に依存しないきれいな 置換 + 引用符 を有効にします。
  },
  auth: {
    redirect: {
      login: '/login',   // 未ログイン時に認証ルートへアクセスした際のリダイレクトURL
      logout: '/login',  // ログアウト時のリダイレクトURL
      callback: '/callback',   // Oauth認証等で必要となる コールバックルート
      home: '/',         // ログイン後のリダイレクトURL
    },
    strategies: {
      local: {
        endpoints: {
          login: { url: '/api/v1/login', method: 'post', propertyName: 'jwt' },
          user: false,
          logout: false
        }
      },
      // google: {
      // },
    }
  },
  axios: {
    // proxy: true,
    baseURL: 'http://localhost:3000'
  },
  proxy: {
    // '/api/': { target: 'http://back:3000', pathRewrite: { '^/api/': '/' } }
  },
  /*
  ** Build configuration
  */
  build: {
    /*
    ** You can extend webpack config here
    */
   transpile: ["vee-validate/dist/rules"] ['star-rating'],
    extend (config, ctx) {
    }
  }
}
