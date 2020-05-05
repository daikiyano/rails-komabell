<template>
    <div>
<ValidationObserver ref="observer" v-slot="{ passes }">
        <header class="modal-card-head">
            <p class="modal-card-title">メールアドレスでログインする</p>
        </header>

        <section class="modal-card-body">
            <EmailInput v-model="email"/>
            <ul style="list-style:none; color:red;">
                 <!-- <li v-for="error in errors" :key="error"> -->
                    {{ errors }}
                 <!-- </li> -->
                 <li>{{serverError}}</li>
            </ul>
            <a @click="ChangeForm()">初めて利用する方</a>
        </section>

        <footer class="modal-card-foot">
            <button class="button" type="button" @click="close()">閉じる</button>
            <b-button class="button" type="is-success" @click="passes(login)">ログイン</b-button>
        </footer>
          </ValidationObserver>
    </div>
</template>

<script>
import EmailInput from '~/components/Form/EmailInput.vue'
     import { ValidationObserver, ValidationProvider } from 'vee-validate';


    export default {
        name: 'Login',
        components: {
            EmailInput,
            ValidationObserver,
            ValidationProvider  
        },
        data() {
            return {
                email : '',
                errors: "",
                serverError : ""
                 }
        },
        methods: {
            close () {
                this.$emit('isCloseModal', false)
            },
            ChangeForm () {
                console.log("hey")
                this.$emit('ChangeForm', "SignUp")
            },
            async login() {
                this.errors = ""
                this.serverError = ""
                if (this.email) {
                    await this.$axios.$post('/api/v1/signin',{ 
                        email: this.email
                    })
                    .then(( res ) => {
                        console.log(res.error)
                        console.log("モデルエラー")
                        this.errors = res.error;
                        this.$refs.observer.reset();
                    })
                    .catch (error => {
                        console.log(error)
                        this.serverError = "サーバー内で問題が発生しました。"
                        console.log(this.error)
                    })   
                    }
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