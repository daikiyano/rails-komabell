<template>
  <div>
    <main style="top: 50px; position: relative;">
     <form @submit.prevent>
    <input v-model="email" type="email">
    <input v-model="password" type="password">
    <button type="submit" @click="login()">ログイン</button>
</form>
{{email}}
{{password}}
      login
    </main>
  </div>
</template>

<script>


 export default {
    components: {

    },
    data() {
      return {
          email : "",
          password : ""
    }
    },
    created () {
      
    },
  methods: {
      async login() {
      await this.$auth.loginWith('admin',{
        data: {
              email: this.email,
              password: this.password
          }
        
        }).then((response) => {
          console.log(response.data.token)
          localStorage.setItem('admin',"admin")
          localStorage.setItem('idToken',response.data.token)
          console.log(response)
        },
        (error) => {
          console.log(error)
        })
    },
    
  }
 }
</script>
