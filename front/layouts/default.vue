<template>
  <div>
<nav class="navbar" role="navigation" aria-label="main navigation">
  <div class="navbar-brand">
    <a class="navbar-item" href="https://bulma.io">
      <img src="https://bulma.io/images/bulma-logo.png" width="112" height="28">
    </a>

    <a role="button" class="navbar-burger burger" aria-label="menu" aria-expanded="false" data-target="navbarBasicExample">
      <span aria-hidden="true"></span>
      <span aria-hidden="true"></span>
      <span aria-hidden="true"></span>
    </a>
  </div>

  <div id="navbarBasicExample" class="navbar-menu">
    <div class="navbar-start">
      <div class="navbar-item">
      <div class="buttons">
      <nuxt-link to="/users/bookshelf" type="is-success" class="button navbar-item" v-if="this.$auth.loggedIn">
        <strong>My 本棚</strong>
      </nuxt-link>
      </div>
      </div>
      <a class="navbar-item">
        新着本
      </a>
      <div class="navbar-item has-dropdown is-hoverable">
        <a class="navbar-link">
          本を探す
        </a>

        <div class="navbar-dropdown">
          <a class="navbar-item">
            About
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
          <nuxt-link to="/users/mypage" type="is-success" class="button" v-if="this.$auth.loggedIn">
            <strong>マイページ</strong>
          </nuxt-link>
          <a @click="isModalForm=true; FormComponent='SignUp'" v-if="!this.$auth.loggedIn">
            <strong>会員登録</strong>
          </a>
          <a @click="isModalForm=true; FormComponent='Login'" class="button is-light" v-if="!this.$auth.loggedIn">
            ログイン
          </a>
          <b-button class="button" type="is-success" v-if="this.$auth.loggedIn" @click="logout()">ログアウト</b-button>

        </div>
      </div>
    </div>
  </div>
</nav>
    <section class="main-content columns">
     
      <Modal :isModalForm="this.isModalForm" 
      :FormComponent="this.FormComponent"   
      @isCloseModal="closeModal" 
      @ChangeForm="ChangeForm($event)" 
      />
     

      <div class="container column is-10">
        <nuxt />
      </div>
    </section>
  </div>
</template>

<script>
  import Login from '~/components/Login.vue'
  import SignUp from '~/components/SignUp.vue'
    import Modal from '~/components/Modal.vue'


export default {


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
    }
  }

}
</script>
