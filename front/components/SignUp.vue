<template>
    <div>
        <div class="card-content">
            <div v-if="this.step === 1">
                <ValidationObserver ref="observer" v-slot="{ passes }">
                    <section class="modal-card-body">
                        <header class="modal-card-head">
                            <p class="modal-card-title">メールアドレスで会員登録する</p>
                        </header>
                        <EmailInput v-model="email"/>
                        <ul style="list-style:none; color:red;">
                            <!-- <li v-for="error in errors" :key="error"> -->
                                {{ errors }}
                            <!-- </li> -->
                            <li>
                                {{serverError}}
                            </li>
                        </ul>
                        <a @click="ChangeForm()">既にアカウントをお持ちの方</a>
                        <footer class="modal-card-foot">
                            <!-- <button class="button" type="button" @click="close()">閉じる</button> -->
                            <b-button class="button" type="is-dark" @click="authenticate">google</b-button>
                            <b-button class="button" type="is-dark" @click="passes(login)">会員登録</b-button>
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
               serverError : "",
               step : 1
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
                
                if (this.email) {
                    await this.$axios.$post('/api/v1/create',{ 
                        email: this.email
                    })
                    .then(( res ) => {
                        console.log("clrea")
                       this.step = 2
                        // }
                    })
                    .catch (error => {
                        if (error.response.status == "422") {
                            console.log(error.response)
                            this.errors = "メールアドレスは既に登録されています";
                        }　else {
                            this.serverError = "サーバー内で問題が発生しました。"
                            this.$refs.observer.reset();
                        }
                    })    
                }
                },
            authenticate(){
                this.$auth.loginWith('google')
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