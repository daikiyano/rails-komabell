<template>
  <div>
    <b-navbar>
      <template slot="brand">
        <b-navbar-item tag="router-link" :to="{ path: '/' }">
          <b>Pro Hub</b>
        </b-navbar-item>
      </template>
      <template slot="start">
        <b-navbar-item href="#"> Pro Hubとは </b-navbar-item>
        <b-navbar-item href="#"> About </b-navbar-item>
        <b-navbar-dropdown label="Info">
          <b-navbar-item href="#"> About </b-navbar-item>
          <nuxt-link
            to="/users/bookshelf"
            class="navbar-item"
            v-if="this.$auth.loggedIn"
          >
            マイ本棚
          </nuxt-link>
        </b-navbar-dropdown>
      </template>
      <template slot="end">
        <b-navbar-item tag="div">
          <div class="buttons">
            <nuxt-link
              to="/users/mypage"
              class="navbar-item"
              v-if="this.$auth.loggedIn"
            >
              マイページ
            </nuxt-link>
            <a
              @click="
                isModalForm = true;
                FormComponent = 'SignUp';
              "
              class="navbar-item"
              v-if="!this.$auth.loggedIn"
            >
              会員登録
            </a>
            <a
              @click="
                isModalForm = true;
                FormComponent = 'Login';
              "
              class="navbar-item"
              v-if="!this.$auth.loggedIn"
            >
              ログイン
            </a>
            <a
              href="#"
              class="navbar-item"
              v-if="this.$auth.loggedIn"
              @click="logout()"
              >ログアウト</a
            >
          </div>
        </b-navbar-item>
      </template>
    </b-navbar>
    <Modal
      :isModalForm="this.isModalForm"
      :FormComponent="this.FormComponent"
      @isCloseModal="closeModal"
      @ChangeForm="ChangeForm($event)"
    />
    <div class="container column is-12">
      <nuxt />
    </div>
    <!-- </section> -->

    <footer class="footer">
      <div class="content has-text-centered">
        <p>
          <strong>Bulma</strong> by
          <a href="https://jgthms.com">Jeremy Thomas</a>. The source code is
          licensed
          <a href="http://opensource.org/licenses/mit-license.php">MIT</a>. The
          website content is licensed
          <a href="http://creativecommons.org/licenses/by-nc-sa/4.0/"
            >CC BY NC SA 4.0</a
          >.
        </p>
      </div>
    </footer>
  </div>
</template>

<script>
import Login from "~/components/Login.vue";
import SignUp from "~/components/SignUp.vue";
import Modal from "~/components/Modal.vue";
import * as firebase from "@/plugins/firebase";

export default {
  middleware: ["routing"],

  components: {
    Login,
    SignUp,
    Modal,
  },
  data() {
    return {
      isModalForm: false,
      FormComponent: "",
    };
  },
  created() {
    this.Auth();
  },
  methods: {
    closeModal() {
      this.isModalForm = false;
    },
    ChangeForm(FormComponent) {
      console.log(FormComponent);
      this.FormComponent = FormComponent;
    },
    logout() {
      firebase
        .auth()
        .signOut()
        .then(() => {
          alert("logout seccessful!");
          window.location.href = "/";
        })
        .catch((e) => {
          console.log(e);
          console.log("an error happened");
        });
      this.$auth.logout();
      localStorage.clear();
      console.log(this.$auth.loggedIn);
    },
    Auth() {
      if (
        this.$auth.$state.strategy &&
        this.$auth.loggedIn &&
        !localStorage.idToken &&
        !this.$route.query.token
      ) {
        console.log("heyhey");
        console.log(localStorage.auth_status);

        this.$axios
          .$post("/api/v1/login", {
            email: this.$auth.user.email,
            provider: this.$auth.$state.strategy,
            auth_status: localStorage.auth_status,
          })
          .then((res) => {
            // console.log(res.tag)
            console.log(res.token);
            localStorage.setItem("idToken", res.token);
            this.$buefy.toast.open({
              duration: 5000,
              message: "ログインに成功しました",
              type: "is-success",
            });
          })
          .catch((error) => {
            if (error.response.status == "401") {
              console.log("tokenが無効です");
              this.$buefy.toast.open({
                duration: 5000,
                message: "サーバー内でも問題が発生しました",
                type: "is-danger",
              });
            } else if (error.response.status == "422") {
              this.$auth.logout();
              localStorage.clear();
              console.log(error.response);
              this.$buefy.toast.open({
                duration: 5000,
                message: error.response.data.validation,
                type: "is-danger",
              });
            }
          });
      }
    },
  },
};
</script>
