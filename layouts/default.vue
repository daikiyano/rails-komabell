<template>
  <div>
<nav class="navbar" role="navigation" aria-label="main navigation">
  <div class="navbar-brand">
    <a class="navbar-item" href="/">
      LOGO
    </a>

    <a role="button" class="navbar-burger burger" aria-label="menu" aria-expanded="false" data-target="navbarBasicExample">
      <span aria-hidden="true"></span>
      <span aria-hidden="true"></span>
      <span aria-hidden="true"></span>
    </a>
  </div>

  <div id="navbarBasicExample" class="navbar-menu">
    <div class="navbar-start">
      <!-- <div class="navbar-item"> -->
      <nuxt-link to="/users/bookshelf" class="navbar-item" v-if="this.$auth.loggedIn">
        マイ本棚
      </nuxt-link>
      <!-- </div> -->
      <a class="navbar-item">
        新着本
      </a>
      <div class="navbar-item has-dropdown is-hoverable">
        <a class="navbar-link">
          本を探す
        </a>

        <div class="navbar-dropdown">
          <a class="navbar-item">
            本棚ランキング
          </a>
          <a class="navbar-item">
            Jobs
          </a>
          <a class="navbar-item">
            Contact
          </a>
          <hr class="navbar-divider">
          <a class="navbar-item">
            Report an issue
          </a>
        </div>
      </div>
    </div>

    <div class="navbar-end">
      <div class="navbar-item">
        <div class="buttons">
          <nuxt-link to="/users/mypage" class="navbar-item" v-if="this.$auth.loggedIn">
            マイページ
          </nuxt-link>
          <a @click="isModalForm=true; FormComponent='SignUp'" class="navbar-item" v-if="!this.$auth.loggedIn">
           会員登録
          </a>
          <a @click="isModalForm=true; FormComponent='Login'" class="navbar-item" v-if="!this.$auth.loggedIn">
            ログイン
          </a>
          <a href="#" class="navbar-item" v-if="this.$auth.loggedIn" @click="logout()">ログアウト</a>

        </div>
      </div>
    </div>
  </div>
</nav>
    <!-- <section class="main-content columns"> -->
     
      <Modal :isModalForm="this.isModalForm" 
      :FormComponent="this.FormComponent"   
      @isCloseModal="closeModal" 
      @ChangeForm="ChangeForm($event)" 
      />
     

      <div class="container column is-12">
        <nuxt />
      </div>
    <!-- </section> -->
    <footer class="footer">
      <div class="content has-text-centered">
        <p>
          <strong>Bulma</strong> by <a href="https://jgthms.com">Jeremy Thomas</a>. The source code is licensed
          <a href="http://opensource.org/licenses/mit-license.php">MIT</a>. The website content
          is licensed <a href="http://creativecommons.org/licenses/by-nc-sa/4.0/">CC BY NC SA 4.0</a>.
        </p>
      </div>
</footer>
  </div>
</template>

<script>
  import Login from '~/components/Login.vue'
  import SignUp from '~/components/SignUp.vue'
  import Modal from '~/components/Modal.vue'


export default {
  middleware: [
    'routing',
  ],

  components: {
    Login,
    SignUp,
    Modal
  },
  data () {
    return {
     isModalForm : false,
     FormComponent : ""
     
    }
  },
  created() {
    this.Auth()
  },
  methods: {
    closeModal () {
      this.isModalForm = false
    },
    ChangeForm(FormComponent) {
      console.log(FormComponent)
      this.FormComponent = FormComponent
    },
    logout() {
      this.$auth.logout();
      localStorage.clear()
      console.log(this.$auth.loggedIn)
    },
    Auth () {
        if(this.$auth.$state.strategy && this.$auth.loggedIn && !localStorage.idToken && !this.$route.query.token) {
          console.log("heyhey")
          console.log(localStorage.auth_status)

          
        this.$axios.$post('/api/v1/login', {
          
            email : this.$auth.user.email,
            provider : this.$auth.$state.strategy,
            auth_status: localStorage.auth_status
         
         
        }
        
        )
        .then(res => {   
            // console.log(res.tag)  
            console.log(res.token)  
            localStorage.setItem('idToken',res.token)  
            this.$buefy.toast.open({
                        duration: 5000,
                        message: "ログインに成功しました",
                        type: 'is-success'
                    })         
            })
            .catch ( error => {
                if (error.response.status == "401") {
                    console.log("tokenが無効です")
                    this.$buefy.toast.open({
                        duration: 5000,
                        message: 'サーバー内でも問題が発生しました',
                        type: 'is-danger'
                    })
                } else if (error.response.status == "422") {
                  this.$auth.logout();
                  localStorage.clear()
                  console.log(error.response)
                  this.$buefy.toast.open({
                        duration: 5000,
                        message: error.response.data.validation,
                        type: 'is-danger'
                    })
                }
        })
        }
    },
  },
  

}
</script>
