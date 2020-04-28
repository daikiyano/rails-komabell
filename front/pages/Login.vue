<template>
<div>
<form @submit.prevent="login()">
    <input id="name" v-model="email" type="email" name="name">
    <input v-model="password" type="password">
    <button type="submit" @click="login()">ログイン</button>
    

</form>
<button @click="user_is_authed()">auth 確認</button>
<button @click="auto_login()">User 情報</button>
<button @click="logout()">ログアウト</button>

</div>
</template>

<script>
export default {
  data() {
    return {
        email: '',
        password: ''
      }
  },
 
  methods: {
    
    async login() {
        await this.$auth.loginWith('local',{
        data: {
            // auth: {
              email: this.email,
              password: this.password
            // }
          }
        
        }).then((response) => {
          console.log(response.data.jwt)
          localStorage.setItem('idToken',response.data.jwt)
          console.log(response)
          console.log(this.$auth.$state)
          console.log(this.$auth.loggedIn)
          console.log(this.$auth.user)
        },
        (error) => {
          console.log(this.$auth.loggedIn)
          console.log(error)
        })
        
      
    },
   logout() {
      this.$auth.logout();
      localStorage.clear()
      console.log(this.$auth.loggedIn)
    },
    async user_is_authed () {
      console.log(`Bearer ${localStorage.idToken}`)
      const ret = await this.$axios.$get('/api/v1/user_is_authed',
        { headers:{"Authorization" :`Bearer ${localStorage.idToken}`
        }}) 
        console.log(ret)
      },
      async auto_login () {
      console.log(`Bearer ${localStorage.idToken}`)
      const ret = await this.$axios.$get('/api/v1/auto_login',
        { headers:{"Authorization" :`Bearer ${localStorage.idToken}`
        }}) 
        console.log(ret)
      }

  }
}
</script>

<style>

</style>
