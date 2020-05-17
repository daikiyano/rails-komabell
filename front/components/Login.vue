<template>
    <div>
        <div class="card-content">
        <div v-if="this.step === 1">
        <ValidationObserver ref="observer" v-slot="{ passes }">
            <section class="modal-card-body">
        <header class="modal-card-head">
            <p class="modal-card-title">メールアドレスでログインする</p>
        </header>
        <section>
            <EmailInput v-model="email" />
            <ul style="list-style:none; color:red;">
                 <!-- <li v-for="error in errors" :key="error"> -->
                    {{ errors }}
                 <!-- </li> -->
                 <li>{{serverError}}</li>
            </ul>
            <a @click="ChangeForm()">初めて利用する方</a>
        </section>

        <footer class="modal-card-foot">
            <!-- <button class="button" type="button" @click="close()">閉じる</button> -->
            <b-button class="button" type="is-dark" @click="passes(login)">ログイン</b-button>
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