<template>
    <div>
        <div class="card-content">
        <div v-if="this.step === 1">
        <ValidationObserver ref="observer" v-slot="{ passes }">
            <section class="modal-card-body">
        <header class="modal-card-head">
            <p class="modal-card-title" style="font-size: 14px;"><b>メールアドレスでログインする</b></p>
        </header>
        <section>
            <EmailInput v-model="email" />
            <ul style="list-style:none; color:red;">
                 <!-- <li v-for="error in errors" :key="error"> -->
                    {{ errors }}
                 <!-- </li> -->
                 <li>{{serverError}}</li>
            </ul>
            <a @click="ChangeForm()" style="font-size: 14px;">初めて利用する方</a>
        </section>

        <footer class="modal-card-foot">
            <li style="list-style: none; margin: 0 auto;">
                <ul><b-button style="width: 190px;" class="button" type="is-inline-dark" @click="passes(login)">Eメールでログイン</b-button></ul>
                <ul><b-button style="width: 190px;" class="button" type="is-inline-dark" @click="AuthGoogle"><img src="https://img.icons8.com/color/48/000000/google-logo.png" style="height: 15px;">Googleでログイン</b-button></ul>
                <ul><button style="width: 190px;" class="button" type="is-inline-dark" @click="AuthGithub"><img src="https://img.icons8.com/fluent/48/000000/github.png" style="height: 15px;"/>GitHubでログイン</button></ul>
                <ul><button style="width: 190px;" class="button" type="is-inline-dark" @click="AuthFacebook"><img src="https://img.icons8.com/fluent/48/000000/facebook-new.png" style="height: 15px;"/>Facebookでログイン</button></ul>
                <ul><a @click="ChangeForm()" style="font-size: 14px;">既にアカウントをお持ちの方</a></ul>
            </li>
        </footer>
        </section>
        </ValidationObserver>
        </div>
        <div v-else-if="this.step === 2">
            
            <section class="modal-card-body">
                <header class="modal-card-head">
                <p class="modal-card-title">確認メールを送信しました</p>
                </header>
                <p>
                {{ email }}宛に確認メールを送信しました。<br>
                15分以内に添付したリンクをクリックしてログインを完了させてください。
                </p>
                <footer class="modal-card-foot">
                    <button class="button" type="is-dark" @click="close()">閉じる</button>
                </footer>
            </section>
            
        </div>
        </div>
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
                email : "",
                errors: "",
                serverError : "",
                step : 1
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
                        console.log("clrea")
                       this.step = 2
                    })
                    .catch (error => {
                        if (error.response.status == "422") {
                            console.log(error.response)
                            this.errors = "メールアドレスが未登録です";
                        }　else {
                            this.serverError = "サーバー内で問題が発生しました。"
                            this.$refs.observer.reset();
                        }
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
            },
            AuthGoogle(){
                localStorage.setItem('auth_status','login') 
                this.$auth.loginWith('google')
                
            },
            AuthGithub () {
                localStorage.setItem('auth_status','login') 
                this.$auth.loginWith('github')
            },
            AuthFacebook () {
                localStorage.setItem('auth_status','login') 
                this.$auth.loginWith('facebook')
            }
        }
      
    }
</script>

<style>
.modal-card-body {
    box-shadow: 0 2px 10px rgba(0,0,0,.15);
}
.modal-card-head {
    background-color: white;
    border-bottom: 1px solid white;
}

.modal-card-foot {
    background-color: white;
    border-top: 1px solid white;
}
</style>