<template>
<div>
<div class="card">
aa
</div>
  <section class="section">
    <div class="columns is-mobile">
      {{email}}
      <!-- <button @click="user_is_authed()">auth 確認</button>
<button @click="auto_login()">User 情報</button> -->
<button @click="logout()">ログアウト</button>
<Modal :isModalForm="this.isModalForm" 
      :FormComponent="this.FormComponent"   
      @isCloseModal="closeModal" 
      @ChangeForm="ChangeForm($event)" 
      />
      
    </div>
    
  </section>
  </div>
</template>

<script>
  import Modal from '~/components/Modal.vue'

export default {
  name: 'HomePage',
  components: {
        Modal 
        },
  data() {
    return {
    email : "",
    error: "",
    isModalForm : false,
    FormComponent : ""
    }
  },

    created () {
    if (this.$route.query.token) {
      this.$axios.$post('http://127.0.0.1:3000/api/v1/token_check',{
      token : this.$route.query.token
    })
    .then(res => {
      this.email = res.email
      console.log(res.email)  
      console.log(this.email)
    if(this.$auth.loggedIn === false) {
      this.login()
      this.$buefy.toast.open({
        duration: 5000,
        message: 'ようこそ！！',
        type: 'is-success'
      })
    }
    })
    .catch ( error => {
      if (error.response.status == "401") {
          console.log("tokenが無効です")
          // this.error = "Tokenが無効です"
          this.$buefy.toast.open({
            duration: 5000,
            message: 'トークンが無効です',
            type: 'is-danger'
          })
          this.isModalForm = true
          this.FormComponent = "Login"

      }
        })
    }
    },

methods: {
async login() {
        await this.$auth.loginWith('local',{
        data: {
              email: this.email
          }
        
        }).then((response) => {
          console.log(response.data.token)
          localStorage.setItem('idToken',response.data.token)
          console.log(response)
        },
        (error) => {
          console.log(error)
        })
        
      
    },
    logout() {
      this.$auth.logout();
      localStorage.clear()
      console.log(this.$auth.loggedIn)
    },
    closeModal () {
      this.isModalForm = false
    },
    ChangeForm(FormComponent) {
      console.log(FormComponent)
      this.FormComponent = FormComponent
    }
    
}

}
</script>

