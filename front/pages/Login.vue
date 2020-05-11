<template>
<div>
<form @submit.prevent>
    <input id="name" v-model="email" type="email" name="name">
    <button type="submit" @click="login()">ログイン</button>
</form>
<button @click="user_is_authed()">auth 確認</button>
<button @click="auto_login()">User 情報</button>
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
      await this.$axios.$post('/api/v1/create',{ 
        email: this.email
      })
      .then(( res ) => {
        console.log(res)
      })
      .catch ( error => {
        console.log(error)
      })   
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
