<template>
  <div>
    <div class="card-content">
      <div v-if="this.step === 1">
        <!-- <ValidationObserver ref="observer" v-slot="{ passes }"> -->
        <section class="modal-card-body">
          <header class="modal-card-head">
            <p class="modal-card-title">ログイン</p>
          </header>
          <section></section>

          <footer class="modal-card-foot">
            <li style="list-style: none; margin: 0 auto">
              <ul>
                <b-button
                  style="width: 190px"
                  class="button"
                  type="is-inline-dark"
                  @click="stepEmail()"
                  >Eメールでログイン</b-button
                >
                <!-- @click="passes(login)" -->
              </ul>
              <ul>
                <b-button
                  style="width: 190px"
                  class="button"
                  type="is-inline-dark"
                  @click="AuthGoogle"
                  ><img
                    src="https://img.icons8.com/color/48/000000/google-logo.png"
                    style="height: 15px"
                  />Googleでログイン</b-button
                >
              </ul>
              <ul>
                <button
                  style="width: 190px"
                  class="button"
                  type="is-inline-dark"
                  @click="AuthGithub"
                >
                  <img
                    src="https://img.icons8.com/fluent/48/000000/github.png"
                    style="height: 15px"
                  />GitHubでログイン
                </button>
              </ul>
              <ul>
                <button
                  style="width: 190px"
                  class="button"
                  type="is-inline-dark"
                  @click="AuthFacebook"
                >
                  <img
                    src="https://img.icons8.com/fluent/48/000000/facebook-new.png"
                    style="height: 15px"
                  />Facebookでログイン
                </button>
              </ul>
              <ul>
                <a @click="ChangeForm()" style="font-size: 14px"
                  >初めて利用する方</a
                >
              </ul>
            </li>
          </footer>
        </section>
        <!-- </ValidationObserver> -->
      </div>
      <div v-else-if="this.step === 2">
        <ValidationObserver ref="observer" v-slot="{ passes }">
          <section class="modal-card-body">
            <header class="modal-card-head">
              <p class="modal-card-title">ログインフォーム</p>
            </header>
            <section>
              <EmailInput v-model="email" />
              <ValidationProvider
                rules="required"
                vid="password"
                name="Password"
                v-slot="{ errors, valid }"
              >
                <b-field
                  label="Password"
                  :type="{ 'is-danger': errors[0], 'is-success': valid }"
                  :message="errors"
                >
                  <b-input type="password" v-model="password"></b-input>
                </b-field>
              </ValidationProvider>
              <ul style="list-style: none; color: red">
                <!-- <li v-for="error in errors" :key="error"> -->
                {{
                  errors
                }}
                <!-- </li> -->
                <li>{{ serverError }}</li>
              </ul>
            </section>
            <footer class="modal-card-foot">
              <button class="button" type="is-dark" @click="passes(signIn)">
                送信する
              </button>
              <button class="button" type="is-dark" @click="close()">
                戻る
              </button>
            </footer>
          </section>
        </ValidationObserver>
      </div>
    </div>
  </div>
</template>

<script>
import EmailInput from "~/components/Form/EmailInput.vue";
import { ValidationObserver, ValidationProvider } from "vee-validate";
import * as firebase from "@/plugins/firebase";

export default {
  name: "Login",
  components: {
    EmailInput,
    ValidationObserver,
    ValidationProvider,
  },
  data() {
    return {
      email: "",
      password: "",
      errors: "",
      serverError: "",
      step: 1,
    };
  },
  methods: {
    close() {
      this.$emit("isCloseModal", false);
    },
    ChangeForm() {
      console.log("hey");
      this.$emit("ChangeForm", "SignUp");
    },
    async login() {
      this.errors = "";
      this.serverError = "";
      if (this.email) {
        await this.$axios
          .$post("/api/v1/signin", {
            email: this.email,
          })
          .then((res) => {
            console.log("clrea");
            this.step = 2;
          })
          .catch((error) => {
            if (error.response.status == "422") {
              console.log(error.response);
              this.errors = "メールアドレスが未登録です";
            } else {
              this.serverError = "サーバー内で問題が発生しました。";
              this.$refs.observer.reset();
            }
          });
      }
    },
    async user_is_authed() {
      console.log(`Bearer ${localStorage.idToken}`);
      const ret = await this.$axios.$get("/api/v1/user_is_authed", {
        headers: { Authorization: `Bearer ${localStorage.idToken}` },
      });
      console.log(ret);
    },
    async auto_login() {
      console.log(`Bearer ${localStorage.idToken}`);
      const ret = await this.$axios.$get("/api/v1/auto_login", {
        headers: { Authorization: `Bearer ${localStorage.idToken}` },
      });
      console.log(ret);
    },
    AuthGoogle() {
      localStorage.setItem("auth_status", "login");
      this.$auth.loginWith("google");
    },
    AuthGithub() {
      localStorage.setItem("auth_status", "login");
      this.$auth.loginWith("github");
    },
    AuthFacebook() {
      localStorage.setItem("auth_status", "login");
      this.$auth.loginWith("facebook");
    },
    stepEmail() {
      this.step = 2;
    },
    signIn() {
      firebase
        .auth()
        .signInWithEmailAndPassword(this.email, this.password)
        .then(
          (user) => {
            alert(user.user.uid);
            this.tmpUser = user;
            this.close();
          },
          (err) => {
            console.log(err);
            this.errors = "メールアドレスが未登録です";
          }
        );
    },
  },
};
</script>

<style>
.modal-card-body {
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
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