<template>
    <div>
        <ValidationObserver ref="observer" v-slot="{ passes }">
            <header class="modal-card-head">
                <p class="modal-card-title">メールアドレスで会員登録する</p>
            </header>
            <section class="modal-card-body">
                <EmailInput v-model="email"/>
                <ul style="list-style:none; color:red;">
                    <li v-for="error in errors" :key="error">
                        {{ error }}
                    </li>
                                     <li>{{serverError}}</li>

                </ul>
                <a @click="ChangeForm()">既にアカウントをお持ちの方</a>
            </section>
            <footer class="modal-card-foot">
                <button class="button" type="button" @click="close()">閉じる</button>
                <b-button class="button" type="is-success" @click="passes(login)">会員登録</b-button>
            </footer>
        </ValidationObserver>
      
    </div>
</template>

<script>
import EmailInput from '~/components/Form/EmailInput.vue'
import { ValidationObserver, ValidationProvider } from 'vee-validate';

    export default {
        name: 'SignUp',
        components: {
            EmailInput,
            ValidationObserver,
            ValidationProvider  
        },
        data() {
            return {
               email : "",
               errors : "",
               serverError : ""
            }
        },
        methods: {
            close () {
                this.$emit('isCloseModal', false)
            },
            ChangeForm () {
                this.$emit('ChangeForm', "Login")
            },
            async login() {
                // const isValid = await this.$refs.observer.validate()
                // if (isValid) {
                //     console.log(isValid)
                // }
                if (this.email) {
                    await this.$axios.$post('/api/v1/create',{ 
                        email: this.email
                    })
                    .then(( res ) => {
                        // console.log(res.error)
                        // for (var i = 0; i < count(res.error); i++{
                        this.errors = res.error
                        this.$refs.observer.reset();
                        // }
                    })
                    .catch (error => {
                        this.serverError = "サーバー内で問題が発生しました。"
                    })   
                }
                },

        }
    }
</script>